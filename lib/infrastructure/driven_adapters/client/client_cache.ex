defmodule CrudElixirProject.Infrastructure.DrivenAdapters.ClientCache do

  alias CrudElixirProject.Domain.Behaviours.ClientRepositoryBehaviour
  alias CrudElixirProject.Utils.DataTypeUtils
  @behaviour ClientRepositoryBehaviour

  def save_client(client) do
    with encoded_client <- encode_client(client),
         uuid <- UUID.uuid4() do
      Redix.noreply_command(:redix, ["SET", uuid, encoded_client]) |> extract_noreply(uuid)
         end
  end

  def get_client(uuid) do
    Redix.command(:redix, ["GET", uuid])
    |> extract_get_result()
  end

  def encode_client(client) do
    case Poison.encode(client) do
      {:ok, encoded_client} -> encoded_client
      {:error, reason} -> {:error, reason}
    end
  end

  def extract_noreply(response, uuid) do
    case response do
      :ok -> {:ok, uuid}
      _ -> {:error, :couldnt_save_client}
    end
  end

  def extract_get_result(response) do
    case response do
      {:ok, nil} -> {:error, :client_not_exists}
      {:ok, 0} -> {:error, :client_not_exists}
      {:ok, response} -> {:ok, Poison.decode!(response) |> DataTypeUtils.normalize()}
      other -> other
    end
  end

end