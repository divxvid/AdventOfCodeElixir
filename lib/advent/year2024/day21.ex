defmodule Advent.Year2024.Day21 do
  @keypad %{
    ?A => {4, 3},
    ?0 => {4, 2},
    ?1 => {3, 1},
    ?2 => {3, 2},
    ?3 => {3, 3},
    ?4 => {2, 1},
    ?5 => {2, 2},
    ?6 => {2, 3},
    ?7 => {1, 1},
    ?8 => {1, 2},
    ?9 => {1, 3}
  }

  @directionpad %{
    ?^ => {1, 2},
    ?A => {1, 3},
    ?< => {2, 1},
    ?v => {2, 2},
    ?> => {2, 3}
  }

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {number_part, "A"} = String.split_at(line, 3)

      total_length =
        line
        |> String.to_charlist()
        |> robot_to_keypad(?A)
        |> robot_to_robot(?A)
        |> robot_to_robot(?A)
        |> length()
        |> dbg()

      String.to_integer(number_part) * total_length
    end)
    |> IO.inspect()
    |> Enum.sum()
  end

  def part2(args) do
    args
  end

  # Movement priority: down, right, left, up
  def robot_to_robot(command, start_character) do
    {start_r, start_c} = @directionpad[start_character]

    {_, reversed_movement} =
      command
      |> Enum.reduce({{start_r, start_c}, []}, fn ch, {{r, c}, movements} ->
        {target_r, target_c} = @directionpad[ch]

        {{r, c}, movement1} =
          cond do
            target_r < r ->
              up_movement = Stream.cycle([?^]) |> Enum.take(r - target_r)
              {{target_r, c}, up_movement}

            target_r > r ->
              down_movement = Stream.cycle([?v]) |> Enum.take(target_r - r)
              {{target_r, c}, down_movement}

            true ->
              {{r, c}, []}
          end

        {{r, c}, movement2} =
          cond do
            target_c < c ->
              left_movement = Stream.cycle([?<]) |> Enum.take(c - target_c)
              {{r, target_c}, left_movement}

            target_c > c ->
              right_movement = Stream.cycle([?>]) |> Enum.take(target_c - c)
              {{r, target_c}, right_movement}

            true ->
              {{r, c}, []}
          end

        local_movement = movement2 ++ movement1 ++ [?A]
        {{r, c}, [local_movement | movements]}
      end)

    reversed_movement
    |> Enum.reverse()
    |> Enum.concat()
  end

  # Movement priority: up, right, left, down
  def robot_to_keypad(command, start_character) do
    {start_r, start_c} = @keypad[start_character]

    {_, reversed_movement} =
      command
      |> Enum.reduce({{start_r, start_c}, []}, fn ch, {{r, c}, movements} ->
        {target_r, target_c} = @keypad[ch]

        {{r, c}, movement1} =
          cond do
            target_r > r ->
              down_movement = Stream.cycle([?v]) |> Enum.take(target_r - r)
              {{target_r, c}, down_movement}

            target_c < c ->
              left_movement = Stream.cycle([?<]) |> Enum.take(c - target_c)
              {{r, target_c}, left_movement}

            target_c > c ->
              right_movement = Stream.cycle([?>]) |> Enum.take(target_c - c)
              {{r, target_c}, right_movement}

            target_r < r ->
              up_movement = Stream.cycle([?^]) |> Enum.take(r - target_r)
              {{target_r, c}, up_movement}

            true ->
              {{r, c}, []}
          end

        {{r, c}, movement2} =
          cond do
            target_r > r ->
              down_movement = Stream.cycle([?v]) |> Enum.take(target_r - r)
              {{target_r, c}, down_movement}

            target_c < c ->
              left_movement = Stream.cycle([?<]) |> Enum.take(c - target_c)
              {{r, target_c}, left_movement}

            target_c > c ->
              right_movement = Stream.cycle([?>]) |> Enum.take(target_c - c)
              {{r, target_c}, right_movement}

            target_r < r ->
              up_movement = Stream.cycle([?^]) |> Enum.take(r - target_r)
              {{target_r, c}, up_movement}

            true ->
              {{r, c}, []}
          end

        local_movement = movement2 ++ movement1 ++ [?A]
        {{r, c}, [local_movement | movements]}
      end)

    reversed_movement
    |> Enum.reverse()
    |> Enum.concat()
  end
end
