defmodule Advent.Year2024.Day07 do
  def part1(args), do: solve(args, false)
  def part2(args), do: solve(args, true)

  defp solve(args, allow_concat?) do
    for {target, equation} <- parse_input(args) do
      with {:ok, operators} <- put_operators(target, tl(equation), hd(equation), allow_concat?) do
        {target, equation, operators}
      else
        :invalid -> nil
      end
    end
    |> Enum.filter(& &1)
    |> Enum.map(fn {target, _, _} -> target end)
    |> Enum.sum()
  end

  defp put_operators(target, _, current, _) when current > target, do: :invalid
  defp put_operators(target, [], current, _) when current == target, do: {:ok, []}
  defp put_operators(_, [], _, _), do: :invalid

  defp put_operators(target, [x | rest], current, allow_concat?) do
    with {:ok, other_ops} <- put_operators(target, rest, current + x, allow_concat?) do
      {:ok, [:add | other_ops]}
    else
      :invalid ->
        with {:ok, other_ops} <- put_operators(target, rest, current * x, allow_concat?) do
          {:ok, [:mult | other_ops]}
        else
          :invalid ->
            if allow_concat? do
              current = String.to_integer("#{current}#{x}")

              with {:ok, other_ops} <- put_operators(target, rest, current, allow_concat?) do
                {:ok, [:concat | other_ops]}
              else
                :invalid -> :invalid
              end
            else
              :invalid
            end
        end
    end
  end

  # defp verify_equation(operators, equation) do
  #   for {op, x} <- Stream.zip([operators, tl(equation)]), reduce: hd(equation) do
  #     a ->
  #       case op do
  #         :add -> a + x
  #         :mult -> a * x
  #         :concat -> String.to_integer("#{a}#{x}")
  #       end
  #   end
  # end

  defp parse_input(input) do
    for line <- String.split(input, "\n", trim: true) do
      [target, equation] = String.split(line, ":", trim: true)
      target = String.to_integer(target)

      equation =
        for number <- String.split(equation, " ", trim: true) do
          String.to_integer(number)
        end

      {target, equation}
    end
  end
end
