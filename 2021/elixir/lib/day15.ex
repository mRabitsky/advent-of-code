defmodule Day15 do
  @input File.stream!("inputs/day15.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&(String.graphemes(&1) |> Enum.map(fn str -> String.to_integer(str) end)))
         |> Enum.to_list
  @neighbours [{-1, 0}, {1, 0}, {0, 1}, {0, -1}]

  defp mapped(ls), do: Enum.flat_map(Enum.with_index(ls), fn
    {ns, i} -> Enum.map(Enum.with_index(ns), fn {n, j} -> {{j, i}, n} end)
  end) |> Map.new

  defp edges(map, n), do: Enum.flat_map(map, fn
    {{x, y}, w} -> Enum.map(@neighbours, fn
      {a, b} when (y + b >= 0 and y + b < n and x + a >= 0 and x + a < n) -> {{x + a, y + b}, {x, y}, weight: w}
      _ -> nil
    end) |> Enum.reject(&Kernel.is_nil/1)
  end)

  defp search(input) do
    n = length(input)
    map = mapped(input)
    g = Graph.new(type: :directed) |> Graph.add_vertices(Map.keys(map)) |> Graph.add_edges(edges(map, n))
    Graph.a_star(g, {0, 0}, {n - 1, n - 1}, fn {x, y} -> abs(x - (n - 1)) + abs(y - (n - 1)) end)
      |> tl
      |> Enum.map(&Map.get(map, &1))
      |> Enum.sum
  end

  defp print_grid(grid), do: Enum.map(grid, &Enum.join/1) |> Enum.each(&IO.puts/1)

  def p1, do: search(@input)

  def p2 do
    expanded = Enum.flat_map(0..4, fn i ->
      Enum.map(@input, fn
        row -> Enum.map(row, fn
          n when n + i > 9 -> (n + i) - 9
          n -> n + i
        end)
      end)
    end) |> Enum.map(fn
      row -> Enum.flat_map(0..4, fn
        i -> Enum.map(row, fn
          n when n + i > 9 -> (n + i) - 9
          n -> n + i
        end)
      end)
    end)

    search(expanded)
  end
end