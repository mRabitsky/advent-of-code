defmodule Day8 do
  @input File.stream!("inputs/day8.txt")
         |> Stream.map(&String.trim/1)
         |> Enum.to_list

  def p1() do
    (@input |> Enum.map(&Kernel.byte_size/1) |> Enum.sum) -
    (@input |> Enum.map(&Code.eval_string/1) |> Enum.map(fn {str, _} -> byte_size(str) end) |> Enum.sum)
  end
  def p2() do
    (@input |> Enum.map(&(Regex.replace(~r/([\\"])/, &1, ~S(\\\1)))) |> Enum.map(&Kernel.byte_size/1) |> Enum.map(&(&1 + 2)) |> Enum.sum) -
    (@input |> Enum.map(&Kernel.byte_size/1) |> Enum.sum)
  end
end