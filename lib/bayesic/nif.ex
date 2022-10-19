defmodule Bayesic.Nif do
  use Rustler, otp_app: :bayesic_nif, crate: :bayesic_nif

  def new, do: :erlang.nif_error(:nif_not_loaded)

  def train(_bayesic, _class, _tokens) do
    :erlang.nif_error(:nif_not_loaded)
  end

  def classify(_baysic, _tokens) do
    :erlang.nif_error(:nif_not_loaded)
  end

  def prune(_bayesic, _threshold) do
    :erlang.nif_error(:nif_not_loaded)
  end
end
