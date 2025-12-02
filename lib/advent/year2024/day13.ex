defmodule Advent.Year2024.Day13 do
  defmodule Machine do
    defstruct [:x1, :y1, :x2, :y2, :px, :py]

    def parse(input) do
      [buttonA, buttonB, prize] = String.split(input, "\n", trim: true)
      {x1, y1} = parse_button(buttonA)
      {x2, y2} = parse_button(buttonB)
      {px, py} = parse_prize(prize)

      %Machine{x1: x1, x2: x2, y1: y1, y2: y2, px: px, py: py}
    end

    defp parse_button(button) do
      [_, button] = String.split(button, ":", trim: true)
      [" X", x, " Y", y] = String.split(button, ["+", ","], trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end

    defp parse_prize(prize) do
      ["Prize: X", x, " Y", y] = String.split(prize, ["=", ","], trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end
  end

  @addition 10_000_000_000_000

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&solve_machine/1)
    |> Enum.filter(&(&1 != :unsolvable))
    |> Enum.map(fn {a, b} -> 3 * a + b end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.map(fn %Machine{} = machine ->
      machine = %Machine{machine | px: machine.px + @addition}
      machine = %Machine{machine | py: machine.py + @addition}
      machine
    end)
    |> Enum.map(&solve_machine/1)
    |> Enum.filter(&(&1 != :unsolvable))
    |> Enum.map(fn {a, b} -> 3 * a + b end)
    |> Enum.sum()
  end

  # To solve this machine, we just need to solve the simultaneous equation:
  # ax1 + bx2 = px
  # ay1 + by2 = py
  # We just need to find the values of a and b. This will either give us integer
  # values of a and b or will be unsolvable.
  defp solve_machine(%Machine{} = machine) do
    numerator = machine.px * machine.y2 - machine.py * machine.x2
    denominator = machine.x1 * machine.y2 - machine.x2 * machine.y1

    if rem(numerator, denominator) != 0 do
      # these are not divisible, so we can't solve this one
      :unsolvable
    else
      a = div(numerator, denominator)
      num = machine.px - a * machine.x1
      denom = machine.x2
      if rem(num, denom) != 0, do: :unsolvable, else: {a, div(num, denom)}
    end
  end

  defp parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&Machine.parse/1)
  end
end
