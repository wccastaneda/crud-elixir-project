defmodule CrudElixirProject.Infrastructure.EntryPoint.ErrorHandler do

  def build_error_response(error) do
    map_error_response(error) |> build_message_error()
  end

  defp map_error_response({:error, :client_not_authorized}) do
    %{
      code: "ERROR-01",
      detail: "El cliente no fue autorizado"
    }
  end

  defp map_error_response({:error, :age_not_allowed}) do
    %{
      code: "ERROR-02",
      detail: "El cliente es menor a 15 años"
    }
  end

  defp map_error_response({:error, :client_not_exists}) do
    %{
      code: "ERROR-03",
      detail: "El cliente no existe"
    }
  end

  defp map_error_response(_error) do
    %{
      code: "ERROR-NN",
      detail: "Error en la app, inténtalo mas tarde"
    }
  end

  defp build_message_error(error_map) do
    %{
      "meta" => %{
        "messageId" => UUID.uuid4(),
        "requestDate" => get_request_date()
      },
      "data" => nil,
      "errors" => [
        error_map
      ]
    }
  end

  defp get_request_date() do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")
    "#{now.day}/#{now.month}/#{now.year} #{now.hour}:#{now.minute}:#{now.second}"
  end

end