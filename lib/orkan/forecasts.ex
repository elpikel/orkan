defmodule Orkan.Forecasts do
  import Ecto.Query

  alias Orkan.Forecasts.Forecast
  alias Orkan.OpenMeteo.Client
  alias Orkan.Repo

  def get(places) do
    today = DateTime.new!(Date.utc_today(), ~T[00:00:00.000], "Etc/UTC")
    tomorrow = add_days(today, 1)
    in_two_days = add_days(tomorrow, 2)
    places_id = Enum.map(places, fn place -> place.id end)

    query =
      from f in Forecast,
        select: {f.place_id, f.datetime, f.wind_speed, f.wind_direction},
        where: f.datetime >= ^tomorrow and f.datetime < ^in_two_days,
        where: f.place_id in ^places_id,
        order_by: [f.place_id, f.datetime]

    Repo.all(query)
    |> Enum.group_by(fn {place_id, _, _, _} -> place_id end)
    |> Enum.map(fn {place_id, forecasts} ->
      place = Enum.find(places, fn place -> place.id == place_id end)

      %{
        place: place.name,
        place_forecasts:
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

  def update_forecasts(places) do
    places
    |> Enum.map(fn place -> update_forecast(place) end)
    |> List.flatten()
  end

  defp update_forecast(place) do
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
