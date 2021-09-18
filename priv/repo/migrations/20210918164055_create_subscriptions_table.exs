defmodule Orkan.Repo.Migrations.CreateSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :place_id, references(:places)
      add :user_id, references(:users)
    end

    create unique_index(:subscriptions, [:place_id, :user_id])
  end
end
