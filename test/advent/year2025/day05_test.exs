defmodule Advent.Year2025.Day05Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day05

  @input "3-5
10-14
16-20
12-18

1
5
8
11
17
32"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 3
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 14
  end
end
