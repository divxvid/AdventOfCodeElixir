defmodule Advent.Year2025.Day10 do
  require Dantzig.Problem, as: Problem

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
    |> Stream.map(fn {_, switches, joltage} ->
      result = solve_lpp(switches, joltage)
      result
    end)
    |> Enum.sum()
  end

  defp solve_lpp(switches, joltage) do
    problem = Problem.new(direction: :minimize)
    variable_prefixes = Enum.map(switches, fn _ -> "v" end)

    {problem, variables} =
      Problem.new_variables(problem, variable_prefixes, min: 0, type: :integer)

    problem =
      Stream.zip(0..1000, joltage)
      |> Enum.reduce(problem, fn {i, jtg}, problem ->
        constraint_var_list =
          Stream.zip(variables, switches)
          |> Enum.reduce([], fn {v, sw}, acc ->
            if i in sw,
              do: [v | acc],
              else: acc
          end)

        Problem.add_constraint(
          problem,
          Dantzig.Constraint.new(Dantzig.Polynomial.sum(constraint_var_list), :==, jtg)
        )
      end)

    problem = Problem.increment_objective(problem, Dantzig.Polynomial.sum(variables))
    {:ok, solution} = Dantzig.solve(problem)

    solution.objective
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
