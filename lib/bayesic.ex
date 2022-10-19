defmodule Bayesic do
  def new, do: Bayesic.Nif.new()

  def classify(bayesic, tokens) do
    Bayesic.Nif.classify(bayesic, tokens)
  end

  def prune(bayesic, threshold \\ 0.5) do
    {:ok, :ok} = Bayesic.Nif.prune(bayesic, threshold)
    bayesic
  end

  def train(bayesic, classification, tokens) do
    {:ok, :ok} = Bayesic.Nif.train(bayesic, classification, tokens)
    bayesic
  end
end
