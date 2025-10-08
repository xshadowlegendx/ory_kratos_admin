defmodule OryKratosAdmin.KratosTest do
  use OryKratosAdmin.DataCase

  alias OryKratosAdmin.Kratos

  describe "identities" do
    import OryKratosAdmin.KratosFixtures

    test "list_identities/0 returns identities" do
      identity = identity_fixture()
      assert Kratos.list_identities(%{"page_size" => 1, "page_number" => 0}) == {[identity], 1}

      identity_fixture(%{traits: %{username: "suli"}})
      identity_fixture(%{traits: %{username: "ggwp"}})
      identity_fixture(%{traits: %{username: "hala"}})
      identity = identity_fixture(%{traits: %{"username" => "hoehoe"}})

      assert Kratos.list_identities(%{"page_size" => 2, "page_number" => 0, "identifier.contains" => "username,hoe"}) == {[identity], 1}
    end
  end
end
