defmodule Advent.Year2025.Day10Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day10

  @input "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 7
  end

  @tag :skip
  test "part2" do
    result = part2(@input)

    assert result == 33
  end

  @tag :skip
  test "part2 random" do
    input =
      "[..#..##] (2,3,5,6) (0,1,2,4,5,6) (0,1,5,6) (0,1,2,5) (2,4,5,6) (2,5,6) (4,5) (2,3,5) {29,29,222,175,49,256,223}"

    result = part2(input)
    assert result == 10
  end
end
