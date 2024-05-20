defmodule CrudElixirProject.ApplicationTest do
  use ExUnit.Case
  doctest CrudElixirProject.Application

  test "test childrens" do
    assert CrudElixirProject.Application.env_children(:test) == []
  end
end
