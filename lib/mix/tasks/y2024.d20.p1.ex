defmodule Elixir.Mix.Tasks.Y2024.D20.P1 do
  use Mix.Task

  import Elixir.Advent.Year2024.Day20

  @shortdoc "Day 20 Part 1"
  def run(args) do
    input = Advent.Input.get!(20, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
