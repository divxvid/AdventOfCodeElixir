defmodule Advent.Year2025.Day10 do
  alias Heap

  def part1(args) do
    parse(args)
    |> Enum.map(fn {bulbs, switches, _} ->
      switches
      |> Enum.map(fn switch ->
        switch
        |> Enum.reduce(0, fn x, acc ->
          Bitwise.bor(acc, Bitwise.<<<(1, x))
        end)
      end)
      |> find_min_switch(0, 0, bulbs)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    parse(args)
    |> Enum.map(fn {_, switches, joltage} ->
      find_min_joltage(switches, joltage)
    end)
    |> IO.inspect()
    |> Enum.sum()
  end

  defp find_min_joltage(switches, joltage) do
    heap =
      joltage
      |> Enum.zip(0..100)
      |> Enum.into(Heap.new())

    latest_values =
      Enum.zip(0..100, joltage)
      |> Enum.into(Map.new())

    Enum.reduce_while(1..200_000, {0, heap, latest_values}, fn _, {count, heap, latest_values} ->
      heap = clean_heap(heap, latest_values)

      if Heap.empty?(heap) do
        IO.inspect(latest_values)
        {:halt, count}
      else
        {_joltage, idx} = Heap.root(heap)
        heap = Heap.pop(heap)

        selected_switch = find_appropriate_switch(switches, latest_values, idx)

        {heap, latest_values} =
          selected_switch
          |> Enum.reduce({heap, latest_values}, fn idx, {heap, latest_values} ->
            old_value = Map.get(latest_values, idx)
            new_value = old_value - 1

            latest_values =
              if new_value == 0,
                do: Map.delete(latest_values, idx),
                else: Map.update!(latest_values, idx, fn _ -> new_value end)

            heap =
              if new_value == 0,
                do: heap,
                else: Heap.push(heap, {new_value, idx})

            {heap, latest_values}
          end)

        {:cont, {count + 1, heap, latest_values}}
      end
    end)
  end

  defp clean_heap(heap, latest_values) do
    Enum.reduce_while(0..200_000, heap, fn _, heap ->
      if Heap.empty?(heap) do
        {:halt, heap}
      else
        {joltage, idx} = Heap.root(heap)

        if Map.has_key?(latest_values, idx) do
          if joltage != Map.get(latest_values, idx) do
            {:cont, Heap.pop(heap)}
          else
            {:halt, heap}
          end
        else
          {:cont, Heap.pop(heap)}
        end
      end
    end)
  end

  defp find_appropriate_switch(switches, remaining, target) do
    {_, switch} =
      switches
      |> Enum.filter(fn switch ->
        Enum.all?(switch, &Map.has_key?(remaining, &1))
      end)
      |> Enum.filter(fn switch -> Enum.any?(switch, &(&1 == target)) end)
      |> Enum.reduce({0, []}, fn switch, {len, value} ->
        if length(switch) > len,
          do: {length(switch), switch},
          else: {len, value}
      end)

    switch
  end

  defp find_min_switch([], cnt, value, target) do
    if value == target,
      do: cnt,
      else: 100_000
  end

  defp find_min_switch([switch | rest], cnt, value, target) do
    new_value = Bitwise.bxor(value, switch)

    min(
      find_min_switch(rest, cnt, value, target),
      find_min_switch(rest, cnt + 1, new_value, target)
    )
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      parse_line(line)
    end)
  end

  defp parse_line(line) do
    [bulbs, rest] = String.split(line, " ", parts: 2)
    [switches, joltage] = String.split(rest, " {", trim: true)
    joltage = String.trim_trailing(joltage, "}")

    bulbs = parse_bulbs(bulbs)
    switches = parse_switches(switches)
    joltage = parse_joltage(joltage)

    {bulbs, switches, joltage}
  end

  defp parse_bulbs(bulbs) do
    # We encode the bulbs in binary with lsb as the index 0
    bulbs
    |> String.trim_leading("[")
    |> String.trim_trailing("]")
    |> String.to_charlist()
    |> Enum.reverse()
    |> Enum.map(fn ch ->
      case ch do
        ?. -> 0
        ?# -> 1
      end
    end)
    |> Integer.undigits(2)
  end

  defp parse_switches(switches) do
    switches
    |> String.split(" ", trim: true)
    |> Enum.map(fn switch ->
      switch
      |> String.trim_leading("(")
      |> String.trim_trailing(")")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp parse_joltage(joltage) do
    joltage
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
