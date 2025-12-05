defmodule Advent.Year2025.Day05 do
  def parse(input) do
    [ranges, ingredient_ids] = String.split(input, "\n\n", trim: true)

    ranges =
      ranges
      |> String.split("\n", trim: true)
      |> Enum.map(fn range ->
        [low, high] = String.split(range, "-", trim: true) |> Enum.map(&String.to_integer/1)
        Range.new(low, high)
      end)

    ingredient_ids =
      ingredient_ids
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    {ranges, ingredient_ids}
  end

  @doc """
  Without merging the ranges:
  Name             ips        average  deviation         median         99th %
  part_1        189.58        5.27 ms    10.39%        5.17 ms        9.21 ms

  With merger:
  Name             ips        average  deviation         median         99th %
  part_1        367.13        2.72 ms     8.78%        2.68 ms        4.07 ms
  """
  def part1(args) do
    {fresh_ranges, ingredient_ids} = parse(args)
    fresh_ranges = merge_ranges(fresh_ranges)

    ingredient_ids
    |> Enum.filter(fn ingredient_id ->
      Enum.reduce_while(fresh_ranges, false, fn range, _acc ->
        if ingredient_id in range,
          do: {:halt, true},
          else: {:cont, false}
      end)
    end)
    |> Enum.count()
  end

  @doc"""
  Performance benchmarks:
  Name             ips        average  deviation         median         99th %
  part_2        4.25 K      235.02 us     9.61%      228.50 us      344.52 us
  """
  def part2(args) do
    {fresh_ranges, _} = parse(args)

    merge_ranges(fresh_ranges)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  defp merge_ranges(ranges) do
    ranges = Enum.sort(ranges)

    low..high//1 = hd(ranges)

    {low, high, acc} =
      tl(ranges)
      |> Enum.reduce({low, high, []}, fn l..h//1, {low, high, acc} ->
        if l <= high,
          do: {low, max(h, high), acc},
          else: {l, h, [low..high | acc]}
      end)

    [low..high | acc]
  end
end
