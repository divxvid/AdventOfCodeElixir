defmodule Advent.Year2025.Day03 do
  @max_bank_len 1000

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_charlist/1)
    |> Enum.map(fn bank -> Enum.map(bank, &(&1 - ?0)) end)
  end

  def part1(args) do
    parse(args)
    |> Stream.map(&Enum.zip(&1, 0..@max_bank_len))
    |> Stream.map(fn bank ->
      {mx_ch, mx_pos} = find_max(bank, 0, @max_bank_len)

      {second_mx_ch, second_mx_pos} =
        if mx_pos == length(bank) - 1,
          do: find_max(bank, 0, mx_pos - 1),
          else: find_max(bank, mx_pos + 1, @max_bank_len)

      if mx_pos < second_mx_pos,
        do: mx_ch * 10 + second_mx_ch,
        else: second_mx_ch * 10 + mx_ch
    end)
    |> Enum.sum()
  end

  def part2(args) do
    parse(args)
    |> Stream.map(&Enum.zip(&1, 0..@max_bank_len))
    |> Stream.map(fn bank ->
      memo = Map.new()
      {result, _} = find_max_joltage(bank, 10 ** 11, memo)
      result
    end)
    |> Enum.sum()
  end

  defp find_max(bank, start_idx, end_idx) do
    bank
    |> Enum.slice(start_idx..end_idx)
    |> Enum.reduce({-1, -1}, fn {ch, pos}, {mx_val, mx_pos} ->
      if ch > mx_val,
        do: {ch, pos},
        else: {mx_val, mx_pos}
    end)
  end

  defp find_max_joltage(_, 0, memo), do: {0, memo}
  defp find_max_joltage([], _, memo), do: {-1 * 10 ** 12, memo}

  defp find_max_joltage([{jolt, pos} | rest], pow10, memo) do
    if Map.has_key?(memo, {pos, pow10}) do
      val = Map.get(memo, {pos, pow10})
      {val, memo}
    else
      {taken_val, memo} = find_max_joltage(rest, div(pow10, 10), memo)
      taken = jolt * pow10 + taken_val

      {not_taken, memo} = find_max_joltage(rest, pow10, memo)
      result = max(taken, not_taken)
      memo = Map.put(memo, {pos, pow10}, result)

      {result, memo}
    end
  end
end
