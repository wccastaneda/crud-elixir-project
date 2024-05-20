defmodule CrudElixirProject.Infrastructure.DrivenAdapters.Redis do

  use GenServer
  require Logger
  alias CrudElixirProject.Config.ConfigHolder

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    %{
      redis_adapter_host: host,
      redis_adapter_port: port
    } = ConfigHolder.conf()

    Redix.start_link(host: host, port: port, name: :redix)
  end

  def health() do
    case Redix.command!(:redix, ["PING"]) do
      "PONG" -> {:ok, true}
      error -> {:error, error}
    end
  end

end