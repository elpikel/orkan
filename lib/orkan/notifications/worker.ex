defmodule Orkan.Notifications.Worker do
  alias Orkan.Notifications

  def send_forecasts() do
    Notifications.send_forecasts()
  end
end
