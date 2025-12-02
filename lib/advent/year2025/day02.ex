defmodule Advent.Year2025.Day02 do
  defp parse(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(fn range ->
      [low, high] = String.split(range, "-")
      low = String.to_integer(low)
      high = String.to_integer(high)
      {low, high}
    end)
  end

  def part1(args) do
    parse(args)
    |> Enum.map(fn {low, high} ->
      low..high
      |> Stream.map(fn x ->
        x_str = to_string(x)
        half_len = div(String.length(x_str), 2)
        {left, right} = String.split_at(x_str, half_len)

        if left == right, do: x, else: 0
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    parse(args)
    |> Stream.map(fn {low, high} ->
      low..high
      |> Stream.filter(&(&1 >= 10))
      |> Stream.map(fn x ->
        x_int = x
        x = to_string(x)
        length = String.length(x)
        half_len = div(length, 2)

        found_repetition? =
          1..half_len
          |> Enum.reduce_while(false, fn base_len, _ ->
            {base, rest} = String.split_at(x, base_len)

            if match_prefix(base, rest) do
              {:halt, true}
            else
              {:cont, false}
            end
          end)

        if found_repetition?, do: x_int, else: 0
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp match_prefix(_base, ""), do: true

  defp match_prefix(base, rest) do
    case rest do
      <<^base::binary, remaining::binary>> -> match_prefix(base, remaining)
      _ -> false
    end
  end
end
