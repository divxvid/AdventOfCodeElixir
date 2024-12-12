defmodule Advent.Year2024.Day12 do
  alias Advent.Structures.Grid

  def part1(args) do
    %Grid{} = grid = Grid.new(args)

    {_, total_cost} =
      for r <- 1..grid.n_rows, reduce: {MapSet.new(), 0} do
        {seen, total_cost} ->
          for c <- 1..grid.n_cols, not MapSet.member?(seen, {r, c}), reduce: {seen, total_cost} do
            {seen, total_cost} ->
              {seen, area, perimeter} = fence(grid, r, c, seen)
              {seen, total_cost + area * perimeter}
          end
      end

    total_cost
  end

  def part2(args) do
    args
  end

  defp fence(%Grid{} = grid, r, c, seen) do
    if MapSet.member?(seen, {r, c}) do
      {seen, 0, 0}
    else
      {:ok, plant_type} = Grid.get(grid, r, c)
      seen = MapSet.put(seen, {r, c})

      trav = Grid.traverse4_indexes(grid, r, c)
      outside_garden = 4 - length(trav)

      {n_area, n_perimeter, seen} =
        for {neighbor_r, neighbor_c} <- trav, reduce: {0, 0, seen} do
          {area, perimeter, seen} ->
            {:ok, neighbor_plant_type} = Grid.get(grid, neighbor_r, neighbor_c)

            if neighbor_plant_type == plant_type do
              {seen, n_area, n_perimeter} = fence(grid, neighbor_r, neighbor_c, seen)
              {area + n_area, perimeter + n_perimeter, seen}
            else
              {area, perimeter + 1, seen}
            end
        end

      {seen, n_area + 1, n_perimeter + outside_garden}
    end
  end
end
