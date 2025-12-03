defmodule Advent.Year2025.Day03Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day03

  @input "987654321111111
811111111111119
234234234234278
818181911112111"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 357
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 3_121_910_778_619
  end
end
