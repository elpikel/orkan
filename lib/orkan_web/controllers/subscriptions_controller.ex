defmodule OrkanWeb.SubscriptionsController do
  use OrkanWeb, :controller

  alias Orkan.Subscriptions
  alias OrkanWeb.Requests.Subscription

  def index(conn, _params) do
    render(conn, "index.html",
      places: map_places(Subscriptions.get_places()),
      changeset: Subscription.changeset(%Subscription{}, %{})
    )
  end

  def create(conn, %{"subscription" => subscription_params}) do
    changeset = Subscription.changeset(%Subscription{}, subscription_params)

    if changeset.valid? do
      case Subscriptions.create(subscription_params) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Succesfully subscribed.")
          |> redirect(to: Routes.subscriptions_path(conn, :index))

        {:error, error} ->
          conn
          |> put_flash(:error, error)
          |> render("index.html",
            places: map_places(Subscriptions.get_places()),
            changeset: changeset
          )
      end
    else
      render(conn, "index.html",
        places: map_places(Subscriptions.get_places()),
        changeset: %{changeset | action: :insert}
      )
    end
  end

  defp map_places(places) do
    Enum.map(places, fn place -> {place.name, place.id} end)
  end
end
