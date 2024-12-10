defmodule Advent.Year2024.Day10Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day10

  @input "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"

  # @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 36
  end

  # @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 81
  end
end
