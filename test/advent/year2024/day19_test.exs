defmodule Advent.Year2024.Day19Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day19

  @input "r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 6
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 16
  end
end
