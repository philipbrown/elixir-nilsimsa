defmodule NilsimsaTest do
  use ExUnit.Case

  doctest Nilsimsa

  # Examples taken from:
  # https://github.com/rholder/nilsimsa/blob/110b236de3505e4ee64d485f7499d4ce1cf34cc6/src/test/java/com/github/rholder/nilsimsa/NilsimsaHashTest.java

  @a k: "abcdefgh",
     v: "14c8118000000000030800000004042004189020001308014088003280000078"

  @b k: "This is a much more ridiculous test because of 21347597.",
     v: "5d9c6a6b22384bcd524a8d414d82237777433fc1a07a02c3e06985d96ecdf8fb"

  @c k: "The rain in Spain falls mostly in the plains.",
     v: "039020eb1050188be400091130981860648e39f5b1246d8c3c3c7623801186ac"

  @d k: "The rain in Spain falls mainly in the plains.",
     v: "23b000e908501883c408019410d83a60c48f1977a3246ccc3cbc7213c81104bc"

  test "compare" do
    a = Nilsimsa.process(@a[:k])
    b = Nilsimsa.process(@b[:k])

    assert Nilsimsa.compare(a, b) == 4
    assert Nilsimsa.compare(b, a) == 4
  end

  for n <- [@a, @b, @c, @d] do
    test "process: #{n[:k]}" do
      assert to_string(Nilsimsa.process(unquote(n[:k]))) == unquote(n[:v])
    end
  end
end
