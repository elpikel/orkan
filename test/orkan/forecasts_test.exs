defmodule Orkan.ForecastsTest do
  use Orkan.DataCase

  alias Orkan.Forecasts
  alias Orkan.Forecasts.Place

  test "updates data" do
    Repo.insert(%Place{longitude: "54.7147", latitude: "18.5581", name: "Jastarnia"})

    forecasts = Forecasts.update()

    assert length(forecasts) == 168
  end
end
