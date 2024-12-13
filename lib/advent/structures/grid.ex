defmodule Advent.Structures.Grid do
  defstruct [:n_rows, :n_cols, :elements]

  alias Advent.Structures.Grid

  @dx4 [-1, 1, 0, 0]
  @dy4 [0, 0, -1, 1]

  def new(input, opts \\ []) do
    row_delimiter = Keyword.get(opts, :row_delimiter, "\n")
    col_delimiter = Keyword.get(opts, :col_delimiter, "")
    mapper = Keyword.get(opts, :mapper, & &1)

    lines = String.split(input, row_delimiter, trim: true)
    n_rows = length(lines)
    n_cols = length(String.split(hd(lines), col_delimiter, trim: true))

    elements =
      for {r, line} <- Stream.zip([1..n_rows, lines]) do
        for {c, el} <- Stream.zip([1..n_cols, String.split(line, col_delimiter, trim: true)]) do
          {{r, c}, mapper.(el)}
        end
      end
      |> Enum.flat_map(& &1)
      |> Enum.into(Map.new())

    %Grid{
      n_rows: n_rows,
      n_cols: n_cols,
      elements: elements
    }
  end

  def get(
        %Grid{n_rows: n_rows, n_cols: n_cols, elements: elements} = _,
        row,
        column
      ) do
    cond do
      row < 1 || row > n_rows || column < 1 || column > n_cols ->
        {:error, "Invalid Index: {#{row},#{column}}"}

      true ->
        {:ok, Map.get(elements, {row, column})}
    end
  end

  def traverse4_indexes(%Grid{n_rows: n_rows, n_cols: n_cols} = _, row, column) do
    for {dx, dy} <- Stream.zip(@dx4, @dy4), reduce: [] do
      acc ->
        x = row + dx
        y = column + dy

        cond do
          x < 1 || x > n_rows || y < 1 || y > n_cols -> acc
          true -> [{x, y} | acc]
        end
    end
  end
end