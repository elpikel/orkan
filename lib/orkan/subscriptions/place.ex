defmodule Orkan.Subscriptions.Place do
  use Ecto.Schema

  import Ecto.Changeset

  schema "places" do
    field :latitude, :string
    field :longitude, :string
    field :name, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:latitude, :longitude, :name])
    |> validate_required([:latitude, :longitude, :name])
    |> unique_constraint([:latitude, :longitude])
  end
end
