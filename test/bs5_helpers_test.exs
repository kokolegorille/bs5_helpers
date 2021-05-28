defmodule Bs5HelpersTest do
  use ExUnit.Case
  doctest Bs5Helpers

  test "greets the world" do
    assert Bs5Helpers.hello() == :world
  end
end
