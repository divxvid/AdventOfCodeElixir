defmodule Advent.Year2024.Day02 do
  def part1(args) do
    input = parse(args)

    Enum.reduce(input, 0, fn record, safe_level_cnt ->
      safe_level_cnt + if is_good_record?(record), do: 1, else: 0
    end)
  end

  def part2(args) do
    input = parse(args)

    Enum.reduce(input, 0, fn record, safe_level_cnt ->
      {_, _, any_good?} =
        Enum.reduce(record, {[], record, false}, fn _, {left, right, ok?} ->
          new_list = left ++ tl(right)

          left = left ++ [hd(right)]
          {left, tl(right), ok? || is_good_record?(new_list)}
        end)

      safe_level_cnt + if any_good?, do: 1, else: 0
    end)
  end

  defp is_good_record?(record) do
    [fst | [snd | _]] = record
    mode = if fst < snd, do: :increasing, else: :decreasing

    Enum.zip(record, tl(record))
    |> Enum.reduce(true, fn {a, b}, is_good ->
      case mode do
        :increasing -> is_good && (a < b && b - a >= 1 && b - a <= 3)
        :decreasing -> is_good && (a > b && a - b >= 1 && a - b <= 3)
      end
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn record ->
      record
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
