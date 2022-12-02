defmodule Day4 do
  @input File.stream!("inputs/day4.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.filter(&(String.length(&1) > 0))
         |> Enum.to_list

  defp transpose(arr), do: arr |> List.zip |> Enum.map(&Tuple.to_list/1)
  defp check(ns, {a, b}), do: Enum.any?(a, fn l -> Enum.all?(l, &(&1 in ns)) end) || Enum.any?(b, fn l -> Enum.all?(l, &(&1 in ns)) end)

  def p1() do
    [numbers | boards] = @input
    numbers = String.split(numbers, ",")
    boards = Enum.map(boards, &String.split/1) |> Enum.chunk_every(5) |> Enum.map(&({&1, transpose(&1)}))
    i = (Enum.take_while(0..length(numbers), fn n -> !Enum.any?(boards, &(check(Enum.slice(numbers, 0..n), &1))) end)
        |> List.last) + 1
    called = Enum.slice(numbers, 0..i)
    winner = Enum.find(boards, &(check(called, &1)))
    (Enum.at(numbers, i) |> String.to_integer)
    * (List.flatten(elem(winner, 0)) |> Enum.reject(&(&1 in called)) |> Enum.map(&String.to_integer/1) |> Enum.sum)
  end

  def p2() do
    [numbers | boards] = @input
    numbers = String.split(numbers, ",")
    boards = Enum.map(boards, &String.split/1) |> Enum.chunk_every(5) |> Enum.map(&({&1, transpose(&1)}))
    {i, [winner]} = Enum.reduce_while(0..length(numbers), {-1, boards}, fn
      n, {_, acc} ->
        remaining = Enum.reject(acc, &(check(Enum.slice(numbers, 0..n), &1)))
        if length(remaining) > 0, do: {:cont, {n, remaining}}, else: {:halt, {n, acc}}
    end)
    called = Enum.slice(numbers, 0..i)
    (Enum.at(numbers, i) |> String.to_integer)
    * (List.flatten(elem(winner, 0)) |> Enum.reject(&(&1 in called)) |> Enum.map(&String.to_integer/1) |> Enum.sum)
  end
end