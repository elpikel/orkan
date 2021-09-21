defmodule OrkanWeb.SubscriptionsController do
  use OrkanWeb, :controller

  alias Orkan.Subscriptions
  alias OrkanWeb.Requests.Subscription

  def index(conn, _params) do
    render(conn, "index.html", changeset: Subscription.changeset(%Subscription{}, %{}))
  end

  def create(conn, %{"subscription" => subscription_params}) do
    changeset = Subscription.changeset(%Subscription{}, subscription_params)

    if changeset.valid? do
      case Subscriptions.create(changeset.changes) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Succesfully subscribed.")
          |> redirect(to: Routes.subscriptions_path(conn, :index))

        {:error, error} ->
          conn
          |> put_flash(:error, error)
          |> render("index.html", changeset: changeset)
      end
    else
      render(conn, "index.html", changeset: %{changeset | action: :insert})
    end
  end
end
