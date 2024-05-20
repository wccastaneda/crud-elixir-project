defmodule CrudElixirProject.Config.AppConfig do

  @moduledoc """
   Provides strcut for app-config
  """

   defstruct [
     :enable_server,
     :http_port,
     :crud_client_id,
     :crud_client_secret,
     :redis_adapter_host,
     :redis_adapter_port
   ]

   def load_config do
     %__MODULE__{
       enable_server: load(:enable_server),
       http_port: load(:http_port),
       crud_client_id: load(:client_id),
       crud_client_secret: load(:client_secret),
       redis_adapter_host: load(:redis_host),
       redis_adapter_port: load(:redis_port)
     }
   end

   defp load(property_name), do: Application.fetch_env!(:crud_elixir_project, property_name)
 end
