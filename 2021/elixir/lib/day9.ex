defmodule Day9 do
  @input File.stream!("inputs/day9.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&(String.graphemes(&1) |> Enum.map(fn str -> String.to_integer(str) end)))
         |> Enum.to_list
  @mapped (for i <- 0..length(@input) - 1, j <- 0..length(List.first(@input)) - 1, reduce: %{} do
             acc -> Map.put(acc, {i, j}, Enum.at(@input, i) |> Enum.at(j))
           end)

  defp neighbours({i, j}), do: [{i - 1, j}, {i + 1, j}, {i, j - 1}, {i, j + 1}]

  defp is_low_point?({i, j}), do: Enum.all?(neighbours({i, j}), &(@mapped[{i, j}] < Map.get(@mapped, &1, 10)))

  def p1(), do: Enum.filter(Map.keys(@mapped), &is_low_point?/1) |> Enum.map(&(@mapped[&1] + 1)) |> Enum.sum

  def p2() do
    dg = :digraph.new()
    vertices = Enum.filter(Map.keys(@mapped), &(@mapped[&1] < 9))
               |> Enum.reduce(%{}, &(Map.put(&2, &1, :digraph.add_vertex(dg, &1))))
    Enum.each(Map.keys(vertices), fn
      {i, j} -> neighbours({i, j})
                |> Enum.filter(&(Map.has_key?(vertices, &1)))
                |> Enum.map(&(vertices[&1]))
                |> Enum.each(&(:digraph.add_edge(dg, vertices[{i, j}], &1)))
    end)
    Enum.map(:digraph_utils.components(dg), &Kernel.length/1) |> Enum.sort() |> Enum.slice(-3, 3) |> Enum.product
  end
end