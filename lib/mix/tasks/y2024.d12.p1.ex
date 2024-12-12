defmodule Elixir.Mix.Tasks.Y2024.D12.P1 do
  use Mix.Task

  import Elixir.Advent.Year2024.Day12

  @shortdoc "Day 12 Part 1"
  def run(args) do
    input = Advent.Input.get!(12, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
