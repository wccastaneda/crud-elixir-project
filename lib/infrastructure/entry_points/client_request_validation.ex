defmodule CrudElixirProject.Infrastructure.EntryPoint.ClientRequestValidation do

  alias CrudElixirProject.Config.ConfigHolder

  def validate_request_body(request) when is_nil(request) do
    {:error, :empty_request}
  end

  def validate_request_body(request) when is_nil(request.data) do
    {:error, :empty_data}
  end

  def validate_request_body(request) do
    request.data
    |> List.first()
    |> case do
      nil -> {:error, :data_list_nil}
      body -> {:ok, body}
    end
  end

  def validate_headers(%{"client_id" => client_id, "client_secret" => client_secret}) do
    with {:ok, true} <- validate_client(client_id, ConfigHolder.conf().crud_client_id),
         {:ok, true} <- validate_client(client_secret, ConfigHolder.conf().crud_client_secret) do
      {:ok, true}
      else
        error ->
          Logger.error("Error validando headers #{inspect(error)}")
          error
      end
  end

  def validate_headers(_headers) do
    {:error, :client_not_authorized}
  end

  defp validate_client(credential, _config_credential) when is_nil(credential) or credential == "" do
    {:error, :client_not_authorized}
  end

  defp validate_client(credential, config_credential) do
    case String.equivalent?(credential, config_credential) do
      true -> {:ok, true}
      false -> {:error, :client_not_authorized}
    end
  end
end
