defmodule Advent.Year2025.Day02 do
  defp parse(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(fn range ->
      [low, high] = String.split(range, "-")
      low = String.to_integer(low)
      high = String.to_integer(high)
      {low, high}
    end)
  end

  @doc """
  Performance Report for current implementation:
  Name             ips        average  deviation         median         99th %
  part_1          4.45      224.47 ms     ±2.30%      223.99 ms      236.04 ms

  Performance report for commented implementation:
  Name             ips        average  deviation         median         99th %
  part_1          1.17      858.17 ms     ±2.87%      849.21 ms      907.92 ms
  """
  def part1(args) do
    parse(args)
    |> Stream.map(fn {low, high} ->
      low..high
      |> Stream.map(fn id ->
        if repeat_twice?(Integer.digits(id)),
          do: id,
          else: 0
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  # def part1(args) do
  #   parse(args)
  #   |> Enum.map(fn {low, high} ->
  #     low..high
  #     |> Stream.map(fn x ->
  #       x_str = to_string(x)
  #       half_len = div(String.length(x_str), 2)
  #       {left, right} = String.split_at(x_str, half_len)
  #
  #       if left == right, do: x, else: 0
  #     end)
  #     |> Enum.sum()
  #   end)
  #   |> Enum.sum()
  # end

  @doc """
  Performance Report for current implementation:
  Name             ips        average  deviation         median         99th %
  part_2          4.48      223.21 ms     ±1.56%      221.95 ms      231.97 ms

  Performance report for commented implementation:
  Name             ips        average  deviation         median         99th %
  part_2          0.48         2.09 s     ±3.12%         2.07 s         2.16 s
  """
  def part2(args) do
    parse(args)
    |> Stream.map(fn {low, high} ->
      low..high
      |> Stream.map(fn id ->
        if repeats?(Integer.digits(id)),
          do: id,
          else: 0
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  # def part2(args) do
  #   parse(args)
  #   |> Stream.map(fn {low, high} ->
  #     low..high
  #     |> Stream.filter(&(&1 >= 10))
  #     |> Stream.map(fn x ->
  #       x_int = x
  #       x = to_string(x)
  #       length = String.length(x)
  #       half_len = div(length, 2)
  #
  #       found_repetition? =
  #         1..half_len
  #         |> Enum.reduce_while(false, fn base_len, _ ->
  #           {base, rest} = String.split_at(x, base_len)
  #
  #           if match_prefix(base, rest) do
  #             {:halt, true}
  #           else
  #             {:cont, false}
  #           end
  #         end)
  #
  #       if found_repetition?, do: x_int, else: 0
  #     end)
  #     |> Enum.sum()
  #   end)
  #   |> Enum.sum()
  # end
  #
  # defp match_prefix(_base, ""), do: true
  #
  # defp match_prefix(base, rest) do
  #   case rest do
  #     <<^base::binary, remaining::binary>> -> match_prefix(base, remaining)
  #     _ -> false
  #   end
  # end

  defp repeat_twice?([a, a]), do: true
  defp repeat_twice?([a, b, a, b]), do: true
  defp repeat_twice?([a, b, c, a, b, c]), do: true
  defp repeat_twice?([a, b, c, d, a, b, c, d]), do: true
  defp repeat_twice?([a, b, c, d, e, a, b, c, d, e]), do: true
  defp repeat_twice?(_), do: false

  defp repeats?([a, a]), do: true
  defp repeats?([a, a, a]), do: true
  defp repeats?([a, b, a, b]), do: true
  defp repeats?([a, a, a, a, a]), do: true
  defp repeats?([a, b, a, b, a, b]), do: true
  defp repeats?([a, b, c, a, b, c]), do: true
  defp repeats?([a, a, a, a, a, a, a]), do: true
  defp repeats?([a, b, a, b, a, b, a, b]), do: true
  defp repeats?([a, b, c, d, a, b, c, d]), do: true
  defp repeats?([a, a, a, a, a, a, a, a, a]), do: true
  defp repeats?([a, b, c, a, b, c, a, b, c]), do: true
  defp repeats?([a, b, a, b, a, b, a, b, a, b]), do: true
  defp repeats?([a, b, c, d, e, a, b, c, d, e]), do: true
  defp repeats?(_), do: false
end
