defmodule Day5 do
  @input File.stream!("inputs/day5.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(fn str -> Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/i, str, capture: :all_but_first)
                                 |> Enum.map(&String.to_integer/1) end)
         |> Enum.to_list

  defp process(arr), do: Enum.flat_map(arr, fn
                           [a, b, c, d] when a === c -> Enum.map(b..d, &({a, &1}))
                           [a, b, c, d] when b === d -> Enum.map(a..c, &({&1, b}))
                           [a, b, c, d] -> Enum.zip(a..c, b..d)
                         end)
                         |> Enum.frequencies
                         |> Map.values
                         |> Enum.count(&(&1 > 1))

  def p1(), do: process Enum.filter(@input, fn [a, b, c, d] -> a === c || b === d end)
  def p2(), do: process @input
end