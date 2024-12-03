defmodule Advent.Year2024.Day03 do
  @only_mult_regex ~r/mul\(([[:digit:]]{1,3}),([[:digit:]]{1,3})\)/
  @conditional_mult_regex ~r/mul\(([[:digit:]]{1,3}),([[:digit:]]{1,3})\)|do\(\)|don't\(\)/
  def part1(args) do
    Regex.scan(@only_mult_regex, args)
    |> Enum.reduce(0, fn [_, num1, num2], total_sum ->
      num1 = String.to_integer(num1)
      num2 = String.to_integer(num2)

      total_sum + num1 * num2
    end)
  end

  def part2(args) do
    statements = Regex.scan(@conditional_mult_regex, args)
    perform_mult(statements, 0, true)
  end

  defp perform_mult([], total, _), do: total

  defp perform_mult([["do()"] | rest], total, _) do
    perform_mult(rest, total, true)
  end

  defp perform_mult([["don't()"] | rest], total, _) do
    perform_mult(rest, total, false)
  end

  defp perform_mult([[_, num1, num2] | rest], total, enabled?) do
    if enabled? do
      num1 = String.to_integer(num1)
      num2 = String.to_integer(num2)

      perform_mult(rest, total + num1 * num2, enabled?)
    else
      perform_mult(rest, total, enabled?)
    end
  end
end
