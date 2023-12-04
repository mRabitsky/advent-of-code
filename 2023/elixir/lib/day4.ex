defmodule Day4 do
  import Utils

  @spec p1(binary) :: non_neg_integer
  def p1(input), do: as_lines(input)
                     |> Enum.map(fn str -> String.split(str, [": ", " | "], trim: true)
                                           |> tl
                                           |> Enum.map(&String.split/1)
                                           |> Enum.map(&MapSet.new/1) end)
                     |> Enum.map(fn [w, n] -> floor(2 ** ((MapSet.intersection(w, n) |> MapSet.size) - 1)) end)
                     |> Enum.sum

  @spec p2(binary) :: non_neg_integer
  def p2(input), do: as_lines(input)
                     |> Enum.map(fn str -> String.split(str, [": ", " | "], trim: true)
                                           |> tl
                                           |> Enum.map(&String.split/1)
                                           |> Enum.map(&MapSet.new/1) end)
                     |> Enum.map(fn [w, n] -> MapSet.intersection(w, n) |> MapSet.size end)
                     |> Enum.with_index
                     |> Enum.reduce(
                          (for i <- 0..(length(as_lines(input)) - 1), into: %{}, do: {i, 1}),
                          fn {n, i}, acc -> Enum.reduce(
                                              0..(n - 1)//1,
                                              acc,
                                              fn j, acc -> %{acc | (i + j + 1) => acc[i + j + 1] + acc[i]} end
                                            ) end
                        )
                     |> Map.values
                     |> Enum.sum
end