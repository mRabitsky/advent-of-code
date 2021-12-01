defmodule Day5 do
  @input File.stream!("inputs/day5.txt") |> Stream.map(&String.trim/1) |> Enum.to_list

  defp nice?(str) do
    !String.contains?(str, ["ab", "cd", "pq", "xy"])
    && (Enum.zip(String.graphemes(str), String.graphemes(str) |> Enum.drop(1)) |> Enum.any?(fn ({l, r}) -> l === r end))
    && String.length(str) - String.length(String.replace(str, ~r/[aeiou]/i, "")) >= 3
  end

  defp nice2?(str), do: String.match?(str, ~r/(..).*\1/i) && String.match?(str, ~r/(.).\1/i)

  def p1(), do: Enum.count(@input, &nice?/1)

  def p2(), do: Enum.count(@input, &nice2?/1)
end