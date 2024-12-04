defmodule Advent.Year2024.Day04 do
  def part1(args) do
    grid = parse_grid(args)
    n_rows = tuple_size(grid)
    n_cols = tuple_size(elem(grid, 0))

    for i <- 0..(n_rows - 1), j <- 0..(n_cols - 1), get(grid, i, j) == ?X do
      for dx <- [-1, 0, 1], dy <- [-1, 0, 1], {dx, dy} != {0, 0} do
        word_search(~c"XMAS", grid, i, j, dx, dy)
      end
      |> Enum.map(fn x -> if x, do: 1, else: 0 end)
      |> Enum.sum()
    end
    |> Enum.sum()
  end

  def part2(args) do
    grid = parse_grid(args)
    n_rows = tuple_size(grid)
    n_cols = tuple_size(elem(grid, 0))

    for i <- 0..(n_rows - 1), j <- 0..(n_cols - 1), get(grid, i, j) == ?A do
      vals = {
        get(grid, i - 1, j - 1),
        get(grid, i - 1, j + 1),
        get(grid, i + 1, j - 1),
        get(grid, i + 1, j + 1)
      }

      case vals do
        {?M, ?M, ?S, ?S} -> 1
        {?M, ?S, ?M, ?S} -> 1
        {?S, ?M, ?S, ?M} -> 1
        {?S, ?S, ?M, ?M} -> 1
        _ -> 0
      end
    end
    |> Enum.sum()
  end

  defp get(grid, x, y) do
    cond do
      x >= tuple_size(grid) || x < 0 -> :invalid
      y >= tuple_size(elem(grid, 0)) || y < 0 -> :invalid
      true -> elem(elem(grid, x), y)
    end
  end

  defp word_search([], _, _, _, _, _), do: true

  defp word_search([matcher | rest], grid, x, y, dx, dy) do
    if get(grid, x, y) == matcher do
      word_search(rest, grid, x + dx, y + dy, dx, dy)
    else
      false
    end
  end

  defp parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end
end
