defmodule Day7 do
  @input File.stream!("inputs/day7.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(fn str -> String.split(str, ",") |> Enum.map(&String.to_integer/1) end)
         |> Enum.to_list
         |> List.first
         |> Enum.sort

  def p1() do
    median = Enum.at(@input, div(length(@input), 2))
    @input |> Enum.map(&(abs(&1 - median))) |> Enum.sum
  end
  def p2() do
    mean = Enum.sum(@input) / length(@input)
    min(
      Enum.map(@input, &(abs(&1 - floor(mean)))) |> Enum.map(&(&1 * (&1 + 1) / 2)) |> Enum.sum,
      Enum.map(@input, &(abs(&1 - ceil(mean)))) |> Enum.map(&(&1 * (&1 + 1) / 2)) |> Enum.sum
    ) |> round
  end
end