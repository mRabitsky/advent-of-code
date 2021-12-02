defmodule Day7 do
  use Bitwise, only_operaters: true

  @input File.stream!("inputs/day7.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&(String.split(&1, " -> ")))
         |> Enum.to_list

  defp parse(str) do
    cond do
      result = Regex.run(~r/(.+) AND (.+)/, str, capture: :all_but_first) -> {result, &Bitwise.&&&/2}
      result = Regex.run(~r/(.+) OR (.+)/, str, capture: :all_but_first) -> {result, &Bitwise.|||/2}
      result = Regex.run(~r/(.+) LSHIFT (.+)/, str, capture: :all_but_first) -> {result, &Bitwise.<<</2}
      result = Regex.run(~r/(.+) RSHIFT (.+)/, str, capture: :all_but_first) -> {result, &Bitwise.>>>/2}
      result = Regex.run(~r/NOT (.+)/, str, capture: :all_but_first) -> {result, &Bitwise.~~~/1}
      true -> {[str], &Function.identity/1}
    end
  end

  def p1() do
    tree = :digraph.new
    instructions = Enum.reduce(@input, %{}, fn ([v, k], acc) -> Map.put(acc, k, parse(v)) end)
    Enum.each(instructions, fn ({k, {v, _}}) ->
      k = :digraph.add_vertex(tree, k)
      for vv <- v, Integer.parse(vv) == :error, do: :digraph.add_edge(tree, :digraph.add_vertex(tree, vv), k)
    end)
    Enum.reduce(:digraph_utils.topsort(tree), %{}, fn (v, acc) ->
      {operands, func} = instructions[v]
      operands = Enum.map(operands, fn (op) ->
        case Integer.parse(op) do
          {i, _} -> i
          :error -> acc[op]
        end
      end)
      Map.put_new(acc, v, apply(func, operands))
    end)
  end

  def p2(), do: nil
end