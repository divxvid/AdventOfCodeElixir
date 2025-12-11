defmodule Advent.Year2025.Day11Test do
  use ExUnit.Case

  import Elixir.Advent.Year2025.Day11

  # @tag :skip
  test "part1" do
    input = "aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out"
    result = part1(input)

    assert result == 5
  end

  # @tag :skip
  test "part2" do
    input = "svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out"
    result = part2(input)

    assert result == 2
  end
end
