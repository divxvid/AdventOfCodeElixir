defmodule Advent.Year2024.Day16Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day16

  @input1 "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############"

  @input2 "#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################"

  # @tag :skip
  test "part1 input1" do
    result = part1(@input1)

    assert result == 7036
  end

  # @tag :skip
  test "part1 input2" do
    result = part1(@input2)

    assert result == 11048
  end

  # @tag :skip
  test "part2 input1" do
    result = part2(@input1)

    assert result == 45
  end

  # @tag :skip
  test "part2 input2" do
    result = part2(@input2)

    assert result == 64
  end
end
