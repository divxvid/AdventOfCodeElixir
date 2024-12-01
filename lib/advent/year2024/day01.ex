defmodule Advent.Year2024.Day01 do
  def part1(args) do
    {list1, list2} = process_input(args)
    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    Enum.zip(list1, list2)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(args) do
    {list1, list2} = process_input(args)
    counts = Enum.frequencies(list2)

    list1
    |> Enum.map(&(&1 * Map.get(counts, &1, 0)))
    |> Enum.sum()
  end

  defp process_input(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], []}, fn line, {list1, list2} ->
      [n1, n2] =
        line
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)

      list1 = [n1 | list1]
      list2 = [n2 | list2]

      {list1, list2}
    end)
  end
end
