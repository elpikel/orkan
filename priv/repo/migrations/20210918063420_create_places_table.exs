defmodule Orkan.Repo.Migrations.CreatePlacesTable do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :latitude, :string
      add :longitude, :string
      add :name, :string
    end

    create unique_index(:places, [:latitude, :longitude])
  end
end
