defmodule Advent.Year2024.Day08 do
  defmodule CityGrid do
    defstruct [:width, :height, :antennas]

    def parse(input) do
      lines = String.split(input)
      height = length(lines)
      width = String.length(hd(lines))

      antennas =
        for {r, line} <- Stream.zip(1..height, lines), reduce: Map.new() do
          acc ->
            for {c, ch} <- Stream.zip(1..width, String.to_charlist(line)), reduce: acc do
              acc ->
                cond do
                  ch in ?a..?z ->
                    put_antenna(acc, ch, r, c)

                  ch in ?A..?Z ->
                    put_antenna(acc, ch, r, c)

                  ch in ?0..?9 ->
                    put_antenna(acc, ch, r, c)

                  ch == ?. ->
                    acc
                end
            end
        end

      %CityGrid{
        height: height,
        width: width,
        antennas: antennas
      }
    end

    defp put_antenna(antennas, type, r, c) do
      antenna_list = Map.get(antennas, type, [])
      Map.put(antennas, type, [{r, c} | antenna_list])
    end
  end

  def part1(args), do: solve(args, true)
  def part2(args), do: solve(args, false)

  defp solve(args, single_antinode?) do
    %CityGrid{antennas: antennas, width: width, height: height} = CityGrid.parse(args)

    for {_, locations} <- antennas do
      for {i1, loc1} <- Stream.zip(Stream.iterate(0, &(&1 + 1)), locations),
          {i2, loc2} <- Stream.zip(Stream.iterate(0, &(&1 + 1)), locations),
          i1 < i2 do
        antinodes1 = find_antinodes(loc1, loc2, height, width, single_antinode?)
        antinodes2 = find_antinodes(loc2, loc1, height, width, single_antinode?)
        antinodes = Enum.flat_map([antinodes1, antinodes2], & &1)

        if single_antinode?,
          do: antinodes,
          else: [loc1, loc2 | antinodes]
      end
      |> Enum.flat_map(& &1)
    end
    |> Enum.flat_map(& &1)
    |> Enum.into(MapSet.new())
    |> MapSet.size()
  end

  defp find_antinodes({r1, c1}, {r2, c2}, height, width, single?) do
    delta_r = r2 - r1
    delta_c = c2 - c1

    if single? do
      ar = r2 + delta_r
      ac = c2 + delta_c

      if ar > 0 && ar <= height && ac > 0 && ac <= width,
        do: [{ar, ac}],
        else: []
    else
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while([], fn m, acc ->
        m_delta_r = m * delta_r
        m_delta_c = m * delta_c

        ar = r2 + m_delta_r
        ac = c2 + m_delta_c

        if ar > 0 && ar <= height && ac > 0 && ac <= width,
          do: {:cont, [{ar, ac} | acc]},
          else: {:halt, acc}
      end)
    end
  end
end
