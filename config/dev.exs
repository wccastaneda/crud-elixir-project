import Config

config :crud_elixir_project, timezone: "America/Bogota"

config :crud_elixir_project,
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  version: "0.0.1",
  in_test: false,
  custom_metrics_prefix_name: "crud_elixir_project_local"

config :crud_elixir_project,
       client_id: "123456",
       client_secret: "qwerty"

config :crud_elixir_project,
       redis_host: "localhost",
       redis_port: 6379

config :crud_elixir_project,
       client_repository: CrudElixirProject.Infrastructure.DrivenAdapters.ClientCache

config :logger,
  level: :debug

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: {:otel_exporter_stdout, []}
