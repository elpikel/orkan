defmodule Orkan.Notifications.MailTest do
  use Orkan.DataCase
  use Bamboo.Test

  alias Orkan.Forecasts
  alias Orkan.Forecasts.Forecast
  alias Orkan.Notifications.Mail
  alias Orkan.Subscriptions.Place
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User

  test "sends data" do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    place = Repo.insert!(%Place{longitude: "54.7147", latitude: "18.5581", name: "Jastarnia"})
    user = Repo.insert!(%User{email: "test@test.te"})
    Repo.insert!(%Subscription{place_id: place.id, user_id: user.id})

    Repo.insert!(%Forecast{
      place_id: place.id,
      datetime: now,
      wind_speed: 12.22,
      wind_direction: 5
    })

    forecasts = Forecasts.get([place])

    expected_email = Mail.forecast_email(user, forecasts)

    Mail.send(user, forecasts)

    assert_delivered_email(expected_email)
  end
end
