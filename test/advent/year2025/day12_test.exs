defmodule Advent.Year2025.Day12Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day12

  @input "0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 2
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
