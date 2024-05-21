defmodule CrudElixirProject.Infrastructure.DrivenAdapters.ClientCache do

  alias CrudElixirProject.Domain.Behaviours.ClientRepositoryBehaviour
  @behaviour ClientRepositoryBehaviour

  def save_client(client) do
    with encoded_client <- encode_client(client),
         uuid <- UUID.uuid4() do
      Redix.noreply_command(:redix, ["SET", uuid, encoded_client]) |> extract_noreply(uuid)
         end
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

end