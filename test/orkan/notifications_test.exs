defmodule Orkan.NotificationsTest do
  use Orkan.DataCase

  alias Orkan.Forecasts
  alias Orkan.Notifications
  alias Orkan.Subscriptions.Place
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User

  test "sends data" do
    place = Repo.insert!(%Place{longitude: "54.7147", latitude: "18.5581", name: "Jastarnia"})
    user = Repo.insert!(%User{email: "test@test.te"})
    Repo.insert!(%Subscription{place_id: place.id, user_id: user.id})

    Forecasts.update_forecasts([place])

    Notifications.send_forecasts()
  end
end
