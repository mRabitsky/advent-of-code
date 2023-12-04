defmodule Day3 do
  import Utils

  defmodule EngineSchematic do
    defstruct parts: MapSet.new(), symbols: %{}

    @type t :: %EngineSchematic{parts: MapSet.t({binary, Utils.coord}), symbols: %{optional(Utils.coord) => binary}}

    @spec merge(EngineSchematic.t, EngineSchematic.t) :: EngineSchematic.t
    def merge(a, b), do: %EngineSchematic{
      parts: MapSet.union(a.parts, b.parts),
      symbols: Map.merge(a.symbols, b.symbols),
    }
  end

  @spec neighbours(non_neg_integer, non_neg_integer, non_neg_integer) :: nonempty_list(Utils.coord)
  defp neighbours(r, c, l), do: (for i <- (r - 1)..(r + 1),
                                     j <- (c - 1)..(c + l),
                                     i != r or j not in c..(c + l - 1),
                                     do: {i, j})

  @spec parse_line(binary, non_neg_integer) :: EngineSchematic.t
  defp parse_line(str, ln), do: %EngineSchematic{
    parts: (for [{i, n}] <- Regex.scan(~r/\d+/, str, return: :index),
                into: MapSet.new(),
                do: {String.slice(str, i, n), {ln, i}}),
    symbols: (for [{i, n}] <- Regex.scan(~r/[^\d\.]/, str, return: :index),
                  into: %{},
                  do: {{ln, i}, String.slice(str, i, n)}),
  }

  @spec parse_schematic(binary) :: EngineSchematic.t
  defp parse_schematic(schematic), do: as_lines(schematic)
                                       |> Stream.with_index
                                       |> Enum.reduce(
                                            %EngineSchematic{},
                                            fn {str, ln}, acc -> parse_line(str, ln) |> EngineSchematic.merge(acc) end
                                          )
  @spec p1(binary) :: non_neg_integer
  def p1(input) do
    schematic = parse_schematic(input)
    Enum.filter(
      schematic.parts,
      fn {n, {r, c}} -> Enum.any?(neighbours(r, c, String.length(n)), &Map.has_key?(schematic.symbols, &1)) end
    )
    |> Enum.map(fn {n, _} -> String.to_integer(n) end)
    |> Enum.sum
  end

  @spec p2(binary) :: non_neg_integer
  def p2(input) do
    schematic = parse_schematic(input)
    Enum.reduce(
      schematic.parts,
      %{},
      fn {n, {r, c}}, acc -> Map.merge(
                               acc,
                               (for i <- neighbours(r, c, String.length(n)),
                                    Map.get(schematic.symbols, i) == "*",
                                    into: %{},
                                    do: {i, [String.to_integer(n)]}),
                               fn _, a, b -> a ++ b end
                             ) end
    )
    |> Enum.filter(&(length(elem(&1, 1)) == 2))
    |> Enum.map(&Enum.product(elem(&1, 1)))
    |> Enum.sum
  end
end