defmodule Advent.Year2025.Day11 do
  def part1(args) do
    graph = parse(args)
    {total_paths, _} = count_total_paths(graph, "you", "out", Map.new())
    total_paths
  end

  def part2(args) do
    graph = parse(args)
    {paths_to_fft, _} = count_total_paths(graph, "svr", "fft", Map.new())
    {paths_to_dac, _} = count_total_paths(graph, "fft", "dac", Map.new())
    {paths_to_out, _} = count_total_paths(graph, "dac", "out", Map.new())

    paths_to_fft * paths_to_dac * paths_to_out
  end

  defp count_total_paths(_, target, target, memo), do: {1, memo}
  defp count_total_paths(_, "out", _, memo), do: {0, memo}

  defp count_total_paths(graph, node, target, memo) do
    if Map.has_key?(memo, node) do
      {Map.get(memo, node), memo}
    else
      edges = Map.get(graph, node)

      {total_paths, memo} =
        Enum.reduce(edges, {0, memo}, fn edge_node, {count, memo} ->
          {c, memo} = count_total_paths(graph, edge_node, target, memo)
          {count + c, memo}
        end)

      memo = Map.put(memo, node, total_paths)
      {total_paths, memo}
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(fn line ->
      [node, edges] = String.split(line, ": ", trim: true)
      edges = String.split(edges, " ", trim: true)
      {node, edges}
    end)
    |> Enum.into(Map.new())
  end
end
