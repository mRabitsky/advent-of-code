defmodule Day12 do
  @input File.stream!("inputs/day12.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(& String.split(&1, "-"))
         |> Enum.to_list

  defp traverse(g, v, seen, twice?) do
    if v === "end" do
      1
    else
      :digraph.out_neighbours(g, v)
      |> Enum.filter(&(:binary.first(&1) <= ?Z || twice? || !(&1 in seen)))
      |> Enum.map(&(traverse(g, &1, [&1 | seen], (if twice? && &1 in seen && :binary.first(&1) > ?Z, do: false, else: twice?))))
      |> Enum.sum
    end
  end

  defp bfs(twice?) do
    dg = :digraph.new()
    for v <- List.flatten(@input), do: :digraph.add_vertex(dg, v)
    for [v, u] <- @input, do: {:digraph.add_edge(dg, v, u), :digraph.add_edge(dg, u, v)}
    :digraph.del_edges(dg, :digraph.in_edges(dg, "start"))
    traverse(dg, "start", ["start"], twice?)
  end

  def p1, do: bfs(false)

  def p2, do: bfs(true)
end