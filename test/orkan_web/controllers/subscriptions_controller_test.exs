defmodule OrkanWeb.SubscriptionsControllerTest do
  use OrkanWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Orkan"
  end
end
