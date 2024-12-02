defmodule Advent.Year2024.Day01Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day01

  @tag :skip
  test "part1" do
    input = "3   4
4   3
2   5
1   3
3   9
3   3"
    result = part1(input)

    assert result == 11
  end

  @tag :skip
  test "part2" do
    input = "3   4
4   3
2   5
3   3"
    result = part2(input)

    assert result == 31
  end
end
