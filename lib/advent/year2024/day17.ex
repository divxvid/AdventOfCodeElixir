defmodule Advent.Year2024.Day17 do
  defmodule Program do
    defstruct [:instructions]

    def parse(input, remove_jump? \\ false) do
      <<"Program: ", instructions::binary>> = input

      instructions =
        instructions
        |> String.split(",")
        |> Enum.chunk_every(2)
        |> Enum.with_index()
        |> Enum.map(fn {[opcode, operand], index} ->
          instr = opcode_to_instr(opcode)
          operand = String.to_integer(operand)
          {index * 2, {instr, operand}}
        end)
        |> Enum.reject(fn {_, {instr, _}} -> instr == :jnz and remove_jump? end)
        |> Enum.into(Map.new())

      %Program{instructions: instructions}
    end

    def get(%Program{instructions: instructions}, instruction_pointer) do
      Map.get(instructions, instruction_pointer, :halt)
    end

    defp opcode_to_instr(opcode) do
      case opcode do
        "0" -> :adv
        "1" -> :bxl
        "2" -> :bst
        "3" -> :jnz
        "4" -> :bxc
        "5" -> :out
        "6" -> :bdv
        "7" -> :cdv
      end
    end
  end

  defmodule Computer do
    defstruct [:a, :b, :c, output: :noout, instruction_ptr: 0]

    def parse(input) do
      [a, b, c] =
        String.split(input, "\n", trim: true)
        |> Enum.map(fn line ->
          <<"Register ", _type, ": ", value::binary>> = line
          String.to_integer(value)
        end)

      %Computer{a: a, b: b, c: c}
    end

    def run(%Computer{} = computer, %Program{} = program, reverse \\ true) do
      {computer, output} =
        Stream.iterate(1, & &1)
        |> Enum.reduce_while({computer, []}, fn _, {computer, output} ->
          case Computer.tick(computer, program) do
            {:cont, computer} ->
              case computer.output do
                :noout -> {:cont, {computer, output}}
                value -> {:cont, {computer, [value | output]}}
              end

            {:halt, computer} ->
              {:halt, {computer, output}}
          end
        end)

      output =
        if reverse do
          Enum.reverse(output)
        else
          output
        end

      {computer, output}
    end

    def tick(%Computer{} = computer, %Program{} = program) do
      # set the output to no output by default
      computer = Map.put(computer, :output, :noout)

      with {instruction, operand} <- Program.get(program, computer.instruction_ptr) do
        case compute(computer, instruction, operand) do
          {:ok, computer} ->
            {:cont, Map.update!(computer, :instruction_ptr, fn old -> old + 2 end)}

          {:jmp, jump_value, computer} ->
            {:cont, Map.update!(computer, :instruction_ptr, fn _old -> jump_value end)}
        end
      else
        :halt -> {:halt, computer}
      end
    end

    defp compute(%Computer{} = computer, :adv, operand) do
      numerator = computer.a
      denominator = 2 ** resolve_operand(computer, operand)
      a = div(numerator, denominator)
      {:ok, Map.put(computer, :a, a)}
    end

    defp compute(%Computer{} = computer, :bxl, operand) do
      xor = Bitwise.^^^(computer.b, operand)
      {:ok, Map.put(computer, :b, xor)}
    end

    defp compute(%Computer{} = computer, :bst, operand) do
      operand = resolve_operand(computer, operand)
      truncated = rem(operand, 8)
      {:ok, Map.put(computer, :b, truncated)}
    end

    defp compute(%Computer{} = computer, :jnz, operand) do
      if computer.a == 0 do
        {:ok, computer}
      else
        {:jmp, operand, computer}
      end
    end

    defp compute(%Computer{} = computer, :bxc, _operand) do
      xor = Bitwise.^^^(computer.b, computer.c)
      {:ok, Map.put(computer, :b, xor)}
    end

    defp compute(%Computer{} = computer, :out, operand) do
      operand = resolve_operand(computer, operand)
      output = rem(operand, 8)
      {:ok, Map.put(computer, :output, output)}
    end

    defp compute(%Computer{} = computer, :bdv, operand) do
      numerator = computer.a
      denominator = 2 ** resolve_operand(computer, operand)
      b = div(numerator, denominator)
      {:ok, Map.put(computer, :b, b)}
    end

    defp compute(%Computer{} = computer, :cdv, operand) do
      numerator = computer.a
      denominator = 2 ** resolve_operand(computer, operand)
      c = div(numerator, denominator)
      {:ok, Map.put(computer, :c, c)}
    end

    defp resolve_operand(%Computer{} = computer, operand) do
      if operand >= 0 and operand <= 3 do
        operand
      else
        case operand do
          4 -> computer.a
          5 -> computer.b
          6 -> computer.c
          7 -> :invalid
        end
      end
    end
  end

  def part1(args) do
    [computer_str, program_str] = String.split(args, "\n\n", trim: true)
    computer_str = String.trim(computer_str)
    program_str = String.trim(program_str)

    computer = Computer.parse(computer_str)
    program = Program.parse(program_str)

    {_computer, output} = Computer.run(computer, program)

    output
    |> Enum.map(&to_string/1)
    |> Enum.join(",")
  end

  def part2(args) do
    [computer_str, program_str] = String.split(args, "\n\n", trim: true)
    computer_str = String.trim(computer_str)
    program_str = String.trim(program_str)

    computer = Computer.parse(computer_str)

    # Parse the program without the last instruction that loops around
    program = Program.parse(program_str, true)

    <<"Program: ", instructions::binary>> = program_str

    # We will find the candidate from right to left because we are left shifting each time
    program_int =
      String.split(instructions, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reverse()

    {:found, ans} = check(computer, program, program_int, 0)
    ans
  end

  defp check(_, _, [], a), do: {:found, a}

  defp check(%Computer{} = computer, %Program{} = program, [target | rest], a) do
    candidate =
      Enum.reduce_while(0..7, nil, fn vals, nil ->
        candidate = a * 8 + vals
        computer1 = Map.put(computer, :a, candidate)
        {_computer, output} = Computer.run(computer1, program, false)
        first = hd(output)

        if first == target do
          case check(computer, program, rest, candidate) do
            {:found, x} -> {:halt, x}
            _ -> {:cont, nil}
          end
        else
          {:cont, nil}
        end
      end)

    if candidate == nil, do: nil, else: {:found, candidate}
  end
end
