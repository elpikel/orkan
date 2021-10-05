defmodule Orkan.Forecasts.Forecast do
  use Ecto.Schema

  import Ecto.Changeset

  schema "forecasts" do
    field :datetime, :utc_datetime
    field :wind_speed, :float
    field :wind_direction, :integer
    field :place_id, :integer
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:wind_speed, :wind_direction])
    |> validate_required([:wind_speed, :wind_direction])
  end
end
