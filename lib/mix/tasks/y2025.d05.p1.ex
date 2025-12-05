defmodule Elixir.Mix.Tasks.Y2025.D05.P1 do
  use Mix.Task

  import Elixir.Advent.Year2025.Day05

  @shortdoc "Day 05 Part 1"
  def run(args) do
    input = Advent.Input.get!(5, 2025)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
