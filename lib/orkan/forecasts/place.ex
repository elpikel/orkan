defmodule Orkan.Forecasts.Place do
  use Ecto.Schema

  import Ecto.Changeset

  alias Orkan.Forecasts.Forecast

  schema "places" do
    field :latitude, :string
    field :longitude, :string
    field :name, :string

    has_many :forecasts, Forecast
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:latitude, :longitude, :name])
    |> validate_required([:latitude, :longitude, :name])
    |> unique_constraint([:latitude, :longitude])
  end
end
