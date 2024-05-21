import Config

config :crud_elixir_project, timezone: "America/Bogota"

config :crud_elixir_project,
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  version: "0.0.1",
  in_test: true,
  custom_metrics_prefix_name: "crud_elixir_project_test"


config :crud_elixir_project,
       client_id: "123456",
       client_secret: "qwerty"

config :crud_elixir_project,
       redis_host: "localhost",
       redis_port: "6379"

config :crud_elixir_project,
       client_repository: CrudElixirProject.Infrastructure.DrivenAdapters.ClientCache

config :logger,
  level: :info

config :junit_formatter,
  report_dir: "_build/release",
  report_file: "test-junit-report.xml"

config :elixir_structure_manager, # used with mix ca.release --container
  container_tool: "docker",
  container_file: "resources/cloud/Dockerfile-build",
  container_base_image: "1.16.2-otp-26-alpine" # change by your preferred image

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: {:otel_exporter_stdout, []}
