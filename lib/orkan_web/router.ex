defmodule OrkanWeb.Router do
  use OrkanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", OrkanWeb do
    pipe_through :browser

    get "/", SubscriptionsController, :index
    post "/", SubscriptionsController, :create
  end
end
