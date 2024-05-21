defmodule CrudElixirProject.Infrastructure.EntryPoint.ApiRest do

  @moduledoc """
  Access point to the rest exposed services
  """
  alias CrudElixirProject.Utils.DataTypeUtils
  alias CrudElixirProject.Infrastructure.EntryPoint.ClientRequestValidation
  alias CrudElixirProject.Domain.Model.Client
  alias CrudElixirProject.Domain.UseCases.Client.ClientUsecase
  alias CrudElixirProject.Infrastructure.EntryPoint.SuccessHandler
  alias CrudElixirProject.Infrastructure.EntryPoint.ErrorHandler
  require Logger
  use Plug.Router
  use Timex

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug OpentelemetryPlug.Propagation
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:crud_elixir_project, :plug])
  plug(:dispatch)

  forward(
    "/api/health",
    to: PlugCheckup,
    init_opts: PlugCheckup.Options.new(json_encoder: Jason, checks: CrudElixirProject.Infrastructure.EntryPoint.HealthCheck.checks)
  )

  get "/api/hello" do
    build_response("Hello World", conn)
  end

  post "/api/client/registration" do
    try do
      with request <- conn.body_params |> DataTypeUtils.normalize(),
           headers <-conn.req_headers |> DataTypeUtils.normalize_headers(),
           {:ok, body} <- ClientRequestValidation.validate_request_body(request),
           {:ok, true} <- ClientRequestValidation.validate_headers(headers),
           {:ok, client} <- Client.new(body),
           {:ok, uuid} <- ClientUsecase.register_client(client) do
        SuccessHandler.build_response(uuid) |> build_response(conn)
      else
        error ->
          Logger.error("Error en controlador de registro #{inspect(error)}")
          response = ErrorHandler.build_error_response(error)
          build_response(%{status: 400, body: response}, conn)
      end
    rescue
      error ->
        IO.inspect(error)
        handle_error(error, conn)
    end
  end


  post "/api/client/getClient" do
    try do
      with request <- conn.body_params |> DataTypeUtils.normalize(),
           headers <-conn.req_headers |> DataTypeUtils.normalize_headers(),
           {:ok, body} <- ClientRequestValidation.validate_request_body(request),
           {:ok, true} <- ClientRequestValidation.validate_headers(headers),
           {:ok, client} <- ClientUsecase.get_client(body.clientUUID) do
        SuccessHandler.build_get_response(client) |> build_response(conn)
      else
        error ->
          Logger.error("Error en controlador de registro #{inspect(error)}")
          response = ErrorHandler.build_error_response(error)
          build_response(%{status: 404, body: response}, conn)
      end
    rescue
      error ->
        IO.inspect(error)
        handle_error(error, conn)
    end
  end


  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  match _ do
    conn
    |> handle_not_found(Logger.level())
  end

  defp handle_error(error, conn) do
    error
    |> build_response(conn)
  end

  defp handle_bad_request(error, conn) do
    error
    |> build_bad_request_response(conn)
  end

  defp build_bad_request_response(response, conn) do
    build_response(%{status: 400, body: response}, conn)
  end

  defp handle_not_found(conn, :debug) do
    %{request_path: path} = conn
    body = Poison.encode!(%{status: 404, path: path})
    send_resp(conn, 404, body)
  end

  defp handle_not_found(conn, _level) do
    send_resp(conn, 404, "")
  end
end
