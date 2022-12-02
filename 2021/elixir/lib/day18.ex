defmodule Day18 do
  @input File.stream!("inputs/day18.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&Code.eval_string/1)
         |> Stream.map(&elem(&1, 0))
         |> Enum.to_list

  defp add(l, r), do: Enum.map(l ++ r, fn {n, d} -> {n, d + 1} end)

  defp magnitude(n) when is_integer(n), do: n
  defp magnitude([l, r]), do: 3 * magnitude(l) + 2 * magnitude(r)

  defp parse(ls, depth \\ 0)
  defp parse([], _), do: []
  defp parse([l, r], depth), do: parse(l, depth + 1) ++ parse(r, depth + 1)
  defp parse(n, depth), do: [{n, depth}]

  defp permute_k2(ls) do
    for x <- ls, y <- (ls -- [x]), do: [x, y]
  end

  defp reconstruct([]), do: []
  defp reconstruct([{n, _}]), do: n
  defp reconstruct(ls) do
    {before, [join | rest]} = Enum.chunk_by(ls, &elem(&1, 1)) |> Enum.split_while(&(length(&1) < 2))
    {[{n, d}, {m, d}], extra} = Enum.split(join, 2)
    List.flatten([before, {[n, m], d - 1}, extra, rest]) |> reconstruct
  end

  defp reduce(ls) do
    exploder = Enum.find_index(ls, fn {_, d} -> d >= 5 end)
    if !is_nil(exploder) do
      {preceding, following} = Enum.split(ls, exploder)
      {[{l, d}, {r, d}], following} = Enum.split(following, 2)

      {preceding, prev} = Enum.split(preceding, -1)
      {next, following} = Enum.split(following, 1)

      reduce(
        preceding ++
        Enum.map(prev, fn {n, depth} -> {n + l, depth} end) ++
        [{0, d - 1}] ++
        Enum.map(next, fn {n, depth} -> {n + r, depth} end) ++
        following
      )
    else
      {pre_split, post_split} = Enum.split_while(ls, fn {n, _} -> n < 10 end)
      if length(post_split) > 0 do
        {[{n, d}], rest} = Enum.split(post_split, 1)

        reduce(pre_split ++ [{floor(n / 2), d + 1}, {ceil(n / 2), d + 1}] ++ rest)
      else
        ls
      end
    end
  end

  def p1, do: Enum.reduce(tl(@input), (@input |> hd |> parse), &(add(&2, parse(&1)) |> reduce))
              |> reconstruct
              |> magnitude
  def p2, do: permute_k2(@input)
              |> Enum.map(fn [l, r] -> add(parse(l), parse(r)) |> reduce |> reconstruct |> magnitude end)
              |> Enum.max
end
