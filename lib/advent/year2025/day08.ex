defmodule Advent.Year2025.Day08 do
  defmodule JunctionBox do
    defstruct [:id, :leader, :pack_size, :x, :y, :z]

    def new(id, x, y, z) do
      %JunctionBox{
        id: id,
        leader: id,
        pack_size: 1,
        x: x,
        y: y,
        z: z
      }
    end

    def distance(%JunctionBox{x: x1, y: y1, z: z1}, %JunctionBox{x: x2, y: y2, z: z2}) do
      dx = x1 - x2
      dy = y1 - y2
      dz = z1 - z2
      dx * dx + dy * dy + dz * dz
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.zip(1..10000//1)
    |> Enum.map(fn {line, id} ->
      [x, y, z] =
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      JunctionBox.new(id, x, y, z)
    end)
  end

  def part1(args, connection_limit) do
    junction_boxes = parse(args)

    jb_map =
      junction_boxes
      |> Enum.map(fn %JunctionBox{id: id} = jb -> {id, jb} end)
      |> Enum.into(Map.new())

    distances =
      junction_boxes
      |> find_distances([])
      |> Enum.sort_by(fn {distance, _, _} -> distance end)
      |> Enum.take(connection_limit)

    {jb_map, _} =
      distances
      |> Enum.reduce({jb_map, nil}, fn {_, jb_id1, jb_id2}, {jb_map, _} ->
        {_, jb_map} = connect_junction_box(jb_map, jb_id1, jb_id2)
        {jb_map, nil}
      end)

    leader_ids =
      jb_map
      |> Enum.map(fn {_, %JunctionBox{leader: leader}} -> leader end)
      |> Enum.uniq()

    leader_ids
    |> Enum.map(fn id ->
      %JunctionBox{pack_size: pack_size} = Map.get(jb_map, id)
      {pack_size, id}
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.map(fn {d, _} -> d end)
    |> Enum.product()
  end

  def part2(args) do
    junction_boxes = parse(args)

    jb_map =
      junction_boxes
      |> Enum.map(fn %JunctionBox{id: id} = jb -> {id, jb} end)
      |> Enum.into(Map.new())

    distances =
      junction_boxes
      |> find_distances([])
      |> Enum.sort_by(fn {distance, _, _} -> distance end)

    {jb_map, {jb1, jb2}} =
      distances
      |> Enum.reduce({jb_map, {}}, fn {_, jb_id1, jb_id2}, {jb_map, prev} ->
        {status, jb_map} = connect_junction_box(jb_map, jb_id1, jb_id2)

        case status do
          :new -> {jb_map, {jb_id1, jb_id2}}
          :already_conn -> {jb_map, prev}
        end
      end)

    %JunctionBox{x: x1} = Map.get(jb_map, jb1)
    %JunctionBox{x: x2} = Map.get(jb_map, jb2)

    x1 * x2
  end

  defp find_distances([%JunctionBox{} = jb | rest], distances) do
    distances =
      Stream.cycle([jb])
      |> Stream.zip(rest)
      |> Enum.reduce(distances, fn {jb1, jb2}, distances ->
        [{JunctionBox.distance(jb1, jb2), jb1.id, jb2.id} | distances]
      end)

    find_distances(rest, distances)
  end

  defp find_distances(_, acc), do: acc

  defp connect_junction_box(jb_map, jb_id1, jb_id2) do
    leader1_id = find_leader(jb_map, jb_id1)
    leader2_id = find_leader(jb_map, jb_id2)

    if leader1_id == leader2_id do
      # already connected
      {:already_conn, jb_map}
    else
      # connect the two leaders
      %JunctionBox{} = leader1 = Map.get(jb_map, leader1_id)
      %JunctionBox{} = leader2 = Map.get(jb_map, leader2_id)

      if leader1.pack_size >= leader2.pack_size do
        # merge leader2 into leader1
        new_pack_size = leader1.pack_size + leader2.pack_size
        leader2 = %JunctionBox{leader2 | leader: leader1_id}
        leader1 = %JunctionBox{leader1 | pack_size: new_pack_size}

        {:new,
         jb_map
         |> Map.update!(leader1_id, fn _ -> leader1 end)
         |> Map.update!(leader2_id, fn _ -> leader2 end)}
      else
        # merge leader1 into leader2
        new_pack_size = leader1.pack_size + leader2.pack_size
        leader1 = %JunctionBox{leader1 | leader: leader2_id}
        leader2 = %JunctionBox{leader2 | pack_size: new_pack_size}

        {:new,
         jb_map
         |> Map.update!(leader1_id, fn _ -> leader1 end)
         |> Map.update!(leader2_id, fn _ -> leader2 end)}
      end
    end
  end

  defp find_leader(jb_map, jb_id) do
    %JunctionBox{id: id, leader: leader} = Map.get(jb_map, jb_id)

    if leader == id,
      do: id,
      else: find_leader(jb_map, leader)
  end
end
