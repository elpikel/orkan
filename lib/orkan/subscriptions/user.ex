defmodule Orkan.Subscriptions.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Orkan.Subscriptions.Subscription

  schema "users" do
    field :email, :string

    has_many :subscription, Subscription
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
