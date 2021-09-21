defmodule OrkanWeb.SubscriptionsControllerTest do
  use OrkanWeb.ConnCase

  import Ecto.Query

  alias Orkan.Repo
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User
  alias Orkan.Forecasts.Place

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Orkan"
  end

  test "POST /", %{conn: conn} do
    email = "email@server.com"
    latitude = "54.7147"
    longitude = "18.5581"
    name = "name"

    subscription_request = %{
      "email" => email,
      "latitude" => latitude,
      "longitude" => longitude,
      "name" => name
    }

    conn = post(conn, "/", %{"subscription" => subscription_request})

    assert redirected_to(conn)

    assert Repo.aggregate(from(s in Subscription), :count, :id) == 1

    [place] = Repo.all(from(p in Place))
    assert place.name == name
    assert place.latitude == latitude
    assert place.longitude == longitude

    [user] = Repo.all(from(u in User))
    assert user.email == email
  end
end
