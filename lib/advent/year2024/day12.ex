defmodule Advent.Year2024.Day12 do
  alias Advent.Structures.Grid

  @dx4 [-1, 1, 0, 0]
  @dy4 [0, 0, -1, 1]
  @dir4 [:up, :down, :left, :right]

  def part1(args), do: solve(args, true)
  def part2(args), do: solve(args, false)

  defp solve(args, part1?) do
    %Grid{} = grid = Grid.new(args)

    {_, total_cost} =
      for r <- 1..grid.n_rows, reduce: {MapSet.new(), 0} do
        {seen, total_cost} ->
          for c <- 1..grid.n_cols, not MapSet.member?(seen, {r, c}), reduce: {seen, total_cost} do
            {seen, total_cost} ->
              {seen, area, sideset} = fence(grid, r, c, seen, MapSet.new())
              side_value = if part1?, do: MapSet.size(sideset), else: merge_sides(sideset)
              {seen, total_cost + area * side_value}
          end
      end

    total_cost
  end

  defp fence(%Grid{} = grid, r, c, seen, sideset) do
    if MapSet.member?(seen, {r, c}) do
      {seen, 0, sideset}
    else
      {:ok, plant_type} = Grid.get(grid, r, c)
      seen = MapSet.put(seen, {r, c})

      {n_area, sideset, seen} =
        for {dx, dy, dir} <- Stream.zip([@dx4, @dy4, @dir4]), reduce: {0, sideset, seen} do
          {area, sideset, seen} ->
            {neighbor_r, neighbor_c} = {r + dx, c + dy}

            side_value =
              case dir do
                :up -> {:up, r - 1, c}
                :down -> {:down, r, c}
                :left -> {:left, r, c - 1}
                :right -> {:right, r, c}
              end

            with {:ok, neighbor_plant_type} <- Grid.get(grid, neighbor_r, neighbor_c) do
              if neighbor_plant_type == plant_type do
                # Same type of neighbor, so technically we don't need to store the side here
                {seen, n_area, n_sideset} = fence(grid, neighbor_r, neighbor_c, seen, sideset)
                {area + n_area, MapSet.union(sideset, n_sideset), seen}
              else
                # different type of plant seen, so we must draw a side here
                sideset = MapSet.put(sideset, side_value)
                {area, sideset, seen}
              end
            else
              # this is the case where we're stepping out of garden
              {:error, _} ->
                {area, MapSet.put(sideset, side_value), seen}
            end
        end

      {seen, n_area + 1, sideset}
    end
  end

  defp merge_sides(sideset) do
    {count, _} =
      for {orientation, r, c} <- sideset, reduce: {0, sideset} do
        {count, ss} ->
          if not MapSet.member?(ss, {orientation, r, c}) do
            {count, ss}
          else
            case orientation do
              :up ->
                ss = merge_horizontal_sides(:up, ss, r, c)
                {count + 1, ss}

              :down ->
                ss = merge_horizontal_sides(:down, ss, r, c)
                {count + 1, ss}

              :left ->
                ss = merge_vertical_sides(:left, ss, r, c)
                {count + 1, ss}

              :right ->
                ss = merge_vertical_sides(:right, ss, r, c)
                {count + 1, ss}
            end
          end
      end

    count
  end

  defp merge_horizontal_sides(face, sideset, r, c) do
    # merge left side edges
    sideset =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(sideset, fn delta, sideset ->
        c1 = c - delta

        if MapSet.member?(sideset, {face, r, c1}) do
          {:cont, MapSet.delete(sideset, {face, r, c1})}
        else
          {:halt, sideset}
        end
      end)

    # merge right side edges
    sideset =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(sideset, fn delta, sideset ->
        c1 = c + delta

        if MapSet.member?(sideset, {face, r, c1}) do
          {:cont, MapSet.delete(sideset, {face, r, c1})}
        else
          {:halt, sideset}
        end
      end)

    MapSet.delete(sideset, {face, r, c})
  end

  defp merge_vertical_sides(face, sideset, r, c) do
    # merge top side edges

    sideset =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(sideset, fn delta, sideset ->
        r1 = r - delta

        if MapSet.member?(sideset, {face, r1, c}) do
          {:cont, MapSet.delete(sideset, {face, r1, c})}
        else
          {:halt, sideset}
        end
      end)

    # merge bottom side edges
    sideset =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(sideset, fn delta, sideset ->
        r1 = r + delta

        if MapSet.member?(sideset, {face, r1, c}) do
          {:cont, MapSet.delete(sideset, {face, r1, c})}
        else
          {:halt, sideset}
        end
      end)

    MapSet.delete(sideset, {face, r, c})
  end
end
