defmodule Advent.Year2025.Day01Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day01

  # @tag :skip
  test "part1" do
    input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"
    result = part1(input)

    assert result == 3
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
