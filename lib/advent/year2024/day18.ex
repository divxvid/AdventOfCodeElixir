defmodule Advent.Year2024.Day18 do
  @inf 10_000_000

  def part1(args, opts \\ []) do
    width = Keyword.get(opts, :width, 71)
    height = Keyword.get(opts, :height, 71)
    take = Keyword.get(opts, :take, 1024)

    obstacles =
      args
      |> String.split("\n", trim: true)
      |> Enum.take(take)
      |> Enum.map(fn line ->
        [r, c] = String.split(line, ",", trim: true)
        {String.to_integer(r), String.to_integer(c)}
      end)
      |> Enum.into(MapSet.new())

    queue = :queue.new()
    queue = :queue.in({0, 0, 0}, queue)

    distances =
      Stream.iterate(1, & &1)
      |> Enum.reduce_while({queue, Map.new()}, fn _, {queue, distances} ->
        with {{:value, {r, c, dist}}, queue} <- :queue.out(queue) do
          cond do
            r < 0 or r >= height ->
              {:cont, {queue, distances}}

            c < 0 or c >= width ->
              {:cont, {queue, distances}}

            MapSet.member?(obstacles, {r, c}) ->
              {:cont, {queue, distances}}

            dist >= Map.get(distances, {r, c}, @inf) ->
              {:cont, {queue, distances}}

            true ->
              distances = Map.put(distances, {r, c}, dist)

              queue =
                [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
                |> Enum.reduce(queue, fn {dr, dc}, queue ->
                  rr = r + dr
                  cc = c + dc

                  :queue.in({rr, cc, dist + 1}, queue)
                end)

              {:cont, {queue, distances}}
          end
        else
          {:empty, _} -> {:halt, distances}
          other -> raise "Got something weird: #{other}"
        end
      end)

    case Map.fetch(distances, {height - 1, width - 1}) do
      {:ok, value} -> value
      :error -> :unreachable
    end
  end

  def part2(args, opts \\ []) do
    width = Keyword.get(opts, :width, 71)
    height = Keyword.get(opts, :height, 71)

    byte_number = search(args, width, height, 1, 5000, -1)

    [result] =
      args
      |> String.split("\n", trim: true)
      |> Enum.drop(byte_number)
      |> Enum.take(1)

    result
  end

  defp search(args, width, height, low, high, candidate) when low <= high do
    mid = div(low + high, 2)

    case part1(args, width: width, height: height, take: mid) do
      :unreachable ->
        search(args, width, height, low, mid - 1, candidate)

      _value ->
        search(args, width, height, mid + 1, high, mid)
    end
  end

  defp search(_, _, _, _, _, candidate), do: candidate
end
