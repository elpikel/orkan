defmodule Orkan.Notifications.Mail do
  use Bamboo.Phoenix, view: OrkanWeb.EmailView

  import Bamboo.Email

  alias Orkan.Notifications.Mailer

  def send(user, forecasts) do
    user
    |> forecast_email(forecasts)
    |> Mailer.deliver_now!()
  end

  def forecast_email(user, forecasts) do
    new_email()
    |> from("Orkan<info@orkan.com>")
    |> to(user.email)
    |> subject("Orkan: forecast")
    |> assign(:forecasts, forecasts)
    |> render("forecast.html")
  end
end
