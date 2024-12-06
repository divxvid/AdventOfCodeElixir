defmodule AdventTest do
  use ExUnit.Case

  @tag :skip
  test "greets the world" do
    assert Advent.hello() == :world
  end
end
