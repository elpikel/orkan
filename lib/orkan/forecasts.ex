defmodule Orkan.Forecasts do
  import Ecto.Query

  alias Orkan.Forecasts.Forecast
  alias Orkan.Forecasts.Place
  alias Orkan.OpenMeteo.Client
  alias Orkan.Repo
  alias Orkan.Subscriptions.Subscription

  def get_or_create_place(longitude, latitude, name) do
    case Repo.one(from p in Place, where: p.longitude == ^longitude and p.latitude == ^latitude) do
      nil ->
        {:ok, place} =
          Repo.insert(
            Place.changeset(%Place{}, %{longitude: longitude, latitude: latitude, name: name}),
            on_conflict: [set: [name: name]],
            conflict_target: [:longitude, :latitude]
          )

        place

      place ->
        place
    end
  end

  def get(user) do
    today = DateTime.new!(Date.utc_today(), ~T[00:00:00.000], "Etc/UTC")
    tomorrow = add_days(today, 1)
    in_two_days = add_days(tomorrow, 2)

    query =
      from s in Subscription,
        join: p in Place,
        on: p.id == s.place_id,
        join: f in Forecast,
        on: f.place_id == p.id,
        select: {p.name, f.datetime, f.wind_speed, f.wind_direction},
        where: s.user_id == ^user.id and f.datetime >= ^tomorrow and f.datetime < ^in_two_days,
        order_by: [p.name, f.datetime]

    Repo.all(query)
    |> Enum.group_by(fn {name, _, _, _} -> name end)
    |> Enum.map(fn {name, forecasts} ->
      %{
        place: name,
        forecasts:
          Enum.map(forecasts, fn {_, datetime, wind_speed, wind_direction} ->
            %{
              datetime: datetime,
              wind_speed: wind_speed,
              wind_direction: wind_direction
            }
          end)
      }
    end)
  end

  def update() do
    Place
    |> Repo.all()
    |> Enum.map(fn place -> update(place) end)
    |> List.flatten()
  end

  defp update(place) do
    forecasts = Client.get_data(place.longitude, place.latitude)

    forecasts["hourly"]["time"]
    |> Enum.with_index()
    |> Enum.map(fn {datetime, index} ->
      datetime = format(datetime)

      forecast =
        Repo.one(from f in Forecast, where: f.place_id == ^place.id and f.datetime == ^datetime)

      wind_speed = to_float(Enum.at(forecasts["hourly"]["windspeed_10m"], index))
      wind_direction = Enum.at(forecasts["hourly"]["winddirection_10m"], index)

      case forecast do
        nil ->
          Repo.insert!(%Forecast{
            place_id: place.id,
            wind_direction: wind_direction,
            wind_speed: wind_speed,
            datetime: datetime
          })

        _ ->
          forecast
          |> Forecast.changeset(%{wind_speed: wind_speed, wind_direction: wind_direction})
          |> Repo.update!()
      end
    end)
  end

  defp format(datetime) do
    {:ok, datetime, 0} = DateTime.from_iso8601(datetime <> ":00Z")
    datetime
  end

  defp to_float(value) when is_integer(value) do
    {converted, _} = Float.parse("#{value}")
    converted
  end

  defp to_float(value) do
    value
  end

  defp add_days(datetime, days) do
    DateTime.add(datetime, days * 24 * 60 * 60, :second)
  end
end
