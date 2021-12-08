defmodule Day8 do
  @input File.stream!("inputs/day8.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&(String.split(&1, " | ") |> Enum.map(fn str -> String.split(str) end)))
         |> Enum.to_list

  def p1(), do: Enum.flat_map(@input, &List.last/1) |> Enum.count(&(String.length(&1) in [2, 3, 4, 7]))

  def p2() do
    Enum.map(@input, fn [ns, ds] ->
      ns = Enum.map(ns, &(String.graphemes(&1) |> MapSet.new))

      one = Enum.find(ns, &(MapSet.size(&1) === 2))
      seven = Enum.find(ns, &(MapSet.size(&1) === 3))
      four = Enum.find(ns, &(MapSet.size(&1) === 4))
      eight = Enum.find(ns, &(MapSet.size(&1) === 7))
      nine = Enum.find(ns, &(MapSet.size(&1) === 6 && MapSet.subset?(MapSet.union(four, seven), &1)))
      three = Enum.find(ns, &(MapSet.size(&1) === 5 && MapSet.subset?(&1, nine) && MapSet.size(MapSet.intersection(&1, one)) === 2))
      five = Enum.find(ns, &(MapSet.size(&1) === 5 && MapSet.subset?(&1, nine) && MapSet.size(MapSet.intersection(&1, one)) === 1))
      two = Enum.find(ns, &(MapSet.size(&1) === 5 && !(MapSet.equal?(&1, three) || MapSet.equal?(&1, five))))
      six = Enum.find(ns, &(MapSet.size(&1) === 6 && !MapSet.equal?(&1, nine) && MapSet.subset?(five, &1)))
      zero = Enum.find(ns, &(MapSet.size(&1) === 6 && !(MapSet.equal?(&1, six) || MapSet.equal?(&1, nine))))

      mapping = %{
        zero => 0,
        one => 1,
        two => 2,
        three => 3,
        four => 4,
        five => 5,
        six => 6,
        seven => 7,
        eight => 8,
        nine => 9,
      }

      Enum.map(ds, &(mapping[String.graphemes(&1) |> MapSet.new])) |> Enum.join |> String.to_integer
    end) |> Enum.sum
  end
end