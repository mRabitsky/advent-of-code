defmodule Day14 do
  @input File.stream!("inputs/day14.txt")
         |> Stream.map(&String.trim/1)
         |> Enum.split(1)
         |> (fn {template, rules} -> {
           List.first(template) |> String.graphemes,
           Enum.map((tl rules), &(Regex.run(~r/(.)(.) -> (.)/, &1, capture: :all_but_first)))
           |> Enum.reduce(%{}, fn [a, b, c], acc -> Map.put(acc, {a, b}, c) end)
         } end).()

  defp pair_insert(histogram, rules, last_char, steps) do
    if steps <= 0 do
      freqs = Enum.reduce(histogram, %{}, fn {{a, _}, v}, acc -> Map.update(acc, a, v, & &1 + v) end)
              |> Map.update!(last_char, & &1 + 1)
              |> Map.values
      Enum.max(freqs) - Enum.min(freqs)
    else
      Enum.reduce(histogram, %{}, fn
        {{a, b}, v}, acc -> acc
                            |> Map.update({a, rules[{a, b}]}, v, & &1 + v)
                            |> Map.update({rules[{a, b}], b}, v, & &1 + v)
      end) |> pair_insert(rules, last_char, steps - 1)
    end
  end

  defp polymerize(n) do
    {ls, rules} = @input
    pair_insert(Enum.zip(ls, tl ls) |> Enum.frequencies, rules, List.last(ls), n)
  end

  def p1, do: polymerize(10)
  def p2, do: polymerize(40)
end