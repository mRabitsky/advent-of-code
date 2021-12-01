defmodule Day6 do
  @input File.stream!("inputs/day6.txt") |> Stream.map(&String.trim/1) |> Enum.to_list
  @regex ~r/(\d+),(\d+) through (\d+),(\d+)/i

  defp update_all([a, b, c, d], state, func, default) do
    for x <- a..c, y <- b..d, reduce: state do
      acc -> Map.update(acc, {x, y}, func.(default), func)
    end
  end

  defp parse([], state, _, _, _, _), do: state
  defp parse([instr | rest], state, turn_on, turn_off, toggle, default_value) do
    func = cond do
      String.starts_with?(instr, "turn on") -> turn_on
      String.starts_with?(instr, "turn off") ->  turn_off
      String.starts_with?(instr, "toggle") -> toggle
    end
    parse(
      rest,
      update_all(
        Regex.run(@regex, instr, capture: :all_but_first) |> Enum.map(&(Integer.parse(&1) |> elem(0))),
        state,
        func,
        default_value
      ),
      turn_on,
      turn_off,
      toggle,
      default_value
    )
  end

  def p1(), do: Enum.count(Map.values(parse(
    @input,
    %{},
    fn _ -> true end,
    fn _ -> false end,
    &Kernel.!/1,
    false
  )), &Function.identity/1)

  def p2(), do: Enum.sum Map.values parse(
    @input,
    %{},
    &(&1 + 1),
    &(max(&1 - 1, 0)),
    &(&1 + 2),
    0
  )
end
