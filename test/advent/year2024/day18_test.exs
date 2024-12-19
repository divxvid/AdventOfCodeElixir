defmodule Advent.Year2024.Day18Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day18

  @input "5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"

  @tag :skip
  test "part1" do
    result = part1(@input, width: 7, height: 7, take: 12)

    assert result
  end

  @tag :skip
  test "part2" do
    result = part2(@input, width: 7, height: 7)

    assert result == "6,1"
  end
end
