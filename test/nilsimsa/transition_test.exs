defmodule Nilsimsa.TransitionTest do
  use ExUnit.Case, async: true

  import Bitwise

  alias Nilsimsa.Transition

  doctest Nilsimsa.Transition

  test "should xor to 0" do
    [v | rest] = Transition.generate(53)

    v = Enum.reduce(rest, v, &bxor(&2, &1))

    assert v == 0
  end
end
