defmodule Advent.Year2024.Day14 do
  defmodule Robot do
    defstruct [:px, :py, :vx, :vy]

    def parse(input) do
      input = String.trim(input)
      [position, velocity] = String.split(input, " ", trim: true)
      ["p", px, py] = String.split(position, ["=", ","], trim: true)
      ["v", vx, vy] = String.split(velocity, ["=", ","], trim: true)

      %Robot{
        vx: String.to_integer(vx),
        px: String.to_integer(px),
        py: String.to_integer(py),
        vy: String.to_integer(vy)
      }
    end
  end

  defmodule Area do
    defstruct [:robots, :width, :height]

    def parse(input, opts \\ []) do
      robots =
        input
        |> String.split("\n", trim: true)
        |> Enum.map(&Robot.parse/1)

      width = Keyword.get(opts, :width, 101)
      height = Keyword.get(opts, :height, 103)

      %Area{
        robots: robots,
        width: width,
        height: height
      }
    end

    def tick(%Area{} = area, count \\ 1) do
      robots =
        for robot <- area.robots do
          move_robot(robot, area, count)
        end

      area
      |> Map.put(:robots, robots)
    end

    def show(%Area{} = area) do
      robots_loc =
        area.robots
        |> Enum.reduce(MapSet.new(), fn %Robot{px: x, py: y}, acc ->
          MapSet.put(acc, {x, y})
        end)

      for x <- 0..(area.width - 1) do
        for y <- 0..(area.height - 1) do
          if MapSet.member?(robots_loc, {x, y}), do: ?., else: ?\s
        end
        |> to_string()
      end
      |> Enum.join("\n")
      |> IO.puts()
    end

    defp move_robot(%Robot{} = robot, %Area{width: width, height: height}, count) do
      px = bounded_move(robot.px, robot.vx, count, width)
      py = bounded_move(robot.py, robot.vy, count, height)

      robot
      |> Map.put(:px, px)
      |> Map.put(:py, py)
    end

    defp bounded_move(base, amount, count, limit) do
      new_pos = base + amount * count
      # Adding limit to offset for negative values
      new_pos = rem(rem(new_pos, limit) + limit, limit)
      new_pos
    end
  end

  def part1(args, opts \\ []) do
    area =
      args
      |> Area.parse(opts)
      |> Area.tick(100)

    area.robots
    |> Enum.map(fn %Robot{px: x, py: y} ->
      quadrant(x, y, area.width, area.height)
    end)
    |> Enum.frequencies()
    |> Enum.reduce(1, fn {k, v}, acc ->
      mult = if k == :ignore, do: 1, else: v
      acc * mult
    end)
  end

  def part2(args, opts \\ []) do
    area = Area.parse(args, opts)

    start = 7892
    area = Area.tick(area, start)

    Stream.iterate(start, &(&1 + 1))
    |> Enum.reduce_while(area, fn t, area ->
      IO.puts("Tick: #{t} seconds")
      Area.show(area)
      area = Area.tick(area)

      case IO.gets("want continue? [Enter/other keys will exit]") do
        "\n" ->
          {:cont, area}

        _ ->
          {:halt, area}
      end
    end)
  end

  defp quadrant(x, y, width, height) do
    middle_width = div(width, 2)
    middle_height = div(height, 2)

    cond do
      x > middle_width and y < middle_height -> :first
      x < middle_width and y < middle_height -> :second
      x < middle_width and y > middle_height -> :third
      x > middle_width and y > middle_height -> :fourth
      true -> :ignore
    end
  end
end
