defmodule Orkan.Repo.Migrations.CreateForecastTable do
  use Ecto.Migration

  def change do
    create table(:forecasts) do
      add :longitude, :string
      add :latitude, :string
      add :datetime, :utc_datetime
      add :wind_speed, :float
      add :wind_direction, :integer
      add :place_id, references(:places)
    end

    create unique_index(:forecasts, [:place_id, :datetime])
  end
end
