defmodule Nilsimsa.Hamming do
  @moduledoc """
  A module for generating a hamming distance optimisation table.

  This lookup table can be used to efficiently find the Hamming weight of an
  8-bit integer without needing to manually count the set bits every time.
  The integer can be directly used as an index into the lookup table to get its
  Hamming weight.

  This table can also be used to find the Hamming distance between two 8-bit
  integers. The Hamming distance between two integers is the number of positions
  at which the corresponding bits are different. It can be found by performing a
  bitwise XOR operation between the two integers and then looking up the Hamming
  weight of the result in the table.
  """

  import Bitwise

  @doc """
  Generate a hamming distance optimisation table.

      iex> table = Hamming.generate()
      iex> Enum.at(table, bxor(9, 14))
      3

  """
  def generate,
    do: for(x <- 0..255, do: hamming_weight(x))

  # Private

  defp hamming_weight(x) do
    Enum.reduce_while(Stream.cycle(0..1), {0, x}, fn
      _, {count, x} when x > 0 ->
        {:cont, {count + band(x, 1), bsr(x, 1)}}

      _, {count, _} ->
        {:halt, count}
    end)
  end
end
