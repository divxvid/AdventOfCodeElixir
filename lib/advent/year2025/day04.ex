defmodule Advent.Year2025.Day04 do
  alias Advent.Structures.Grid

  def part1(args) do
    %Grid{} = grid = Grid.new(args)

    Enum.reduce(1..grid.n_rows, 0, fn r, acc ->
      Enum.reduce(1..grid.n_cols, acc, fn c, acc ->
        if Grid.get!(grid, r, c) == "@" do
          rolls_of_paper =
            Grid.traverse8_indexes(grid, r, c)
            |> Enum.filter(fn {r, c} -> Grid.get!(grid, r, c) == "@" end)
            |> Enum.count()

          if rolls_of_paper < 4,
            do: acc + 1,
            else: acc
        else
          acc
        end
      end)
    end)
  end

  def part2(args) do
    %Grid{} = grid = Grid.new(args)

    Enum.reduce_while(1..10000, {0, grid}, fn _, {acc, grid} ->
      {rolls_removed, grid} =
        Enum.reduce(1..grid.n_rows, {0, grid}, fn r, {acc, grid} ->
          Enum.reduce(1..grid.n_cols, {acc, grid}, fn c, {acc, grid} ->
            if Grid.get!(grid, r, c) == "@" do
              rolls_of_paper =
                Grid.traverse8_indexes(grid, r, c)
                |> Enum.filter(fn {r, c} -> Grid.get!(grid, r, c) == "@" end)
                |> Enum.count()

              if rolls_of_paper < 4 do
                grid = Grid.update!(grid, r, c, ".")
                {acc + 1, grid}
              else
                {acc, grid}
              end
            else
              {acc, grid}
            end
          end)
        end)

      if rolls_removed == 0,
        do: {:halt, acc},
        else: {:cont, {acc + rolls_removed, grid}}
    end)
  end
end
