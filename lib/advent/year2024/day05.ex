defmodule Advent.Year2024.Day05 do
  def part1(args) do
    {rules, updates} = parse_input(args)

    for update <- updates do
      ok? = is_update_good?(update, rules)

      if ok? do
        index = div(length(update), 2)
        Enum.at(update, index)
      else
        0
      end
    end
    |> Enum.sum()
  end

  def part2(args) do
    {rules, updates} = parse_input(args)

    for update <- updates do
      ok? = is_update_good?(update, rules)

      if not ok? do
        update = fix_update(update, rules)
        index = div(length(update), 2)
        Enum.at(update, index)
      else
        0
      end
    end
    |> Enum.sum()
  end

  defp parse_input(input) do
    [rules, updates] = String.split(input, "\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [before, current] = String.split(line, "|", trim: true)
        {String.to_integer(before), String.to_integer(current)}
      end)
      |> Enum.into(MapSet.new())

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  defp is_update_good?(update, rules) do
    {ok?, _} =
      Enum.reduce(update, {true, tl(update)}, fn head, {ok?, tail} ->
        bad? =
          tail
          |> Enum.map(fn e ->
            MapSet.member?(rules, {e, head})
          end)
          |> Enum.any?()

        tail =
          case tail do
            [] -> []
            tail -> tl(tail)
          end

        {ok? && not bad?, tail}
      end)

    ok?
  end

  defp fix_update(update, rules) do
    Enum.sort(update, fn u1, u2 ->
      MapSet.member?(rules, {u2, u1})
    end)
  end
end
