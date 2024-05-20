defmodule CrudElixirProject.Infrastructure.DrivenAdapters.ClientCache do

  alias CrudElixirProject.Domain.Behaviours.ClientRepositoryBehaviour
  @behaviour ClientRepositoryBehaviour

  def save_client(client) do
    with encode_client <- Poison.encode(client),
         uuid <- UUID.uuid4() do
      Redix.noreply_command(:redix, ["SET",uuid, encode_client]) |> extract_noreply(uuid)
         end
  end

  def extract_noreply(response, uuid) do
    case response do
      :ok -> {:ok, uuid}
      _ -> {:error, :couldnt_save_client}
    end
  end

end