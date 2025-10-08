defmodule OryKratosAdmin.Repo.Migrations.CreateIdentities do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:identities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :traits, :map
      add :metadata_public, :map
      add :metadata_admin, :map
      add :schema_id, :string

      timestamps(type: :utc_datetime, inserted_at: :created_at)
    end
  end
end
