defmodule Day2 do
  import Utils

  defp parse(str), do: Regex.scan(~r/(\d+) (red|green|blue)/, str, capture: :all_but_first)
                       |> Enum.map(fn [n, c] -> %{c => String.to_integer(n)} end)
                       |> Enum.reduce(
                            %{"red" => 0, "green" => 0, "blue" => 0},  # in case some colours are never seen
                            &(Map.merge(&1, &2, fn _, a, b -> max(a, b) end))
                          )

  def p1(input), do: as_lines(input)
                     |> Enum.map(&parse/1)
                     |> Stream.with_index(1)
                     |> Stream.filter(fn {%{"red" => r, "green" => g, "blue" => b}, _} -> r <= 12 and g <= 13 and b <= 14 end)
                     |> Stream.map(fn {_, i} -> i end)
                     |> Enum.sum

  def p2(input), do: as_lines(input)
                     |> Enum.map(&parse/1)
                     |> Enum.map(&(Map.values(&1) |> Enum.product))
                     |> Enum.sum
end