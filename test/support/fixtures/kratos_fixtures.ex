defmodule OryKratosAdmin.KratosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OryKratosAdmin.Kratos` context.
  """

  @doc """
  Generate a identity.
  """
  def identity_fixture(attrs \\ %{}) do
    {:ok, identity} =
      attrs
      |> Enum.into(%{
        metadat_admin: %{},
        metadata_public: %{},
        schema_id: "some schema_id",
        traits: %{}
      })
      |> OryKratosAdmin.Kratos.create_identity()

    identity
  end
end
