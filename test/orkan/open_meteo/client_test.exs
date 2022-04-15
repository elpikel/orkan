defmodule Orkan.OpenMeteo.ClientTest do
  use ExUnit.Case

  alias Orkan.OpenMeteo.Client

  test "gets data" do
    data = Client.get_data("54.7147", "18.5581")

    assert %{
             "elevation" => _,
             "generationtime_ms" => _,
             "hourly" => %{
               "time" => _,
               "winddirection_10m" => _,
               "windspeed_10m" => _
             },
             "hourly_units" => %{
               "time" => "iso8601",
               "winddirection_10m" => "°",
               "windspeed_10m" => "km/h"
             },
             "latitude" => _,
             "longitude" => _,
             "utc_offset_seconds" => 0
           } = data
  end
end
