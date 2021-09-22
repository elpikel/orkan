defmodule Orkan.Subscriptions.Mailer do
  use Bamboo.Mailer, otp_app: :orkan
  use Bamboo.Phoenix, view: OrkanWeb.EmailView

  import Bamboo.Email

  def send(user, forecasts) do
    user
    |> forecast_email(forecasts)
    |> deliver_now!()
  end

  def forecast_email(user, forecasts) do
    new_email()
    |> from("Orkan<info@orkan.com>")
    |> to(user.email)
    |> subject("Orkan: wind alert")
    |> assign(:forecasts, forecasts)
    |> render("wind_alert.html")
  end
end
