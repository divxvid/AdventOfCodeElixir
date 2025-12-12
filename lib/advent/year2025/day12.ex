defmodule Advent.Year2025.Day12 do
  def part1(args) do
    {puzzles, shapes} = parse(args)

    shape_sizes =
      shapes
      |> Enum.map(fn {_, shape} -> String.count(shape, "#") end)
      |> Enum.reverse()

    puzzles
    |> Enum.filter(fn {{h, w}, pattern_counts} ->
      board_size = h * w

      space_needed =
        Stream.zip(shape_sizes, pattern_counts)
        |> Stream.map(fn {ss, pc} -> ss * pc end)
        |> Enum.sum()

      board_size >= space_needed
    end)
    |> Enum.count()
  end

  def part2(args) do
    args
  end

  defp parse(input) do
    data =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.reverse()

    [puzzles | shapes] = data
    {parse_puzzles(puzzles), parse_shapes(shapes)}
  end

  defp parse_shapes(shapes) do
    shapes
    |> Enum.map(fn shape ->
      [index, pattern] = String.split(shape, ":\n")
      index = String.to_integer(index)
      {index, pattern}
    end)
  end

  defp parse_puzzles(puzzles) do
    puzzles
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [dimensions, indices] = String.split(line, ": ", trim: true)
      [height, width] = String.split(dimensions, "x") |> Enum.map(&String.to_integer/1)
      indices = String.split(indices, " ", trim: true) |> Enum.map(&String.to_integer/1)

      {{height, width}, indices}
    end)
  end
end
