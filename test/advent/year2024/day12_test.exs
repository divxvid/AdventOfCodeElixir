defmodule Advent.Year2024.Day12Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day12

  @input "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"

  # @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 1930
  end

  # @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 1206
  end
end
