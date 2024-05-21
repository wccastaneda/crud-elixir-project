defmodule CrudElixirProject.Domain.UseCases.Client.ClientUsecase do

  alias CrudElixirProject.Domain.Model.Client
  require Logger
  @client_repository Application.compile_env(:crud_elixir_project, :client_repository)

  def register_client(%Client{} = client) do
    with {:ok, true} <- validate_client_data(client),
         {:ok, uuid} <- @client_repository.save_client(client) do
      {:ok, uuid}
    else
      error ->
        Logger.error("Error en caso de uso #{inspect(error)}")
        error
    end
  end

  def validate_client_data(%Client{} = client)
      when byte_size(client.name) == 0 or
           byte_size(client.last_name) == 0 or
           byte_size(client.email) == 0 or
           byte_size(client.age) == 0 do
    {:error, :missing_client_data}
  end

  def validate_client_data(%Client{:age => age}) when not is_integer(age) or age < 15 do
    {:error, :age_not_allowed}
  end

  def validate_client_data(%Client{:name => name, :last_name => last_name})
      when byte_size(name) < 3 or
           byte_size(last_name) < 3 do
    {:error, :name_not_valid}
  end

  def validate_client_data(_client_data) do
    {:ok, true}
  end
end