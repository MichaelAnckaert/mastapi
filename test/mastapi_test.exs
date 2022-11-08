defmodule MastapiTest do
  use ExUnit.Case
  doctest Mastapi

  test "greets the world" do
    assert Mastapi.hello() == :world
  end
end
