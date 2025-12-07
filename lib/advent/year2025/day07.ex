defmodule Advent.Year2025.Day07 do
  alias Advent.Structures.Grid

  def part1(args) do
    %Grid{} = grid = Grid.new(args)

    start_col =
      args
      |> String.split("\n", parts: 2, trim: true)
      |> hd()
      |> String.to_charlist()
      |> Enum.find_index(&(&1 == ?S))

    # zero based to one based index
    start_col = start_col + 1

    {_, splitters_seen} =
      Range.new(2, grid.n_rows)
      |> Enum.reduce({MapSet.new([start_col]), 0}, fn r, {beam_cols, splitters_seen} ->
        Enum.reduce(beam_cols, {MapSet.new(), splitters_seen}, fn c,
                                                                  {next_beam_cols, splitters_seen} ->
          with {:ok, ch} <- Grid.get(grid, r, c) do
            case ch do
              "." ->
                {MapSet.put(next_beam_cols, c), splitters_seen}

              "^" ->
                {
                  next_beam_cols
                  |> MapSet.put(c - 1)
                  |> MapSet.put(c + 1),
                  splitters_seen + 1
                }
            end
          else
            {:error, _} -> {next_beam_cols, splitters_seen}
          end
        end)
      end)

    splitters_seen
  end

  def part2(args) do
    %Grid{} = grid = Grid.new(args)

    start_col =
      args
      |> String.split("\n", parts: 2, trim: true)
      |> hd()
      |> String.to_charlist()
      |> Enum.find_index(&(&1 == ?S))

    # zero based to one based index
    start_col = start_col + 1

    {timelines, _} = go(grid, 2, start_col, Map.new())
    timelines
  end

  defp go(%Grid{n_rows: n_rows}, r, _, memo) when r == n_rows + 1, do: {1, memo}

  defp go(%Grid{} = grid, r, c, memo) do
    if Map.has_key?(memo, {r, c}) do
      value = Map.get(memo, {r, c})
      {value, memo}
    else
      with {:ok, ch} <- Grid.get(grid, r, c) do
        {value, memo} =
          case ch do
            "." ->
              go(grid, r + 1, c, memo)

            "^" ->
              {left_total, memo} = go(grid, r + 1, c - 1, memo)
              {right_total, memo} = go(grid, r + 1, c + 1, memo)
              {left_total + right_total, memo}
          end

        {value, Map.put(memo, {r, c}, value)}
      else
        {:error, _} -> {0, memo}
      end
    end
  end
end
