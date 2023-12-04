defmodule Day1 do
  import Utils

  @spec parse_str(binary) :: [1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9]
  defp parse_str(""), do: []
  defp parse_str(str) do
    cond do
      String.starts_with?(str, ["one", "1"]) -> [1]
      String.starts_with?(str, ["two", "2"]) -> [2]
      String.starts_with?(str, ["three", "3"]) -> [3]
      String.starts_with?(str, ["four", "4"]) -> [4]
      String.starts_with?(str, ["five", "5"]) -> [5]
      String.starts_with?(str, ["six", "6"]) -> [6]
      String.starts_with?(str, ["seven", "7"]) -> [7]
      String.starts_with?(str, ["eight", "8"]) -> [8]
      String.starts_with?(str, ["nine", "9"]) -> [9]
      true -> []
    end ++ parse_str(String.slice(str, 1..-1))
  end

  @spec p1(binary) :: non_neg_integer
  def p1(input), do: as_lines(input)
                     |> Enum.map(fn str -> Regex.scan(~r/(\d)/, str) |> List.flatten() |> Enum.map(&String.to_integer/1) end)
                     |> Enum.reduce(0, &(&2 + List.first(&1) * 10 + List.last(&1)))

  @spec p2(binary) :: non_neg_integer
  def p2(input), do: as_lines(input)
                     |> Enum.map(&parse_str/1)
                     |> Enum.reduce(0, &(&2 + List.first(&1) * 10 + List.last(&1)))
end
