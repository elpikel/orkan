defmodule Orkan.Notifications.MailTest do
  use Orkan.DataCase
  use Bamboo.Test

  alias Orkan.Forecasts.Forecast
  alias Orkan.Forecasts.Place
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User
  alias Orkan.Notifications.Mail

  test "sends data" do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    place = Repo.insert!(%Place{longitude: "54.7147", latitude: "18.5581", name: "Jastarnia"})
    user = Repo.insert!(%User{email: "test@test.te"})
    Repo.insert!(%Subscription{place_id: place.id, user_id: user.id})

    forecast =
      Repo.insert!(%Forecast{
        place_id: place.id,
        datetime: now,
        wind_speed: 12.22,
        wind_direction: 5
      })

    expected_email = Mail.forecast_email(user, [forecast])

    Mail.send(user, [forecast])

    assert_delivered_email(expected_email)
  end
end
