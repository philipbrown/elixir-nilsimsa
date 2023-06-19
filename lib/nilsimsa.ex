defmodule Nilsimsa do
  @external_resource "README.md"
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  import Bitwise

  import Enum, only: [at: 2]

  alias Nilsimsa.{Hamming, Transition}

  @tran3 Transition.generate(53)
  @popc Hamming.generate()

  @type t :: %__MODULE__{
          acc: list(integer()),
          count: integer(),
          digest: list(integer()) | nil,
          threshold: float(),
          window: list(integer())
        }

  defstruct acc: for(_ <- 0..255, do: 0),
            count: 0,
            digest: nil,
            threshold: 0.0,
            window: for(_ <- 0..3, do: -1)

  @doc """
  Compare two hashed values

  This returns a value between -127 and 128 where -127 is different and 128 is
  similar.

  ## Examples

      iex> Nilsimsa.compare(Nilsimsa.process("abc"), Nilsimsa.process("def"))
      126

  """
  @spec compare(t, t) :: integer
  def compare(%{digest: a}, %{digest: b}) when is_list(a) and is_list(b) do
    Enum.reduce(0..31, 128, fn i, acc ->
      acc - at(@popc, band(255, bxor(at(a, i), at(b, i))))
    end)
  end

  def compare(a, b) do
    compare(digest(a), digest(b))
  end

  @doc """
  Generate the digest of a hash

  ## Examples

      iex> to_string(Nilsimsa.digest(Nilsimsa.process("abcdefgh")))
      "14c8118000000000030800000004042004189020001308014088003280000078"

  """
  @spec digest(t) :: t
  def digest(nilsimsa) do
    nilsimsa = %{nilsimsa | threshold: trigrams(nilsimsa) / 256}

    digest =
      Enum.reduce(0..255, for(_ <- 0..31, do: 0), fn i, digest ->
        if at(nilsimsa.acc, i) > nilsimsa.threshold do
          List.update_at(digest, bsr(i, 3), fn n ->
            n + bsl(1, band(i, 7))
          end)
        else
          digest
        end
      end)

    %{nilsimsa | digest: Enum.reverse(digest)}
  end

  @doc """
  Process the given string as a Nilsimsa hash

  ## Examples

      iex> to_string(Nilsimsa.process("abcdefghijklmnopqrstuvwxyz"))
      "94ca95850773045cabb93869ba8657373499beb81a17587fd6f9107fc54cc978"

  """
  @spec process(String.t()) :: t
  def process(binary) do
    process(binary, %__MODULE__{})
  end

  @doc """
  Process the given string as a Nilsimsa hash using the given accumulator struct

  ## Examples

      iex> to_string(Nilsimsa.process("abcdefghijklmnopqrstuvwxyz", %Nilsimsa{}))
      "94ca95850773045cabb93869ba8657373499beb81a17587fd6f9107fc54cc978"

  """
  @spec process(String.t(), t) :: t
  def process(<<c::utf8, rest::binary>>, %{acc: acc, window: win} = nilsimsa) do
    acc =
      if at(win, 1) > -1 do
        List.update_at(acc, tran3(c, at(win, 0), at(win, 1), 0), &(&1 + 1))
      else
        acc
      end

    acc =
      if at(win, 2) > -1 do
        acc
        |> List.update_at(tran3(c, at(win, 0), at(win, 2), 1), &(&1 + 1))
        |> List.update_at(tran3(c, at(win, 1), at(win, 2), 2), &(&1 + 1))
      else
        acc
      end

    acc =
      if at(win, 3) > -1 do
        acc
        |> List.update_at(tran3(c, at(win, 0), at(win, 3), 3), &(&1 + 1))
        |> List.update_at(tran3(c, at(win, 1), at(win, 3), 4), &(&1 + 1))
        |> List.update_at(tran3(c, at(win, 2), at(win, 3), 5), &(&1 + 1))
        |> List.update_at(tran3(at(win, 3), at(win, 0), c, 6), &(&1 + 1))
        |> List.update_at(tran3(at(win, 3), at(win, 2), c, 7), &(&1 + 1))
      else
        acc
      end

    nilsimsa =
      nilsimsa
      |> Map.put(:acc, acc)
      |> Map.update!(:count, &(&1 + 1))
      |> Map.update!(:window, &List.insert_at(List.delete_at(&1, 3), 0, c))

    process(rest, nilsimsa)
  end

  def process(<<>>, nilsimsa) do
    nilsimsa
  end

  ###########
  # Private #
  ###########

  defp tran3(a, b, c, n) do
    @tran3
    |> at(a + n)
    |> band(255)
    |> bxor(at(@tran3, b) * (n + n + 1))
    |> Kernel.+(at(@tran3, bxor(c, at(@tran3, n))))
    |> band(255)
  end

  defp trigrams(%{count: 3}), do: 1
  defp trigrams(%{count: 4}), do: 4
  defp trigrams(%{count: count}) when count > 4, do: 8 * count - 28
  defp trigrams(_), do: 0
end

defimpl String.Chars, for: Nilsimsa do
  @moduledoc """
  String.Chars protocol for Nilsimsa
  """

  import Kernel, except: [to_string: 1]

  def to_string(%{digest: nil} = nilsimsa) do
    nilsimsa
    |> Nilsimsa.digest()
    |> to_string()
  end

  def to_string(nilsimsa) do
    nilsimsa.digest
    |> :binary.list_to_bin()
    |> Base.encode16(case: :lower)
  end
end
