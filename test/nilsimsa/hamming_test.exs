defmodule Nilsimsa.HammingTest do
  use ExUnit.Case, async: true

  import Bitwise

  alias Nilsimsa.Hamming

  doctest Nilsimsa.Hamming

  test "should calculate hamming distance between two integers" do
    table = Hamming.generate()

    assert Enum.at(table, bxor(9, 14)) == 3
  end
end
