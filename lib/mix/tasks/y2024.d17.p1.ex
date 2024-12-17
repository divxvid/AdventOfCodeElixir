defmodule Elixir.Mix.Tasks.Y2024.D17.P1 do
  use Mix.Task

  import Elixir.Advent.Year2024.Day17

  @shortdoc "Day 17 Part 1"
  def run(args) do
    input = Advent.Input.get!(17, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
