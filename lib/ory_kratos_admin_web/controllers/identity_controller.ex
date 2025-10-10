defmodule OryKratosAdminWeb.IdentityController do
  use OryKratosAdminWeb, :controller

  alias OryKratosAdmin.Kratos

  action_fallback OryKratosAdminWeb.FallbackController

  def index(conn, args) do
    {identities, total_count} =
      args
      |> parse_page_size()
      |> parse_page_number()
      |> Kratos.list_identities()

    conn
    |> Plug.Conn.put_resp_header("x-paging-total-count", "#{total_count}")
    |> render(:index, identities: identities)
  end

  defp parse_page_size(%{"page_size" => page_size} = args) do
    page_size = String.to_integer(page_size)

    %{args | "page_size" => (if page_size > 32, do: 32, else: page_size)}
  end

  defp parse_page_size(args),
    do: Map.put(args, "page_size", 8)

  defp parse_page_number(%{"page_number" => page_number} = args) do
    page_number = String.to_integer(page_number)

    %{args | "page_number" => page_number}
  end

  defp parse_page_number(args),
    do: Map.put(args, "page_number", 0)
end
