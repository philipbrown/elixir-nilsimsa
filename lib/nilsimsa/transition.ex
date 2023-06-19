defmodule Nilsimsa.Transition do
  @moduledoc """
  A module for generating transition tables.

  A transition table provides a deterministic, yet pseudorandom, way of mapping
  input bytes to output hash chunks.
  """

  import Bitwise

  @doc """
  Generate a transition table.

  ## Examples

    iex>  Transition.generate(53) |> Enum.take(3)
    [2, 214, 158]

  """
  def generate(target),
    do: build(target, 0, 0, [])

  # Private

  defp build(_target, 256, _j, tran),
    do: Enum.reverse(tran)

  defp build(target, i, j, tran) do
    j = band(j * target + 1, 255)
    j = if j * 2 > 255, do: j * 2 - 255, else: j * 2
    j = handle_collision(j, tran, 0)

    build(target, i + 1, j, [j | tran])
  end

  defp handle_collision(j, _tran, 256),
    do: j

  defp handle_collision(j, tran, i) do
    case Enum.at(tran, i) do
      ^j -> handle_collision(band(j + 1, 255), tran, 0)
      _ -> handle_collision(j, tran, i + 1)
    end
  end
end
