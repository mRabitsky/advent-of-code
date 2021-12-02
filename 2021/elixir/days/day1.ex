defmodule Day1 do
  @input File.stream!("inputs/day1.txt") |> Stream.map(&String.trim/1) |> Enum.to_list |> Enum.map(&String.to_integer/1)

  defp count(n), do: Enum.zip(@input, Enum.drop(@input, n)) |> Enum.count fn ({a, b}) -> a < b end

  def p1(), do: count 1
  def p2(), do: count 3
end