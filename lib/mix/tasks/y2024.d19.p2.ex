defmodule Elixir.Mix.Tasks.Y2024.D19.P2 do
  use Mix.Task

  import Elixir.Advent.Year2024.Day19

  @shortdoc "Day 19 Part 2"
  def run(args) do
    input = Advent.Input.get!(19, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
