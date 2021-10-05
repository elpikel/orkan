defmodule Orkan.ForecastsTest do
  use Orkan.DataCase

  alias Orkan.Forecasts
  alias Orkan.Subscriptions.Place

  test "updates data" do
    {:ok, place} =
      Repo.insert(%Place{longitude: "54.7147", latitude: "18.5581", name: "Jastarnia"})

    forecasts = Forecasts.update_forecasts([place])

    assert length(forecasts) == 168
  end
end
