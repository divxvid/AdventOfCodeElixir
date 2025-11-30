defmodule Advent.Year2024.Day21Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day21

  @input "029A
980A
179A
456A
379A"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 126_384
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
