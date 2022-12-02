defmodule Day7 do
  @input File.stream!("inputs/day7.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(fn str -> String.split(str, ",") |> Enum.map(&String.to_integer/1) end)
         |> Enum.to_list
         |> List.first
         |> Enum.sort

  defp calcFuelCosts(cs, p, f), do: Enum.map(cs, &(f.(abs(&1 - p)))) |> Enum.sum

  def p1(), do: calcFuelCosts(@input, Enum.at(@input, div(length(@input), 2)), &Function.identity/1)
  def p2() do
    mean = Enum.sum(@input) / length(@input)
    f = &(&1 * (&1 + 1) / 2)
    min(
      calcFuelCosts(@input, floor(mean), f),
      calcFuelCosts(@input, ceil(mean), f)
    ) |> round
  end
end