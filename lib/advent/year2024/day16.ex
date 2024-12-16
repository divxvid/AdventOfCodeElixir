defmodule Advent.Year2024.Day16 do
  alias Advent.Structures.Grid

  @deltas {{0, -1}, {-1, 0}, {0, 1}, {1, 0}}
  @index %{west: 0, north: 1, east: 2, south: 3}
  @reverse_index %{0 => :west, 1 => :north, 2 => :east, 3 => :south}

  def part1(args) do
    %Grid{elements: grid} = Grid.new(args)

    {src_r, src_c} = get_src(grid)
    heap = Heap.new(fn {k1, _}, {k2, _} -> k1 <= k2 end)
    min_points_seen = Map.new()

    # inserting the source node with 0 points
    heap = Heap.push(heap, {0, {src_r, src_c, :east}})

    Stream.iterate(1, & &1)
    |> Enum.reduce_while({heap, min_points_seen}, fn _, {heap, min_points_seen} ->
      if Heap.empty?(heap), do: raise("Heap got empty!")
      {points, {r, c, dir}} = Heap.root(heap)
      heap = Heap.pop(heap)

      if Map.get(min_points_seen, {r, c, dir}, 1_000_000_000_000) < points do
        {:cont, {heap, min_points_seen}}
      else
        node_type = Map.get(grid, {r, c})

        case node_type do
          "#" ->
            {:cont, {heap, min_points_seen}}

          "E" ->
            {:halt, points}

          _ ->
            min_points_seen = Map.put(min_points_seen, {r, c, dir}, points)

            heap =
              generate_neighbors(r, c, points, dir)
              |> Enum.reduce(heap, fn e, heap -> Heap.push(heap, e) end)

            {:cont, {heap, min_points_seen}}
        end
      end
    end)
  end

  def part2(args) do
    args
  end

  defp generate_neighbors(r, c, points, dir) do
    index = Map.get(@index, dir)
    left_index = rem(index - 1 + 4, 4)
    right_index = rem(index + 1, 4)

    # IMPORTANT: I'm adding 1000+1 to accomodate for turn + movement to the next cell
    [
      {elem(@deltas, index), points + 1, dir},
      {elem(@deltas, left_index), points + 1001, Map.get(@reverse_index, left_index)},
      {elem(@deltas, right_index), points + 1001, Map.get(@reverse_index, right_index)}
    ]
    |> Enum.map(fn {{dx, dy}, pts, dir} -> {pts, {r + dx, c + dy, dir}} end)
  end

  defp get_src(grid) do
    Enum.reduce_while(grid, nil, fn {{r, c}, v}, nil ->
      case v do
        "S" -> {:halt, {r, c}}
        _ -> {:cont, nil}
      end
    end)
  end
end
