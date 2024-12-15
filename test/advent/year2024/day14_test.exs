defmodule Advent.Year2024.Day14Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day14

  @input "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"

  @tag :skip
  test "part1" do
    result = part1(@input, width: 11, height: 7)

    assert result == 12
  end

  @tag :skip
  test "part2" do
    part2(@input, width: 11, height: 7)
  end
end
