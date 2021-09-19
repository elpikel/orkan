defmodule Orkan.Subscriptions.Subscription do
  use Ecto.Schema

  import Ecto.Changeset

  alias Orkan.Forecasts.Place
  alias Orkan.Subscriptions.User

  schema "subscriptions" do
    belongs_to :place, Place
    belongs_to :user, User
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:place_id, :user_id])
    |> validate_required([:place_id, :user_id])
    |> unique_constraint([:place_id, :user_id])
  end
end
