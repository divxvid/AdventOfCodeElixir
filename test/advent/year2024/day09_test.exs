defmodule Advent.Year2024.Day09Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day09

  @input "2333133121414131402"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 1928
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 2858
  end
end
