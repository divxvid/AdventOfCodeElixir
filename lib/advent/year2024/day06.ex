defmodule Advent.Year2024.Day06 do
  defmodule LabMap do
    defstruct [:columns, :rows, obstacles: MapSet.new()]
  end

  defmodule Guard do
    defstruct [:position, :direction]
  end

  def part1(args) do
    {%LabMap{} = map, %Guard{} = guard} = parse_input(args)
    positions_covered = MapSet.new()

    move(guard, map, positions_covered)
    |> MapSet.size()
  end

  def part2(args) do
    {%LabMap{} = map, %Guard{} = guard} = parse_input(args)
    position_covered = MapSet.new()

    move_with_check(guard, map, position_covered, 0)
  end

  defp move_with_check(
         %Guard{position: {r, c}} = guard,
         %LabMap{rows: rows, columns: columns} = map,
         positions_covered,
         num_potential_obstacles
       ) do
    cond do
      r < 1 || r > rows ->
        num_potential_obstacles

      c < 1 || c > columns ->
        num_potential_obstacles

      true ->
        positions_covered = MapSet.put(positions_covered, {r, c, guard.direction})
        # IO.inspect({guard.position, guard.direction}, label: "before obstactle")
        obstacled_map = place_obstacle_in_path(guard, map)
        diverted_guard = prepare_movement(guard, obstacled_map)

        # IO.inspect({diverted_guard.position, diverted_guard.direction}, label: "after obstactle")

        has_loop? =
          check_loop(diverted_guard, obstacled_map, positions_covered)

        guard = prepare_movement(guard, map)

        num_potential_obstacles =
          if has_loop?, do: num_potential_obstacles + 1, else: num_potential_obstacles

        move_with_check(guard, map, positions_covered, num_potential_obstacles)
    end
  end

  defp place_obstacle_in_path(
         %Guard{} = guard,
         %LabMap{rows: rows, columns: columns} = map
       ) do
    moved_guard = prepare_movement(guard, map)
    {rnew, cnew} = moved_guard.position

    cond do
      rnew < 1 || rnew > rows ->
        map

      cnew < 1 || cnew > columns ->
        map

      true ->
        %LabMap{map | obstacles: MapSet.put(map.obstacles, {rnew, cnew})}
    end
  end

  defp check_loop(
         %Guard{position: {r, c}} = guard,
         %LabMap{rows: rows, columns: columns} = map,
         positions_covered
       ) do
    cond do
      r < 1 || r > rows ->
        false

      c < 1 || c > columns ->
        false

      MapSet.member?(positions_covered, {r, c, guard.direction}) ->
        true

      true ->
        positions_covered = MapSet.put(positions_covered, {r, c, guard.direction})
        guard = prepare_movement(guard, map)
        check_loop(guard, map, positions_covered)
    end
  end

  defp move(
         %Guard{position: {r, c}} = guard,
         %LabMap{rows: rows, columns: columns} = map,
         positions_covered
       ) do
    cond do
      r < 1 || r > rows ->
        positions_covered

      c < 1 || c > columns ->
        positions_covered

      true ->
        positions_covered = MapSet.put(positions_covered, guard.position)
        guard = prepare_movement(guard, map)
        move(guard, map, positions_covered)
    end
  end

  defp turn_right(%Guard{direction: dir} = guard) do
    new_dir =
      case dir do
        :up -> :right
        :right -> :down
        :down -> :left
        :left -> :up
      end

    %Guard{guard | direction: new_dir}
  end

  defp prepare_movement(%Guard{position: {r, c}} = guard, %LabMap{obstacles: obstacles} = map) do
    {dr, dc} =
      case guard.direction do
        :up -> {-1, 0}
        :down -> {1, 0}
        :left -> {0, -1}
        :right -> {0, 1}
      end

    new_position = {r + dr, c + dc}

    if MapSet.member?(obstacles, new_position) do
      # our movement will result in a collision with an obstacle
      # so we will turn right
      prepare_movement(turn_right(guard), map)
    else
      %Guard{guard | position: new_position}
    end
  end

  defp parse_input(input) do
    lines = String.split(input, "\n", trim: true)
    rows = length(lines)
    columns = String.length(hd(lines))

    for {r, line} <- Stream.zip(1..rows, lines),
        reduce: {%LabMap{rows: rows, columns: columns}, %Guard{}} do
      {%LabMap{} = labmap, %Guard{} = guard} ->
        for {c, ch} <- Stream.zip(1..columns, String.to_charlist(line)),
            ch != ?.,
            reduce: {labmap, guard} do
          {%LabMap{} = labmap, %Guard{} = guard} ->
            case ch do
              ?# ->
                labmap = %LabMap{labmap | obstacles: MapSet.put(labmap.obstacles, {r, c})}
                {labmap, guard}

              ch ->
                guard = %Guard{guard | position: {r, c}}
                guard = %Guard{guard | direction: get_direction(ch)}
                {labmap, guard}
            end
        end
    end
  end

  defp get_direction(ch) do
    case ch do
      ?^ -> :up
      ?> -> :right
      ?< -> :left
      ?v -> :down
    end
  end
end
