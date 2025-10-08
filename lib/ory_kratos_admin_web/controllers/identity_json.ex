defmodule OryKratosAdminWeb.IdentityJSON do
  alias OryKratosAdmin.Kratos.Identity

  @doc """
  Renders a list of identities.
  """
  def index(%{identities: identities}) do
    for(identity <- identities, do: data(identity))
  end

  defp data(%Identity{} = identity) do
    identity
    |> Map.from_struct()
    |> Map.drop([:__meta__])
  end
end
