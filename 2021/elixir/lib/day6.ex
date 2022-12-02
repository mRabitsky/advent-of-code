defmodule Day6 do
  @input File.stream!("inputs/day6.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(fn str -> String.split(str, ",") |> Enum.map(&String.to_integer/1) end)
         |> Enum.to_list
         |> List.first

  def p1(), do: Enum.reduce(1..80, @input, fn _, feesh ->
    Enum.flat_map(feesh, fn
      0 -> [6, 8]
      n -> [n - 1]
    end)
  end) |> Enum.count

  def p2() do
    Enum.reduce(
      1..256,
      Enum.reduce(0..8, Enum.frequencies(@input), &(Map.put_new(&2, &1, 0)))
        |> Enum.to_list
        |> List.keysort(0)
        |> Keyword.values,
      fn _, feesh ->
        {zeroes, ls} = List.pop_at(feesh, 0)
        ls |> List.update_at(6, &(&1 + zeroes)) |> List.insert_at(-1, zeroes)
      end
    ) |> Enum.sum
  end
end