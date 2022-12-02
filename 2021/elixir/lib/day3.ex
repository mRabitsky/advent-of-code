defmodule Day3 do
  @input File.stream!("inputs/day3.txt")
         |> Stream.map(&String.trim/1)
         |> Enum.to_list
         |> Enum.map(&String.graphemes/1)

  defp most_frequent(arr, f), do: arr |> Enum.frequencies |> Map.to_list |> List.keysort(1) |> f.() |> elem(0)

  defp filter(arr, i, f), do: Enum.filter(arr, fn x -> Enum.at(x, i) === most_frequent(Enum.map(arr, &(Enum.at(&1, i))), f) end)

  def p1(), do: Enum.zip(@input)
                |> Enum.map(&(&1 |> Tuple.to_list |> Enum.frequencies |> Map.to_list |> List.keysort(1)))
                |> Enum.reduce({"", ""}, fn [{sm, _}, {lg, _}], {l, r} -> {l <> sm, r <> lg} end)
                |> Tuple.to_list
                |> Enum.map(&(String.to_integer(&1, 2)))
                |> Enum.product

  def p2() do
    Enum.reduce(0..12, [@input, @input], fn i, [o2, co2] -> [filter(o2, i, &List.last/1), filter(co2, i, &List.first/1)] end)
    |> Enum.map(&(List.to_string(&1) |> String.to_integer(2)))
    |> Enum.product
  end
end