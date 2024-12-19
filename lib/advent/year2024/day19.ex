defmodule Advent.Year2024.Day19 do
  alias Advent.Structures.Trie

  def part1(args) do
    pattern_counts(args)
    |> Enum.filter(&(&1 > 0))
    |> Enum.count()
  end

  def part2(args) do
    pattern_counts(args)
    |> Enum.sum()
  end

  defp pattern_counts(args) do
    [towels, patterns] = String.split(args, "\n\n", trim: true)
    towels = String.split(towels, ", ", trim: true)
    patterns = String.split(patterns, "\n", trim: true)

    trie =
      towels
      |> Enum.reduce(Trie.new(), fn towel, trie ->
        Trie.insert(trie, towel)
      end)

    memo = Map.new()

    {_, result} =
      patterns
      |> Enum.reduce({memo, []}, fn pattern, {memo, result} ->
        {count, memo} = count_possibilities(pattern, trie, memo)
        {memo, [count | result]}
      end)

    Enum.reverse(result)
  end

  defp count_possibilities(pattern, trie, memo) do
    case Map.fetch(memo, pattern) do
      {:ok, value} ->
        {value, memo}

      :error ->
        {value, memo} =
          Trie.find(trie, pattern)
          |> Enum.reduce({0, memo}, fn result, {cnt, memo} ->
            case result do
              :error ->
                {cnt, memo}

              {:ok, _} ->
                {cnt + 1, memo}

              {:unfinished, rest} ->
                {cnt1, memo} = count_possibilities(rest, trie, memo)
                {cnt + cnt1, memo}
            end
          end)

        memo = Map.put(memo, pattern, value)
        {value, memo}
    end
  end
end
