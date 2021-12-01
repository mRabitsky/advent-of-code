defmodule Day4 do
  @secret_key "ckczppom"

  defp hash(i, n), do: :crypto.hash(:md5, "#{@secret_key}#{i}")
                       |> Base.encode16()
                       |> String.starts_with?(String.duplicate("0", n))
                       |> Kernel.!

  defp get(n), do: (Stream.iterate(0, &(&1 + 1))
                    |> Stream.take_while(& hash &1, n)
                    |> Stream.take(-1)
                    |> Enum.to_list
                    |> hd) + 1

  def p1(), do: get(5)

  def p2(), do: get(6)
end
