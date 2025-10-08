defmodule OryKratosAdmin.Repo do
  use Ecto.Repo,
    otp_app: :ory_kratos_admin,
    adapter: Ecto.Adapters.Postgres
end
