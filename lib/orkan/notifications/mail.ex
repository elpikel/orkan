defmodule Orkan.Notifications.Mail do
  import Bamboo.Email

  alias Orkan.Notifications.Mailer

  def send(user, forecasts) do
    user
    |> forecast_email(forecasts)
    |> Mailer.deliver_now!()
  end

  def forecast_email(user, forecasts) do
    html =
      EEx.eval_file(
        Path.join([:code.priv_dir(:orkan), "templates", "forecast.html.eex"]),
        forecasts: forecasts
      )

    new_email()
    |> from("Orkan<info@orkan.com>")
    |> to(user.email)
    |> subject("Orkan: forecast")
    |> html_body(html)
  end
end
