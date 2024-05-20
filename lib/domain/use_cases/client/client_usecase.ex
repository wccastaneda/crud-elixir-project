defmodule CrudElixirProject.Domain.UseCases.Client.ClientUsecase do

  alias CrudElixirProject.Domain.Model.Client
  require Logger

  def register_client(%Client{} = client) do
    with {:ok, true} <- Client.validate_client_data(client) do
      {:ok, true}
    else
      error ->
        Logger.error("Error en caso de uso #{inspect(error)}")
        error
    end
  end
end