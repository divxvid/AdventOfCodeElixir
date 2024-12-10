defmodule Advent.Year2024.Day10 do
  alias Advent.Structures.Grid

  def part1(args), do: solve(args, false)

  def part2(args), do: solve(args, true)

  defp solve(input, all_paths?) do
    %Grid{} = grid = Grid.new(input, mapper: &String.to_integer/1)

    countmap =
      for r <- 1..grid.n_rows, reduce: Map.new() do
        countmap ->
          for c <- 1..grid.n_cols, {:ok, 9} == Grid.get(grid, r, c), reduce: countmap do
            countmap ->
              {countmap, _} = fill_count(grid, countmap, MapSet.new(), r, c, all_paths?)
              countmap
          end
      end

    for r <- 1..grid.n_rows, reduce: 0 do
      acc ->
        for c <- 1..grid.n_cols, {:ok, 0} == Grid.get(grid, r, c), reduce: acc do
          acc ->
            value = Map.get(countmap, {r, c}, 0)
            acc + value
        end
    end
  end

  defp fill_count(%Grid{} = grid, countmap, traversed, r, c, all_paths?) do
    {:ok, root_element} = Grid.get(grid, r, c)
    countmap = Map.update(countmap, {r, c}, 1, &(&1 + 1))

    for {i, j} <- Grid.traverse4_indexes(grid, r, c), reduce: {countmap, traversed} do
      {countmap, traversed} ->
        {:ok, element} = Grid.get(grid, i, j)

        cond do
          MapSet.member?(traversed, {i, j}) && not all_paths? ->
            {countmap, traversed}

          element == root_element - 1 ->
            traversed = MapSet.put(traversed, {i, j})
            fill_count(grid, countmap, traversed, i, j, all_paths?)

          true ->
            {countmap, traversed}
        end
    end
  end
end
