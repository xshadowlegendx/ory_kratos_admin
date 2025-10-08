defmodule OryKratosAdmin.Kratos.Identity do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "identities" do
    field :traits, :map
    field :metadata_public, :map
    field :metadata_admin, :map
    field :schema_id, :string

    timestamps(type: :utc_datetime, inserted_at: :created_at)
  end

  @doc false
  def changeset(identity, attrs) do
    identity
    |> cast(attrs, [:traits, :metadata_public, :metadata_admin, :schema_id])
    |> validate_required([:schema_id])
  end
end
