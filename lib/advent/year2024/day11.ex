defmodule Advent.Year2024.Day11 do
  def part1(args), do: solve(args, 25)

  def part2(args), do: solve(args, 75)

  defp solve(args, n) do
    {ans, _} =
      parse_input(args)
      |> Enum.reduce({0, Map.new()}, fn x, {count, memo} ->
        {cnt, memo} = split(x, n, memo)
        {count + cnt, memo}
      end)

    ans
  end

  defp split(x, n, memo) do
    case Map.fetch(memo, {x, n}) do
      {:ok, x} ->
        {x, memo}

      :error ->
        n_digits = num_length(x)

        {value, memo} =
          cond do
            n == 0 ->
              {1, memo}

            x == 0 ->
              split(1, n - 1, memo)

            rem(n_digits, 2) == 0 ->
              {left, right} = split_number(x, n_digits)
              {left_value, memo} = split(left, n - 1, memo)
              {right_value, memo} = split(right, n - 1, memo)
              {left_value + right_value, memo}

            true ->
              split(x * 2024, n - 1, memo)
          end

        memo = Map.put(memo, {x, n}, value)
        {value, memo}
    end
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp num_length(x) do
    Enum.reduce_while(1..40, {x, 0}, fn _, {x, len} ->
      cond do
        x == 0 -> {:halt, len}
        true -> {:cont, {div(x, 10), len + 1}}
      end
    end)
  end

  defp split_number(x, n_digits) do
    bound = div(n_digits, 2)

    {left, right, _} =
      Enum.reduce(1..bound, {x, 0, 1}, fn _, {left, right, mult} ->
        {div(left, 10), right + rem(left, 10) * mult, mult * 10}
      end)

    {left, right}
  end
end
