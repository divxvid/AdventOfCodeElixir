defmodule Advent.Year2024.Day16 do
  alias Advent.Structures.Grid

  @deltas {{0, -1}, {-1, 0}, {0, 1}, {1, 0}}
  @index %{west: 0, north: 1, east: 2, south: 3}
  @reverse_index %{0 => :west, 1 => :north, 2 => :east, 3 => :south}

  def part1(args) do
    %Grid{elements: grid} = Grid.new(args)

    {{src_r, src_c}, {dest_r, dest_c}} = get_src_and_dest(grid)
    min_points_seen = find_min_points(grid, src_r, src_c)

    min_points_seen[{dest_r, dest_c}]
  end

  def part2(args) do
    %Grid{elements: grid} = Grid.new(args)

    {{src_r, src_c}, {dest_r, dest_c}} = get_src_and_dest(grid)
    min_points_seen = find_min_points(grid, src_r, src_c)

    min_points = min_points_seen[{dest_r, dest_c}]

    best_spots = MapSet.new() |> MapSet.put({dest_r, dest_c})

    [:north, :south, :east, :west]
    |> Enum.reduce(best_spots, fn dir, best_spots ->
      find_best_spots(min_points_seen, dest_r, dest_c, min_points, dir, best_spots)
    end)
    |> MapSet.size()
  end

  defp find_best_spots(min_points_seen, r, c, points, dir, best_spots) do
    generate_neighbors(r, c, points, dir, -1)
    |> Enum.reduce(best_spots, fn {npts, {nr, nc, ndir}}, best_spots ->
      value = Map.fetch(min_points_seen, {nr, nc})

      case value do
        {:ok, ^npts} ->
          best_spots = MapSet.put(best_spots, {nr, nc})
          find_best_spots(min_points_seen, nr, nc, npts, ndir, best_spots)

        {:ok, actual_pts} ->
          delta = npts - actual_pts

          if delta == 1000 do
            best_spots = MapSet.put(best_spots, {nr, nc})
            find_best_spots(min_points_seen, nr, nc, npts, ndir, best_spots)
          else
            best_spots
          end

        _ ->
          best_spots
      end
    end)
  end

  defp find_min_points(grid, src_r, src_c) do
    heap = Heap.new(fn {k1, _}, {k2, _} -> k1 <= k2 end)

    # inserting the source node with 0 points
    heap = Heap.push(heap, {0, {src_r, src_c, :east}})

    Stream.iterate(1, & &1)
    |> Enum.reduce_while({heap, Map.new()}, fn _, {heap, min_points_seen} ->
      if Heap.empty?(heap) do
        {:halt, min_points_seen}
      else
        {points, {r, c, dir}} = Heap.root(heap)
        heap = Heap.pop(heap)

        if Map.get(min_points_seen, {r, c}, 1_000_000_000_000) < points do
          {:cont, {heap, min_points_seen}}
        else
          node_type = Map.get(grid, {r, c})

          case node_type do
            "#" ->
              {:cont, {heap, min_points_seen}}

            "E" ->
              min_points_seen = Map.put(min_points_seen, {r, c}, points)
              {:cont, {heap, min_points_seen}}

            _ ->
              min_points_seen = Map.put(min_points_seen, {r, c}, points)

              heap =
                generate_neighbors(r, c, points, dir)
                |> Enum.reduce(heap, fn e, heap -> Heap.push(heap, e) end)

              {:cont, {heap, min_points_seen}}
          end
        end
      end
    end)
  end

  defp generate_neighbors(r, c, points, dir, mult \\ 1) do
    index = Map.get(@index, dir)
    left_index = rem(index - 1 + 4, 4)
    right_index = rem(index + 1, 4)

    # IMPORTANT: I'm adding 1000+1 to accomodate for turn + movement to the next cell
    [
      {elem(@deltas, index), points + 1 * mult, dir},
      {elem(@deltas, left_index), points + 1001 * mult, Map.get(@reverse_index, left_index)},
      {elem(@deltas, right_index), points + 1001 * mult, Map.get(@reverse_index, right_index)}
    ]
    |> Enum.map(fn {{dx, dy}, pts, dir} -> {pts, {r + dx, c + dy, dir}} end)
  end

  defp get_src_and_dest(grid) do
    Enum.reduce(grid, {nil, nil}, fn {{r, c}, v}, {src, dest} ->
      case v do
        "S" -> {{r, c}, dest}
        "E" -> {src, {r, c}}
        _ -> {src, dest}
      end
    end)
  end
end
