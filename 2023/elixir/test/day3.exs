defmodule TestDay3 do
  use ExUnit.Case
  doctest Day3

  test "examples" do
    example = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
    assert Day3.p1(example) == 4361
    assert Day3.p2(example) == 467835
  end
end
