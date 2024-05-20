defmodule CrudElixirProject.Application do
  @moduledoc """
  CrudElixirProject application
  """

  alias CrudElixirProject.Infrastructure.EntryPoint.ApiRest
  alias CrudElixirProject.Config.{AppConfig, ConfigHolder}
  alias CrudElixirProject.Utils.CustomTelemetry
  alias CrudElixirProject.Infrastructure.DrivenAdapters.Redis

  use Application
  require Logger

  def start(_type, [env]) do
    config = AppConfig.load_config()

    children = with_plug_server(config) ++ all_env_children() ++ env_children(env)

    CustomTelemetry.custom_telemetry_events()
    OpentelemetryPlug.setup()
    opts = [strategy: :one_for_one, name: CrudElixirProject.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}. ")
    [{Plug.Cowboy, scheme: :http, plug: ApiRest, options: [port: port]}]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def all_env_children() do
    [
      {ConfigHolder, AppConfig.load_config()},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}
    ]
  end

  def env_children(:test) do
    []
  end

  def env_children(_other_env) do
    [
      {Redis, []}
    ]
  end
end
