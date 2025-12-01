defmodule Advent.Year2025.Day01 do
  @mod 100
  @initial_position 50

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn code ->
      <<x, rest::binary>> = code

      case x do
        ?L -> {:left, String.to_integer(rest)}
        ?R -> {:right, String.to_integer(rest)}
      end
    end)
    |> Enum.reduce([@initial_position], fn {direction, amount}, acc ->
      last_pos = hd(acc)

      new_pos =
        case direction do
          :left -> rem(last_pos - amount + @mod, @mod)
          :right -> rem(last_pos + amount, @mod)
        end

      [new_pos | acc]
    end)
    |> Enum.reverse()
    |> Enum.count(fn x -> x == 0 end)
  end

  def part2(args) do
    args
  end
end
