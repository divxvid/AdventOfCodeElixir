defmodule Elixir.Mix.Tasks.Y2025.D08.P1 do
  use Mix.Task

  import Elixir.Advent.Year2025.Day08

  @shortdoc "Day 08 Part 1"
  def run(args) do
    input = Advent.Input.get!(8, 2025)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(1000) end}),
      else:
        input
        |> part1(1000)
        |> IO.inspect(label: "Part 1 Results")
  end
end
