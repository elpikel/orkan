defmodule Orkan.SubscriptionsTest do
  use Orkan.DataCase

  alias Orkan.Subscriptions
  alias Orkan.Repo

  test "creates subscription" do
    {:ok, subscription} =
      Subscriptions.create(%{
        email: "mail@mail.com",
        longitude: "10.1",
        latitude: "3.3",
        name: "name"
      })

    subscription = Repo.preload(subscription, [:user, :place])

    assert subscription.user.email == "mail@mail.com"
    assert subscription.place.name == "name"
    assert subscription.place.longitude == "10.1"
    assert subscription.place.latitude == "3.3"
  end

  test "returns error if user already subscribed" do
    {:ok, _subscription} =
      Subscriptions.create(%{
        email: "mail@mail.com",
        longitude: "10.1",
        latitude: "3.3",
        name: "name"
      })

    {:error, error_message} =
      Subscriptions.create(%{
        email: "mail@mail.com",
        longitude: "10.1",
        latitude: "3.3",
        name: "name"
      })

    assert error_message == "Already subscribed."
  end
end
