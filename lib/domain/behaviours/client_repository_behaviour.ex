defmodule CrudElixirProject.Domain.Behaviours.ClientRepositoryBehaviour do

  @callback save_client(client :: term) :: {:ok, true :: term} | {:error, reason :: term}
  @callback get_client(uuid :: term) :: {:ok, client :: term} | {:error, reason :: term}

end