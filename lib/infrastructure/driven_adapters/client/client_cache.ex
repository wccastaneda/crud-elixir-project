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

  def get_client(uuid) do
    with {:ok, response} <- extract_redix_get_result(uuid),
         decoded_response <- decode_response(response),
         normalized_response <- DataTypeUtils.normalize(decoded_response) do
      {:ok, normalized_response}
    end
  end

  def extract_redix_get_result(uuid) do
    Redix.command(:redix, ["GET", uuid])
    |>
      case do
        {:ok, nil} -> {:error, :client_not_exists}
        {:ok, 0} -> {:error, :client_not_exists}
        {:ok, response} -> {:ok, response}
        other -> other
      end
  end

  def decode_response(response) do
    Poison.decode!(response)
  end
end