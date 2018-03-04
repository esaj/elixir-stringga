defmodule StringGaTest do
  use ExUnit.Case
  doctest StringGa

  test "greets the world" do
    assert StringGa.hello() == :world
  end
end
