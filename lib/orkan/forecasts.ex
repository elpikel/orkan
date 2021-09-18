defmodule Orkan.Forecasts do
  import Ecto.Query

  alias Orkan.Repo
  alias Orkan.OpenMeteo.Client
  alias Orkan.Forecasts.Forecast
  alias Orkan.Forecasts.Place

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
end
