defmodule OrkanWeb.PageController do
  use OrkanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
