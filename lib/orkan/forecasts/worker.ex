defmodule Orkan.Forecasts.Worker do
  alias Orkan.Subscriptions
  alias Orkan.Forecasts

  def update_forecasts() do
    places = Subscriptions.places()

    Forecasts.update_forecasts(places)
  end
end
