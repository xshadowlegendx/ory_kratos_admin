defmodule OryKratosAdminWeb.IdentityControllerTest do
  use OryKratosAdminWeb.ConnCase

  import OryKratosAdmin.KratosFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all identities", %{conn: conn} do
      conn = get(conn, ~p"/api/identities?page_size=1&page_number=0")
      assert ["0"] = get_resp_header(conn, "x-paging-total-count")
      assert json_response(conn, 200) == []

      %{identity: identity} = create_identity(%{
        traits: %{idx: "fulala"},
        metadata_public: %{eid: 12},
        metadata_admin: %{loli: [1, "3", nil]}
      })

      conn = get(conn, ~p"/api/identities?page_size=1&page_number=0")
      assert ["1"] = get_resp_header(conn, "x-paging-total-count")
      [el] = json_response(conn, 200)
      assert el["id"] == identity.id
      assert el["metadata_admin"] == %{"loli" => [1, "3", nil]}
      assert el["metadata_public"] == %{"eid" => 12}
      assert el["traits"] == %{"idx" => "fulala"}
      assert not is_nil(el["created_at"])
      assert not is_nil(el["updated_at"])
    end
  end

  defp create_identity(args) do
    identity = identity_fixture(args)

    %{identity: identity}
  end
end
