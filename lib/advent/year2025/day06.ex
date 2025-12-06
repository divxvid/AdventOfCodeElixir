defmodule Advent.Year2025.Day06 do
  @space_ascii 32

  def part1(args) do
    rows = String.split(args, "\n", trim: true)

    data =
      Enum.slice(rows, 0..-2//1)
      |> Enum.map(fn row ->
        row
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    operations =
      List.last(rows)
      |> String.split(" ", trim: true)

    Stream.zip(Stream.zip(data), operations)
    |> Stream.map(fn {col, operation} ->
      col = Tuple.to_list(col)

      case operation do
        "+" -> Enum.sum(col)
        "*" -> Enum.product(col)
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    rows = String.split(args, "\n", trim: true)

    operations =
      List.last(rows)
      |> String.split(" ", trim: true)

    data_rows =
      rows
      |> Enum.slice(0..-2//1)
      |> Stream.map(fn row ->
        row
        |> String.to_charlist()
        |> Enum.reverse()
      end)
      |> Stream.zip()
      |> Enum.map(&Tuple.to_list/1)

    data = parse_numbers(data_rows, []) |> Enum.reverse()

    Stream.zip(operations, data)
    |> Stream.map(fn {op, d} ->
      case op do
        "+" -> Enum.sum(d)
        "*" -> Enum.product(d)
      end
    end)
    |> Enum.sum()
  end

  defp parse_numbers([], current), do: [current]

  defp parse_numbers([row | rest], current) do
    all_spaces? = Enum.filter(row, &(&1 != @space_ascii)) |> Enum.empty?()

    if all_spaces? do
      [current | parse_numbers(rest, [])]
    else
      numeric_repr =
        row
        |> Enum.filter(&(&1 != @space_ascii))
        |> Enum.map(&(&1 - ?0))
        |> Integer.undigits()

      parse_numbers(rest, [numeric_repr | current])
    end
  end
end
