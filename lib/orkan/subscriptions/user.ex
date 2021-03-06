defmodule Orkan.Subscriptions.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Orkan.Subscriptions.Subscription

  schema "users" do
    field :email, :string

    has_many :subscriptions, Subscription
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> unique_constraint([:email])
  end
end
