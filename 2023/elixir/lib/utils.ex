defmodule Utils do
  @type coord :: {non_neg_integer, non_neg_integer}

  def as_lines(str), do: String.split(str, ["\n", "\r", "\r\n"], trim: true)
  def as_paragraphs(str), do: String.split(str, ["\n\n", "\r\r", "\r\n\r\n"], trim: true)
  def as_words(str), do: String.split(str)
end