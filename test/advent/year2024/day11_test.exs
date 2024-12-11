defmodule Advent.Year2024.Day11Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day11

  # @tag :skip
  test "part1" do
    input = "125 17"
    result = part1(input)

    assert result == 55312
  end
end
