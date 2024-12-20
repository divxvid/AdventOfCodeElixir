defmodule Advent.Year2024.Day08Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day08

  @input "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 14
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 34
  end
end
