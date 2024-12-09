defmodule Advent.Year2024.Day09 do
  defmodule Disk do
    defstruct [:blocks, :total_files, :total_blocks]

    def parse(input) do
      {blocks, total_files, total_blocks} =
        input
        |> String.trim()
        |> String.to_charlist()
        |> Enum.chunk_every(2)
        |> Enum.reduce({[], 0, 0}, fn block, {blocks, file_id, current_block_number} ->
          case block do
            [file_block_count, space_count] ->
              file_block_count = file_block_count - ?0
              space_count = space_count - ?0

              blocks = [
                {:space, current_block_number + file_block_count, space_count},
                {:file, file_id, current_block_number, file_block_count}
                | blocks
              ]

              {blocks, file_id + 1, current_block_number + file_block_count + space_count}

            [file_block_count] ->
              file_block_count = file_block_count - ?0
              blocks = [{:file, file_id, current_block_number, file_block_count} | blocks]
              {blocks, file_id + 1, current_block_number + file_block_count}
          end
        end)

      blocks = Enum.reverse(blocks)

      %Disk{blocks: blocks, total_files: total_files, total_blocks: total_blocks}
    end

    def compactify(%Disk{blocks: blocks, total_blocks: total_blocks} = disk) do
      compacted_blocks = compact(blocks, Enum.reverse(blocks))
      {:file, _, start, length} = List.last(compacted_blocks)

      compacted_blocks =
        compacted_blocks ++ [{:space, start + length, total_blocks - start - length}]

      %Disk{blocks: compacted_blocks, total_files: disk.total_files, total_blocks: total_blocks}
    end

    defp compact([{:file, fid, start1, fsz} | rest1], [{:file, _, start2, fsz2} | _] = other) do
      cond do
        start1 > start2 -> []
        start1 == start2 -> [{:file, fid, start2, fsz2}]
        true -> [{:file, fid, start1, fsz} | compact(rest1, other)]
      end
    end

    defp compact([{:space, start1, _} | _] = spaces, [{:space, start2, _} | rest2]) do
      cond do
        start1 > start2 ->
          []

        true ->
          compact(spaces, rest2)
      end
    end

    defp compact([{:file, fid, file_start, fsz} | rest1], [{:space, space_start, _} | rest2]) do
      cond do
        file_start > space_start -> []
        true -> [{:file, fid, file_start, fsz} | compact(rest1, rest2)]
      end
    end

    defp compact(
           [{:space, space_start, space_size} | rest_spaces],
           [{:file, file_id, file_start, file_size} | rest_files]
         ) do
      cond do
        space_start > file_start ->
          []

        space_size == file_size ->
          [{:file, file_id, space_start, file_size} | compact(rest_spaces, rest_files)]

        space_size > file_size ->
          spaces = [{:space, space_start + file_size, space_size - file_size} | rest_spaces]
          [{:file, file_id, space_start, file_size} | compact(spaces, rest_files)]

        space_size < file_size ->
          files = [{:file, file_id, file_start, file_size - space_size} | rest_files]
          [{:file, file_id, space_start, space_size} | compact(rest_spaces, files)]
      end
    end
  end

  def part1(args) do
    disk = Disk.parse(args)
    compacted_disk = Disk.compactify(disk)

    # IO.inspect(compacted_disk)

    # [{:space, _, space_size}] =
    #   compacted_disk.blocks
    #   |> Enum.filter(fn
    #     {:space, _, _} -> true
    #     {:file, _, _, _} -> false
    #   end)
    #   |> IO.inspect()
    #
    # space_after = space_size
    #
    # space_before =
    #   disk.blocks
    #   |> Enum.filter(fn
    #     {:space, _, _} -> true
    #     {:file, _, _, _} -> false
    #   end)
    #   |> Enum.map(fn {:space, _, sz} -> sz end)
    #   |> Enum.sum()
    #
    # IO.inspect({space_before, space_after}, label: "testing equality")
    #
    # original =
    #   disk.blocks
    #   |> Enum.filter(fn
    #     {:space, _, _} -> false
    #     {:file, _, _, _} -> true
    #   end)
    #   |> Enum.reduce(%{}, fn {:file, id, _, sz}, acc ->
    #     Map.update(acc, id, sz, fn old -> old + sz end)
    #   end)
    #
    # new =
    #   compacted_disk.blocks
    #   |> Enum.filter(fn
    #     {:space, _, _} -> false
    #     {:file, _, _, _} -> true
    #   end)
    #   |> Enum.reduce(%{}, fn {:file, id, _, sz}, acc ->
    #     Map.update(acc, id, sz, fn old -> old + sz end)
    #   end)
    #
    # discrepencies =
    #   for {id, sz} <- original do
    #     nsz = Map.get(new, id)
    #     if nsz != sz, do: {id, sz, nsz}, else: nil
    #   end
    #   |> Enum.filter(& &1)
    #
    # IO.inspect(discrepencies, label: "discrepencies")

    compacted_disk.blocks
    |> Enum.filter(fn block ->
      case block do
        {:file, _, _, _} -> true
        _ -> false
      end
    end)
    |> Enum.map(fn {:file, file_id, start, size} ->
      size * file_id * start + file_id * div(size * (size - 1), 2)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
  end
end
