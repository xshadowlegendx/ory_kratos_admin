defmodule OryKratosAdminWeb.IdentityControllerTest do
  use OryKratosAdminWeb.ConnCase

  import OryKratosAdmin.KratosFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all identities with pagings", %{conn: conn} do
      conn = get(conn, ~p"/api/identities")
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

    test "list identities with sort direction", %{conn: conn} do
      %{identity: idx0} = create_identity(%{
        traits: %{idx: "lala"},
        created_at: DateTime.add(DateTime.utc_now(), 2, :day)
      })

      %{identity: idx1} = create_identity(%{
        traits: %{idx: "lala"},
        created_at: DateTime.add(DateTime.utc_now(), -2, :day)
      })

      %{identity: idx2} = create_identity(%{
        traits: %{idx: "fefe"},
        created_at: DateTime.add(DateTime.utc_now(), -4, :day)
      })

      conn = get(conn, ~p"/api/identities?sort_direction=asc")
      res = json_response(conn, 200)
      assert Enum.map(res, & &1["id"]) == [idx2.id, idx1.id, idx0.id]

      conn = get(conn, ~p"/api/identities?sort_direction=desc")
      res = json_response(conn, 200)
      assert Enum.map(res, & &1["id"]) == [idx0.id, idx1.id, idx2.id]
    end
  end

  defp create_identity(args) do
    identity = identity_fixture(args)

    %{identity: identity}
  end
end
