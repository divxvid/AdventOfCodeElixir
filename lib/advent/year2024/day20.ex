defmodule Advent.Year2024.Day20 do
  alias Advent.Structures.Grid

  def part1(args) do
    grid = Grid.new(args)
    %{"S" => [{start_r, start_c}], "E" => [{end_r, end_c}]} = Grid.find(grid, ["S", "E"])

    # find the distances from end to start and store it in a map
    distances = distance(grid, end_r, end_c, 0, Map.new())
    shortcuts = find_distances_with_shortcuts(grid, start_r, start_c, 0, distances, [], 2)

    actual_dist = Map.get(distances, {start_r, start_c})

    shortcuts
    |> Enum.filter(fn {_, _, d} -> actual_dist - d >= 100 end)
    |> Enum.count()
  end

  def part2(args) do
    grid = Grid.new(args)
    %{"S" => [{start_r, start_c}], "E" => [{end_r, end_c}]} = Grid.find(grid, ["S", "E"])

    # find the distances from end to start and store it in a map
    distances = distance(grid, end_r, end_c, 0, Map.new())
    shortcuts = find_distances_with_shortcuts(grid, start_r, start_c, 0, distances, [], 20)

    actual_dist = Map.get(distances, {start_r, start_c})

    shortcuts
    |> Enum.filter(fn {_, _, d} -> actual_dist - d >= 100 end)
    |> Enum.count()
  end

  defp find_distances_with_shortcuts(
         %Grid{} = grid,
         r,
         c,
         current_dist,
         distances,
         shortcuts,
         tolerance
       ) do
    if not Map.has_key?(distances, {r, c}) do
      shortcuts
    else
      shortcuts =
        for dr <- -tolerance..tolerance, reduce: shortcuts do
          shortcuts ->
            for dc <- -tolerance..tolerance, reduce: shortcuts do
              shortcuts ->
                cond do
                  abs(dr) + abs(dc) > tolerance ->
                    shortcuts

                  dr == 0 and dc == 0 ->
                    shortcuts

                  true ->
                    nr = r + dr
                    nc = c + dc

                    case Map.fetch(distances, {nr, nc}) do
                      {:ok, dist} ->
                        [{{r, c}, {nr, nc}, dist + current_dist + abs(dr) + abs(dc)} | shortcuts]

                      :error ->
                        shortcuts
                    end
                end
            end
        end

      my_dist = Map.get(distances, {r, c})

      Grid.traverse4_indexes(grid, r, c)
      |> Enum.reduce(shortcuts, fn {nr, nc}, shortcuts ->
        neighbor_dist = Map.get(distances, {nr, nc}, 1_000_000_000)

        if neighbor_dist < my_dist do
          find_distances_with_shortcuts(
            grid,
            nr,
            nc,
            current_dist + 1,
            distances,
            shortcuts,
            tolerance
          )
        else
          shortcuts
        end
      end)
    end
  end

  defp distance(%Grid{} = grid, r, c, current_dist, distances) do
    cond do
      Map.has_key?(distances, {r, c}) ->
        distances

      Grid.get!(grid, r, c) == "#" ->
        distances

      true ->
        distances = Map.put(distances, {r, c}, current_dist)

        Grid.traverse4_indexes(grid, r, c)
        |> Enum.reduce(distances, fn {nr, nc}, distances ->
          distance(grid, nr, nc, current_dist + 1, distances)
        end)
    end
  end
end
