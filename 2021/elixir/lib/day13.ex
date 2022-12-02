defmodule Day13 do
  @input File.stream!("inputs/day13.txt")
         |> Stream.map(&String.trim/1)
         |> Enum.split(959)
         |> (fn {dots, folds} -> {
              Enum.map(dots, fn d -> String.split(d, ",") |> Enum.map(&String.to_integer/1) end),
              Enum.map((tl folds), &(Regex.run(~r/fold along (x|y)=(\d+)/, &1, capture: :all_but_first)))
              |> Enum.map(fn [dim, n] -> {dim, String.to_integer(n)} end)
            } end).()

  defp fold_paper(paper, folds) do
    Enum.reduce(folds, paper, fn
      {"x", n}, acc -> Enum.map(acc, fn
        [x, y] when x > n -> [x - 2 * (x - n), y]
        coords -> coords
      end) |> Enum.uniq
      {"y", n}, acc -> Enum.map(acc, fn
        [x, y] when y > n -> [x, y - 2 * (y - n)]
        coords -> coords
      end) |> Enum.uniq
    end)
  end


  def p1, do: fold_paper(elem(@input, 0), [hd elem(@input, 1)]) |> Enum.count

  def p2 do
    dots = fold_paper(elem(@input, 0), elem(@input, 1))
    width = Enum.map(dots, &List.first/1) |> Enum.max
    height = Enum.map(dots, &List.last/1) |> Enum.max
    for y <- 0..height, x <- 0..width do
      if [x, y] in dots, do: "█", else: " "
    end |> Enum.chunk_every(width + 1) |> Enum.map(& Enum.join(&1, " ")) |> Enum.each(&IO.puts/1)
  end
end