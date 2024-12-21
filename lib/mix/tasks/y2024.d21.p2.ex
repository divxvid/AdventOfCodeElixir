defmodule Elixir.Mix.Tasks.Y2024.D21.P2 do
  use Mix.Task

  import Elixir.Advent.Year2024.Day21

  @shortdoc "Day 21 Part 2"
  def run(args) do
    input = Advent.Input.get!(21, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
