defmodule OrkanWeb.SubscriptionsControllerTest do
  use OrkanWeb.ConnCase

  import Ecto.Query

  alias Orkan.Repo
  alias Orkan.Subscriptions.Subscription

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Orkan"
  end

  test "POST /", %{conn: conn} do
    subscription_request = %{
      "email" => "email@server.com",
      "latitude" => "54.7147",
      "longitude" => "18.5581",
      "name" => "name"
    }

    conn = post(conn, "/", %{"subscription" => subscription_request})

    assert redirected_to(conn)

    assert Repo.aggregate(from(s in Subscription), :count, :id) == 1
    # TODO check rest
  end
end
