defmodule Day2 do
  @input File.stream!("inputs/day2.txt")
         |> Stream.map(&String.trim/1)
         |> Enum.to_list
         |> Enum.map(&(String.split(&1, " ")))
         |> Enum.map(fn [a, b] -> [a, String.to_integer(b)] end)

  defp f(n), do: Enum.reduce(@input, {0, 0, 0}, fn
    (["forward", x], {h, d, a}) -> {h + x, d + a * x, a}
    (["down", y], {h, d, a}) -> {h, d, a + y}
    (["up", y], {h, d, a}) -> {h, d, a - y}
  end) |> Tuple.delete_at(n) |> Tuple.product

  def p1(), do: f(1)
  def p2(), do: f(2)
end