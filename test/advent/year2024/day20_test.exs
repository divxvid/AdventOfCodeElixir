defmodule Advent.Year2024.Day20Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day20

  # @tag :skip
  test "part1" do
    input = "###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############"
    result = part1(input)

    # just a dummy value as we can't exactly test it
    assert result == 23
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
