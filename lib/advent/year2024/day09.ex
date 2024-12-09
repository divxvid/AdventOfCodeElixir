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

    def compactifyv2(%Disk{} = disk) do
      blocks = compactv2(disk.blocks, Enum.reverse(disk.blocks))
      %Disk{disk | blocks: blocks}
    end

    defp compactv2(blocks, []), do: blocks

    defp compactv2(blocks, [{:space, _, _} | rest]) do
      compactv2(blocks, rest)
    end

    defp compactv2(blocks, [{:file, id, start, size} | rest]) do
      {blocks, _} =
        for block <- blocks, reduce: {[], false} do
          {acc, found?} ->
            if found? do
              {[block | acc], true}
            else
              case block do
                {:file, _, _, _} = f ->
                  {[f | acc], found?}

                {:space, space_start, space_size} = s ->
                  cond do
                    space_start > start ->
                      {[s | acc], found?}

                    space_size < size ->
                      {[s | acc], found?}

                    space_size == size ->
                      {[{:file, id, space_start, size} | acc], true}

                    space_size > size ->
                      {[
                         {:space, space_start + size, space_size - size},
                         {:file, id, space_start, size}
                         | acc
                       ], true}
                  end
              end
            end
        end

      blocks = Enum.reverse(blocks)
      compactv2(blocks, rest)
    end
  end

  def part1(args) do
    args
    |> Disk.parse()
    |> Disk.compactify()
    |> checksum()
  end

  def part2(args) do
    Disk.parse(args)
    |> Disk.compactifyv2()
    |> checksumv2()
  end

  defp checksumv2(%Disk{} = disk) do
    {_, ans} =
      for {:file, file_id, start, size} <- disk.blocks, reduce: {MapSet.new(), 0} do
        {seen, total} ->
          if MapSet.member?(seen, file_id) do
            {seen, total}
          else
            value = size * file_id * start + file_id * div(size * (size - 1), 2)
            {MapSet.put(seen, file_id), total + value}
          end
      end

    ans
  end

  defp checksum(%Disk{} = disk) do
    disk.blocks
    |> Enum.map(fn
      {:file, file_id, start, size} ->
        size * file_id * start + file_id * div(size * (size - 1), 2)

      {:space, _, _} ->
        0
    end)
    |> Enum.sum()
  end
end
