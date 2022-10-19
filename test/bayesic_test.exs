defmodule BayesicTest do
  use ExUnit.Case
  doctest Bayesic

  setup do
    classifier =
      Bayesic.new()
      |> Bayesic.train("story", ["once", "upon", "a", "time"])
      |> Bayesic.train("news", ["tonight", "on", "the", "news"])
      |> Bayesic.train("novel", ["it", "was", "the", "best", "of", "times"])
      |> Bayesic.prune(0.5)

    {:ok, %{classifier: classifier}}
  end

  test "can classify matching tokens", %{classifier: classifier} do
    {:ok, classification} = Bayesic.classify(classifier, ["once", "upon", "a", "time"])
    assert classification == [{"story", 1.0}]
  end

  test "can classify not exact matches", %{classifier: classifier} do
    {:ok, classification} = Bayesic.classify(classifier, ["the", "time"])
    assert probability_of(classification, "story") > 0.9
    assert probability_of(classification, "news") < 0.8
    assert probability_of(classification, "novel") < 0.8
  end

  test "returns no potential matches for nonsense", %{classifier: classifier} do
    {:ok, classification} = Bayesic.classify(classifier, ["furby"])
    assert classification == []
  end

  defp probability_of([], _class), do: nil
  defp probability_of([{class, probability} | _rest], class), do: probability
  defp probability_of([_ | rest], class), do: probability_of(rest, class)
end
