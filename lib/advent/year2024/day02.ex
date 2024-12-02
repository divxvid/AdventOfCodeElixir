defmodule Advent.Year2024.Day02 do
  def part1(args) do
    input = parse(args)

    Enum.reduce(input, 0, fn record, safe_level_cnt ->
      [fst | [snd | _]] = record
      mode = if fst < snd, do: :increasing, else: :decreasing

      is_good_record =
        Enum.zip(record, tl(record))
        |> Enum.reduce(true, fn {a, b}, is_good ->
          case mode do
            :increasing -> is_good && (a < b && b - a >= 1 && b - a <= 3)
            :decreasing -> is_good && (a > b && a - b >= 1 && a - b <= 3)
          end
        end)

      safe_level_cnt + if is_good_record, do: 1, else: 0
    end)
  end

  def part2(args) do
    input = parse(args)

    Enum.reduce(input, 0, fn record, safe_level_cnt ->
      {_, _, any_good?} =
        Enum.reduce(record, {[], record, false}, fn _, {left, right, ok?} ->
          new_list = left ++ tl(right)

          [fst | [snd | _]] = new_list
          mode = if fst < snd, do: :increasing, else: :decreasing

          is_good_record =
            Enum.zip(new_list, tl(new_list))
            |> Enum.reduce(true, fn {a, b}, is_good ->
              case mode do
                :increasing -> is_good && (a < b && b - a >= 1 && b - a <= 3)
                :decreasing -> is_good && (a > b && a - b >= 1 && a - b <= 3)
              end
            end)

          left = left ++ [hd(right)]
          {left, tl(right), ok? || is_good_record}
        end)

      safe_level_cnt + if any_good?, do: 1, else: 0
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
