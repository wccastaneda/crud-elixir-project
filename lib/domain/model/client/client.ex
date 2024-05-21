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

end