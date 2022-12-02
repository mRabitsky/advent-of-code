defmodule Day16 do
  @input File.stream!("inputs/day16.txt")
         |> Stream.map(&String.trim/1)
         |> Enum.to_list
         |> List.first
         |> String.graphemes

  defp decode_integer(i), do: pad_leading_zeros(i) |> :binary.decode_unsigned

  defp evaluate_packets(ps) when is_list(ps) do
    {_, type, {value, _}} = hd ps
    if type === 4 do
      value
    else
      operands = parse_operands(hd tl ps)
      operator = case type do
        0 -> &Enum.sum/1
        1 -> &Enum.product/1
        2 -> &Enum.min/1
        3 -> &Enum.max/1
        5 -> fn [a, b] -> if a > b, do: 1, else: 0 end
        6 -> fn [a, b] -> if a < b, do: 1, else: 0 end
        7 -> fn [a, b] -> if a === b, do: 1, else: 0 end
      end
      operator.(operands)
    end
  end
  defp evaluate_packets({_, _, {value, _}}), do: value

  defp get_bitstring(hex), do: Enum.reduce(hex, <<>>, fn
    char, acc -> <<acc::bits, (<<(Integer.parse(char, 16) |> elem(0))::4>>)>>
  end)

  defp pad_leading_zeros(bs) when is_binary(bs), do: bs
  defp pad_leading_zeros(bs) when is_bitstring(bs) do
    pad_length = 8 - rem(bit_size(bs), 8)
    <<0::size(pad_length), bs::bitstring>>
  end

  defp parse(hex), do: hex |> get_bitstring |> parse_packet

  defp parse_literal(bs) do
    {literal, rest} = parse_literal_groups(bs)
    {decode_integer(literal), rest}
  end

  defp parse_literal_groups(bs) do
    case bs do
      <<prefix::1, value::bits-4, rest::bits>> ->
        case prefix do
          0 -> {value, rest}
          1 ->
            {literal_groups, rest} = parse_literal_groups(rest)
            {<<value::bits-4, literal_groups::bits>>, rest}
        end
      <<_::1, value::bits-4>> -> {value, <<>>}
    end
  end

  defp parse_operands([]), do: []
  defp parse_operands(ps) do
    {_, type, {value, _}} = hd ps
    if type === 4 do
      [value] ++ parse_operands(tl ps)
    else
      [evaluate_packets(ps)] ++ parse_operands(tl tl ps)
    end
  end

  defp parse_packet(bs) do
    <<version::3, type::3, rest::bits>> = bs
    case type do
      4 -> [{version, type, parse_literal(rest)}]
      _ -> case rest do
          <<0::1, length::15, rest::bits>> -> [{version, type, {length, rest}}, parse_subpackets(rest, length: length)]
          <<1::1, length::11, rest::bits>> -> [{version, type, {length, rest}}, parse_subpackets(rest, count: length)]
        end
    end
  end

  defp parse_subpackets(bs, ls \\ [], _)
  defp parse_subpackets(bs, ls, length: n) do
    if n <= 6 do
      if n < 0, do: List.delete_at(ls, -1), else: ls
    else
      packet = parse_packet(bs)
      {_, _, {_, rest}} = packet |> List.flatten |> List.last
      parse_subpackets(rest, ls ++ packet, length: n - (bit_size(bs) - bit_size(rest)))
    end
  end
  defp parse_subpackets(bs, ls, count: n) do
    if n > 0 do
      packet = parse_packet(bs)
      {_, _, {_, rest}} = packet |> List.flatten |> List.last
      parse_subpackets(rest, ls ++ packet, count: n - 1)
    else
      ls
    end
  end

  defp _print_bitstring(bs) do
    IO.inspect(for <<b::1 <- bs>>, do: b)
    bs
  end

  def p1(hex \\ @input), do: parse(hex) |> List.flatten |> Enum.map(&elem(&1, 0)) |> Enum.sum
  def p2(hex \\ @input), do: parse(hex) |> evaluate_packets
end