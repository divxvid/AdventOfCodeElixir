defmodule Advent.Year2025.Day01 do
  @mod 100
  @initial_position 50

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn code ->
      <<x, rest::binary>> = code

      case x do
        ?L -> {:left, String.to_integer(rest)}
        ?R -> {:right, String.to_integer(rest)}
      end
    end)
  end

  def part1(args) do
    parse(args)
    |> Enum.reduce([@initial_position], fn {direction, amount}, acc ->
      last_pos = hd(acc)

      new_pos =
        case direction do
          :left -> rem(last_pos - amount + @mod, @mod)
          :right -> rem(last_pos + amount, @mod)
        end

      [new_pos | acc]
    end)
    |> Enum.count(&(&1 == 0))
  end

  def part2(args) do
    {_final_position, num_zero_crossed} =
      parse(args)
      |> Enum.reduce({@initial_position, 0}, fn {direction, amount},
                                                {last_position, num_crossing} ->
        num_full_rotations = div(amount, @mod)
        remaining_amount = rem(amount, @mod)

        case direction do
          :left ->
            new_position = last_position - remaining_amount

            if new_position <= 0 do
              additive = if last_position == 0, do: 0, else: 1
              new_position = rem(new_position + @mod, @mod)
              num_crossing = num_crossing + num_full_rotations + additive
              {new_position, num_crossing}
            else
              num_crossing = num_crossing + num_full_rotations
              {new_position, num_crossing}
            end

          :right ->
            new_position = last_position + remaining_amount

            if new_position >= @mod do
              new_position = new_position - @mod
              num_crossing = num_crossing + num_full_rotations + 1
              {new_position, num_crossing}
            else
              num_crossing = num_crossing + num_full_rotations
              {new_position, num_crossing}
            end
        end
      end)

    num_zero_crossed
  end
end
