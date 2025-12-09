defmodule Advent.Year2025.Day09 do
  @epsilon 0.000001
  def part1(args) do
    red_tiles = parse(args)
    calc_max_area(red_tiles, 0)
  end

  def part2(args) do
    red_tiles = parse(args)
    calc_max_area2(red_tiles, red_tiles, 0)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [r, c] = line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
      {c, r}
    end)
  end

  defp calc_max_area([{r, c} | rest], max_area) do
    max_area =
      rest
      |> Enum.reduce(max_area, fn {rr, cc}, max_area ->
        dr = abs(r - rr) + 1
        dc = abs(c - cc) + 1
        area = dr * dc
        max(max_area, area)
      end)

    calc_max_area(rest, max_area)
  end

  defp calc_max_area(_, max_area), do: max_area

  defp calc_max_area2([{r, c} | rest], red_tiles, max_area) do
    max_area =
      rest
      # |> Enum.reject(fn {rr, cc} -> r == rr || c == cc end)
      |> Enum.filter(fn {rr, cc} -> allowed?(red_tiles, {r, c}, {rr, cc}) end)
      # |> IO.inspect()
      |> Enum.reduce(max_area, fn {rr, cc}, max_area ->
        dr = abs(r - rr) + 1
        dc = abs(c - cc) + 1
        area = dr * dc
        # IO.inspect({{r, c}, {rr, cc}, max_area})
        max(max_area, area)
      end)

    # IO.inspect({{r, c}, max_area})
    calc_max_area2(rest, red_tiles, max_area)
  end

  defp calc_max_area2(_, _, max_area), do: max_area

  def allowed?(red_tiles, {r, c}, {rr, cc}) do
    virtual_point1 = {r, cc}
    virtual_point2 = {rr, c}

    is_point_in_polygon?(virtual_point1, red_tiles) &&
      is_point_in_polygon?(virtual_point2, red_tiles) &&
      rectangle_inside_polygon?(red_tiles, {r, c}, {rr, cc})
  end

  defp rectangle_inside_polygon?(red_tiles, {r, c}, {rr, cc}) do
    rect = [{r, c}, {r, cc}, {rr, cc}, {rr, c}, {r, c}]

    horizontal_rect =
      Stream.zip(rect, tl(rect))
      |> Enum.filter(fn {{r1, _}, {r2, _}} -> r1 == r2 end)

    vertical_rect =
      Stream.zip(rect, tl(rect))
      |> Enum.filter(fn {{_, c1}, {_, c2}} -> c1 == c2 end)

    horizontal_poly =
      Stream.zip(red_tiles, tl(red_tiles) ++ [hd(red_tiles)])
      |> Enum.filter(fn {{r1, _}, {r2, _}} -> r1 == r2 end)

    vertical_poly =
      Stream.zip(red_tiles, tl(red_tiles) ++ [hd(red_tiles)])
      |> Enum.filter(fn {{_, c1}, {_, c2}} -> c1 == c2 end)

    !(do_intersect?(horizontal_poly, vertical_rect, false) ||
        do_intersect?(horizontal_rect, vertical_poly, false))
  end

  defp do_intersect?(_, _, true), do: true
  defp do_intersect?([], _, x), do: x

  defp do_intersect?([h | hs], vs, false) do
    intersect =
      vs
      |> Enum.map(fn v -> check_intersection?(h, v) end)
      |> Enum.any?()

    do_intersect?(hs, vs, intersect)
  end

  defp check_intersection?({{pr1, pc1}, {_, pc2}}, {{rr1, rc1}, {rr2, _}}) do
    {rr1, rr2} = {min(rr1, rr2), max(rr1, rr2)}
    {pc1, pc2} = {min(pc1, pc2), max(pc1, pc2)}

    rr1 < pr1 && pr1 < rr2 && pc1 < rc1 && rc1 < pc2
  end

  def is_point_in_polygon?(point, polygon) do
    # A polygon must have at least 3 vertices
    if length(polygon) < 3 do
      false
    else
      # Prepend the first point to the end to easily iterate over edges
      # (P1, P2), (P2, P3), ..., (Pn, P1)
      polygon_closed = polygon ++ [hd(polygon)]
      num_intersections = count_intersections(point, polygon_closed)

      rem(num_intersections, 2) == 1
    end
  end

  defp count_intersections({px, py}, polygon_closed) do
    Enum.chunk_every(polygon_closed, 2, 1, :discard)
    |> Enum.reduce(0, fn [{p1x, p1y}, {p2x, p2y}], acc ->
      if point_on_segment?({px, py}, {p1x, p1y}, {p2x, p2y}) do
        # If the point is on an edge, it's considered inside.
        # This takes precedence over ray casting.
        1
      else
        # Ray casting logic for an edge
        cond do
          # Check if the ray from `point` (to the right) intersects the segment (p1, p2)
          # Conditions for intersection:
          # 1. The edge must cross the horizontal line of the point (py)
          # 2. The intersection point's x-coordinate must be greater than px

          (p1y > py && p2y <= py) || (p2y > py && p1y <= py) ->
            # If the segment is horizontal and aligned with the ray, don't count it.
            # (point_on_segment? handles the point being on the edge)
            if abs(p1y - p2y) < @epsilon do
              acc
            else
              # Calculate the x-coordinate of the intersection point
              # t = (py - p1y) / (p2y - p1y)
              # intersection_x = p1x + t * (p2x - p1x)

              denominator = p2y - p1y

              # Should have been caught by horizontal check
              if abs(denominator) < @epsilon do
                acc
              else
                t = (py - p1y) / denominator
                intersection_x = p1x + t * (p2x - p1x)

                if intersection_x > px do
                  acc + 1
                else
                  acc
                end
              end
            end

          # No intersection
          true ->
            acc
        end
      end
    end)
    |> case do
      # Treat as inside if point is on a segment
      :exit -> 1
      num -> num
    end
  end

  # Checks if a point {px, py} lies on a line segment defined by {p1x, p1y} and {p2x, p2y}.
  # This is crucial for handling edge cases where the point is exactly on the polygon boundary.
  defp point_on_segment?({px, py}, {p1x, p1y}, {p2x, p2y}) do
    # Calculate cross product to check for collinearity
    # (py - p1y) * (p2x - p1x) - (px - p1x) * (p2y - p1y)
    cross_product =
      (py - p1y) * (p2x - p1x) - (px - p1x) * (p2y - p1y)

    # Check if collinear (cross product is near zero)
    collinear = abs(cross_product) < @epsilon

    if collinear do
      # Check if {px, py} is within the bounding box of {p1x, p1y} and {p2x, p2y}
      x_in_range =
        px >= min(p1x, p2x) - @epsilon && px <= max(p1x, p2x) + @epsilon

      y_in_range =
        py >= min(p1y, p2y) - @epsilon && py <= max(p1y, p2y) + @epsilon

      x_in_range && y_in_range
    else
      false
    end
  end
end
