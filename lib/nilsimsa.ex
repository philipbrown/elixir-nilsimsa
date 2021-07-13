defmodule Nilsimsa do
  @moduledoc """
  Nilsimsa
  """

  @type t :: %__MODULE__{
          acc: list(integer()),
          count: integer(),
          digest: list(integer()) | nil,
          window: list(integer())
        }

  defstruct acc: for(_ <- 0..255, do: 0),
            count: 0,
            digest: nil,
            window: for(_ <- 0..3, do: -1)

  @doc """
  """
  @spec compare(t, t) :: integer
  def compare(_a, _b) do
    # TODO: make it work
    0
  end

  @doc """
  """
  @spec digest(t) :: t
  def digest(nilsimsa) do
    # TODO: make it work
    nilsimsa
  end

  @doc """
  """
  @spec process(String.t()) :: t
  def process(binary) do
    process(binary, %__MODULE__{})
  end

  @spec process(String.t(), t) :: t
  def process(<<_head::utf8, _tail::binary>>, nilsimsa) do
    # TODO: make it work
    nilsimsa
  end

  def process(<<>>, nilsimsa) do
    nilsimsa
  end
end
