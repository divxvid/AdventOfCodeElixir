defmodule Advent.Year2024.Day04Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day04

  @input "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 18
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 9
  end
end
