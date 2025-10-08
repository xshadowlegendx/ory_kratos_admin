# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ory_kratos_admin,
  ecto_repos: [OryKratosAdmin.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :ory_kratos_admin, OryKratosAdminWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: OryKratosAdminWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: OryKratosAdmin.PubSub,
  live_view: [signing_salt: "uZc288vj"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ory_kratos_admin, OryKratosAdmin.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  ory_kratos_admin: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  ory_kratos_admin: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :opentelemetry,
  span_processor: :batch,
  traces_exporter: :otlp

config :cors_plug,
  expose: ["x-paging-total-count"]

# config :opentelemetry, :resource, service: %{name: "ory-kratos-admin"}

# config :opentelemetry_exporter,
#   otlp_protocol: :grpc,
#   otlp_endpoint: "http://localhost:5081/api/default",
#   otlp_headers: [
#     {"stream-name", "ory_kratos_admin"},
#     {"organization", "default"},
#     {"authorization", "Basic YWRtaW5AYWNtZS5vcmc6cGFzc3dvcmQ="}
#   ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
