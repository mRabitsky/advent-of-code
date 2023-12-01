defmodule Mix.Tasks.Day do
  @moduledoc "Execute a day as a mix task: mix day n p"
  use Mix.Task

  def run([day, part]) do
    IO.puts(apply(String.to_atom("Elixir.Day#{day}"), String.to_atom("p#{part}"), [File.read!("inputs/day#{day}.txt")]))
  end
end