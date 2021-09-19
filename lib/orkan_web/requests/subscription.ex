defmodule OrkanWeb.Requests.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :email, :string
    field :place_id, :string
  end

  def changeset(option, attrs) do
    option
    |> cast(attrs, [:email, :place_id])
    |> validate_required([:email, :place_id])
  end
end
