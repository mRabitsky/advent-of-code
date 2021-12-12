defmodule Day12 do
  @input File.stream!("inputs/day12.txt")
         |> Stream.map(&String.trim/1) |> Stream.map(& String.split(&1, "-"))
         |> Enum.to_list

  defp make_graph do
    dg = :digraph.new()
    for v <- List.flatten(@input), do: :digraph.add_vertex(dg, v)
    for [v, u] <- @input, do: {:digraph.add_edge(dg, v, u), :digraph.add_edge(dg, u, v)}
    dg
  end

  defp traverse(g, v, seen, special) do
    if v === "end" do
      [seen]
    else
      :digraph.out_neighbours(g, v)
      |> Enum.filter(&(:binary.first(&1) <= ?Z || &1 === special || !(&1 in seen)))
      |> Enum.flat_map(&(traverse(g, &1, [&1 | seen], (if &1 === special && &1 in seen, do: nil, else: special))))
    end
  end

  def p1 do
    g = make_graph()
    traverse(g, "start", ["start"], "") |> Enum.count
  end

  def p2 do
    g = make_graph()
    Enum.reject(:digraph.vertices(g) -- ["start", "end"], &(:binary.first(&1) <= ?Z))
    |> Enum.flat_map(&(traverse(g, "start", ["start"], &1)))
    |> Enum.uniq
    |> Enum.count
  end
end