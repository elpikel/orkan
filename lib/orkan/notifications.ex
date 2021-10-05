defmodule Orkan.Notifications do
  alias Orkan.Subscriptions
  alias Orkan.Forecasts
  alias Orkan.Notifications.Mail

  def send_forecasts() do
    Enum.each(Subscriptions.users(), fn user ->
      places = Subscriptions.places(user.id)
      forecasts = Forecasts.get(places)

      Mail.send(user, forecasts)
    end)
  end
end
