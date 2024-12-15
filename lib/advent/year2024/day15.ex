defmodule Advent.Year2024.Day15 do
  alias Advent.Structures.Grid

  defmodule Warehouse do
    defstruct [:cells, :robotx, :roboty]

    def parse(input) do
      %Grid{} = cells = Grid.new(input, mapper: fn s -> hd(String.to_charlist(s)) end)

      {{robotx, roboty}, _} =
        Enum.find(cells.elements, fn {_, v} ->
          v == ?@
        end)

      %Warehouse{
        robotx: robotx,
        roboty: roboty,
        cells: cells
      }
    end

    def show(%Warehouse{cells: cells}) do
      %Grid{n_rows: n_rows, n_cols: n_cols, elements: elements} = cells

      for r <- 1..n_rows do
        for c <- 1..n_cols do
          Map.get(elements, {r, c})
        end
        |> to_string()
      end
      |> Enum.join("\n")
    end

    def move_robot(%Warehouse{robotx: rx, roboty: ry} = warehouse, direction, amount) do
      {delta, cells} = move(warehouse.cells, rx, ry, direction, amount)
      {dx, dy} = get_movement_delta(direction)

      amount = amount - delta

      warehouse
      |> Map.put(:cells, cells)
      |> Map.put(:robotx, rx + dx * amount)
      |> Map.put(:roboty, ry + dy * amount)
    end

    def move_robot2(%Warehouse{robotx: rx, roboty: ry} = warehouse, direction, amount) do
      case direction do
        :left ->
          move_robot(warehouse, direction, amount)

        :right ->
          move_robot(warehouse, direction, amount)

        _ ->
          delta = anticipate_move_amount(warehouse.cells, rx, ry, direction, amount)
          amount = amount - delta

          cells = move2(warehouse.cells, rx, ry, direction, amount)

          {dx, dy} = get_movement_delta(direction)

          warehouse
          |> Map.put(:cells, cells)
          |> Map.put(:robotx, rx + dx * amount)
          |> Map.put(:roboty, ry + dy * amount)
      end
    end

    defp anticipate_move_amount(_, _, _, _, 0), do: 0

    defp anticipate_move_amount(%Grid{} = cells, x, y, direction, amount) do
      with {:ok, ch} <- Grid.get(cells, x, y) do
        {dx, dy} = get_movement_delta(direction)

        case ch do
          ?# ->
            amount

          ?. ->
            anticipate_move_amount(cells, x + dx, y + dy, direction, amount - 1)

          ?@ ->
            anticipate_move_amount(cells, x + dx, y + dy, direction, amount)

          ?[ ->
            delta1 = anticipate_move_amount(cells, x + dx, y + dy, direction, amount)
            # neighboring ] node
            delta2 = anticipate_move_amount(cells, x + dx, y + 1 + dy, direction, amount)
            max(delta1, delta2)

          ?] ->
            delta1 = anticipate_move_amount(cells, x + dx, y + dy, direction, amount)
            # neighboring [ node
            delta2 = anticipate_move_amount(cells, x + dx, y - 1 + dy, direction, amount)
            max(delta1, delta2)
        end
      else
        {:error, _} -> amount
      end
    end

    defp move2(cells, _, _, _, 0), do: cells

    defp move2(%Grid{} = cells, x, y, direction, amount) do
      with {:ok, ch} <- Grid.get(cells, x, y) do
        {dx, dy} = get_movement_delta(direction)

        case ch do
          ?# ->
            cells

          ?. ->
            move2(cells, x + dx, y + dy, direction, amount - 1)

          ?@ ->
            cells = move2(cells, x + dx, y + dy, direction, amount)
            {:ok, cells} = Grid.update(cells, x + dx * amount, y + dy * amount, ch)
            {:ok, cells} = Grid.update(cells, x, y, ?.)
            cells

          ?[ ->
            cells = move2(cells, x + dx, y + dy, direction, amount)
            cells = move2(cells, x + dx, y + 1 + dy, direction, amount)

            {:ok, cells} = Grid.update(cells, x + dx * amount, y + dy * amount, ch)
            {:ok, cells} = Grid.update(cells, x, y, ?.)

            {:ok, cells} = Grid.update(cells, x + dx * amount, y + 1 + dy * amount, ?])
            {:ok, cells} = Grid.update(cells, x, y + 1, ?.)
            cells

          ?] ->
            cells = move2(cells, x + dx, y + dy, direction, amount)
            cells = move2(cells, x + dx, y - 1 + dy, direction, amount)

            {:ok, cells} = Grid.update(cells, x + dx * amount, y + dy * amount, ch)
            {:ok, cells} = Grid.update(cells, x, y, ?.)

            {:ok, cells} = Grid.update(cells, x + dx * amount, y - 1 + dy * amount, ?[)
            {:ok, cells} = Grid.update(cells, x, y - 1, ?.)
            cells
        end
      else
        {:error, _} -> cells
      end
    end

    defp move(cells, _, _, _, 0), do: {0, cells}

    defp move(%Grid{} = cells, x, y, direction, amount) do
      with {:ok, ch} <- Grid.get(cells, x, y) do
        {dx, dy} = get_movement_delta(direction)

        case ch do
          ?# ->
            {amount, cells}

          ?. ->
            move(cells, x + dx, y + dy, direction, amount - 1)

          _ ->
            {delta, cells} = move(cells, x + dx, y + dy, direction, amount)
            amount = amount - delta
            {:ok, other_ch} = Grid.get(cells, x + dx * amount, y + dy * amount)
            {:ok, cells} = Grid.update(cells, x + dx * amount, y + dy * amount, ch)
            {:ok, cells} = Grid.update(cells, x, y, other_ch)
            {delta, cells}
        end
      else
        {:error, _} -> {amount, cells}
      end
    end

    defp get_movement_delta(direction) do
      case direction do
        :up -> {-1, 0}
        :down -> {1, 0}
        :left -> {0, -1}
        :right -> {0, 1}
      end
    end
  end

  def part1(args) do
    {warehouse, movements} = parse_input(args)

    warehouse =
      movements
      |> Enum.reduce(warehouse, fn {direction, amount}, warehouse ->
        Warehouse.move_robot(warehouse, direction, amount)
      end)

    warehouse.cells.elements
    |> Enum.filter(fn {_, v} -> v == ?O end)
    |> Enum.map(fn {{x, y}, _} -> (x - 1) * 100 + (y - 1) end)
    |> Enum.sum()
  end

  def part2(args) do
    {warehouse, movements} =
      args
      |> enlarge_input()
      |> parse_input()

    warehouse =
      movements
      |> Enum.reduce(warehouse, fn {direction, amount}, warehouse ->
        Warehouse.move_robot2(warehouse, direction, amount)
      end)

    warehouse.cells.elements
    |> Enum.filter(fn {_, v} -> v == ?[ end)
    |> Enum.map(fn {{x, y}, _} -> (x - 1) * 100 + (y - 1) end)
    |> Enum.sum()
  end

  defp enlarge_input(input) do
    [warehouse, movement] = String.split(input, "\n\n", trim: true)

    warehouse =
      warehouse
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.to_charlist()
        |> Enum.reduce(<<>>, fn ch, acc ->
          case ch do
            ?@ -> <<acc::binary, ?@, ?.>>
            ?O -> <<acc::binary, ?[, ?]>>
            ch -> <<acc::binary, ch, ch>>
          end
        end)
      end)
      |> Enum.join("\n")

    Enum.join([warehouse, movement], "\n\n")
  end

  defp parse_input(input) do
    [warehouse, movement] = String.split(input, "\n\n", trim: true)
    warehouse = Warehouse.parse(warehouse)

    movement =
      movement
      |> String.to_charlist()
      |> Enum.reduce([], fn ch, acc ->
        ch = map_movement(ch)

        if ch == :ignore do
          acc
        else
          case acc do
            [] -> [{ch, 1}]
            [{^ch, cnt} | rest] -> [{ch, cnt + 1} | rest]
            acc -> [{ch, 1} | acc]
          end
        end
      end)
      |> Enum.reverse()

    {warehouse, movement}
  end

  defp map_movement(m) do
    case m do
      ?^ -> :up
      ?> -> :right
      ?v -> :down
      ?< -> :left
      ?\n -> :ignore
    end
  end
end
