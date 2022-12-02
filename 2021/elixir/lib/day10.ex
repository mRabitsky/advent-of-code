defmodule Day10 do
  @input File.stream!("inputs/day10.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.graphemes/1)
         |> Enum.to_list
  @lookup %{
    ")" => "(",
    "]" => "[",
    "}" => "{",
    ">" => "<",
  }
  @score %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4,
  }

  defp parse(), do: Enum.map(@input, &(Enum.reduce_while(&1, [], fn
    b, [f | rest] when is_map_key(@lookup, b) -> if f === @lookup[b], do: {:cont, rest}, else: {:halt, @score[b]}
    b, acc -> {:cont, [b | acc]}
  end)))

  def p1(), do: parse()
                |> Enum.filter(&Kernel.is_number/1)  # invalid
                |> Enum.sum

  def p2(), do: parse()
                |> Enum.filter(&Kernel.is_list/1)  # valid but incomplete
                |> Enum.map(&(Enum.reduce(&1, 0, fn b, acc -> acc * 5 + @score[b] end)))
                |> Enum.sort
                |> (&(Enum.at(&1, div(length(&1), 2)))).()
end