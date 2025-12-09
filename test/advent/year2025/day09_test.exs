defmodule Advent.Year2025.Day09Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day09

  @input "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 50
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 24
  end
end
