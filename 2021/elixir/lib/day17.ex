defmodule Day17 do
  @input File.stream!("inputs/day17.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(fn
           str -> Regex.run(~r/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/i, str, capture: :all_but_first)
                    |> Enum.map(&String.to_integer/1)
         end)
         |> Enum.to_list
         |> List.first

  defp is_triangle_number?(n), do: (8 * abs(n) + 1) == (floor(:math.sqrt(8 * abs(n) + 1)) ** 2)

  defp simulate(x, y, vx, vy, rx, ry) do
    if x > rx.last || y < ry.first do
      false
    else
      if Enum.member?(rx, x) && Enum.member?(ry, y), do: true, else: simulate(x + vx, y + vy, max(vx - 1, 0), vy - 1, rx, ry)
    end
  end

  def p1 do
    [x_min, x_max, y_min, _] = @input
    if Enum.any?(x_min..x_max, &is_triangle_number?/1) do
      (y_min * (y_min + 1))/2 |> trunc
    else
      "do the math"
    end
  end
  def p2 do
    [x_min, x_max, y_min, y_max] = @input
    z = if is_triangle_number?(x_min), do: x_min, else: trunc((:math.sqrt(8 * abs(x_min) + 1) - 1) / 2)

    for vix <- z..(x_max + 1), viy <- y_min..-y_min, reduce: 0 do
      acc -> if simulate(0, 0, vix, viy, x_min..x_max, y_min..y_max), do: acc + 1, else: acc
    end
  end
end
