defmodule CrudElixirProject.Domain.Model.Client do

  alias __MODULE__
  @derive [Poison.Encoder]
  defstruct [
    :name,
    :last_name,
    :email,
    :age
  ]

  def new(request) do
    {
      :ok,
      %__MODULE__{
        name: request[:Name] || nil,
        last_name: request[:Last_name] || nil,
        email: request[:Email] || nil,
        age: request[:Edad] || nil,
      }
    }
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