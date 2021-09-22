defmodule Orkan.Notifications do
  alias Orkan.Subscriptions
  alias Orkan.Forecasts
  alias Orkan.Notifications.Mail

  def send_forecasts() do
    Enum.each(Subscriptions.users(), fn user ->
      forecasts = Forecasts.get(user)

      Mail.send(user, forecasts)
    end)
  end
end
