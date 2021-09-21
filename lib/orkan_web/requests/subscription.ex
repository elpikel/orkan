defmodule OrkanWeb.Requests.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  require Decimal

  @fields [:email, :longitude, :latitude, :name]
  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @primary_key false
  embedded_schema do
    field :email, :string
    field :longitude, :string
    field :latitude, :string
    field :name, :string
  end

  def changeset(option, attrs) do
    option
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_format(:email, @mail_regex)
    |> validate_coordinates([:longitude, :latitude])
  end

  defp validate_coordinates(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      field_value = get_change(changeset, field)

      if field_value != nil && !valid_coordinate?(field_value) do
        add_error(changeset, field, "not valid coordinate")
      else
        changeset
      end
    end)
  end

  defp valid_coordinate?(coordinate) do
    case Decimal.parse(coordinate) do
      :error ->
        false

      {:ok, coordinate} ->
        if Decimal.cmp(coordinate, 0) == :lt do
          false
        else
          true
        end
    end
  end
end
