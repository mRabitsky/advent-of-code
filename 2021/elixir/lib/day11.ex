defmodule Day11 do
  @input File.stream!("inputs/day11.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&(String.graphemes(&1) |> Enum.map(fn str -> String.to_integer(str) end)))
         |> Enum.to_list
  @mapped (for i <- 0..9, j <- 0..9, reduce: %{} do
             acc -> Map.put(acc, {i, j}, Enum.at(@input, i) |> Enum.at(j))
           end)
  @neighbours Enum.flat_map(-1..1, &(Enum.map(-1..1, fn n -> {&1, n} end))) -- [{0, 0}]

  defp flash(grid, flashes) do
    if Map.values(grid) |> Enum.any?(fn {v, flashed} -> v > 9 && !flashed end) do
      {next, new_flashes} = Enum.reduce(grid, {grid, flashes}, fn
        {{x, y}, {v, flashed}}, {acc, flash_acc} ->
          if v > 9 and !flashed do
            {
              Enum.map(@neighbours, fn {a, b} -> {x + a, y + b} end)
              |> Enum.filter(&(Map.has_key?(acc, &1)))
              |> Enum.reduce(acc, fn k, cca -> Map.update!(cca, k, fn {vv, ff} -> {vv + 1, ff} end) end)
              |> Map.put({x, y}, {v, true}),
              flash_acc + 1
            }
          else
            {acc, flash_acc}
          end
      end)
      flash(next, new_flashes)
    else
      {Enum.reduce(grid, grid, fn {k, {v, flashed}}, acc -> Map.put(acc, k, (if flashed, do: 0, else: v)) end), flashes}
    end
  end

  defp octopodes(grid, steps_remaining, flashes, synchro?) do
    cond do
      steps_remaining <= 0 -> flashes
      synchro? && Enum.all?(Map.values(grid), &(&1 === 0)) -> steps_remaining
      true ->
        next = Enum.reduce(grid, grid, fn {k, v}, acc -> Map.put(acc, k, v + 1) end)
        {next, flashes} = Enum.reduce(next, next, fn {k, v}, acc -> Map.put(acc, k, {v, false}) end) |> flash(flashes)
        octopodes(next, steps_remaining - 1, flashes, synchro?)
    end
  end

  def p1() do
    octopodes(@mapped, 100, 0, false)
  end

  def p2() do
    1000 - octopodes(@mapped, 1000, 0, true)
  end
end