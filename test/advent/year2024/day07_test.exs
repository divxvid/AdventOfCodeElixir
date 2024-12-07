defmodule Advent.Year2024.Day07Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day07
  @input "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 3749
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 11387
  end
end
