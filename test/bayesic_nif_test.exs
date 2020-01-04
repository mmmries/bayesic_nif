defmodule BayesicNifTest do
  use ExUnit.Case
  doctest BayesicNif

  test "greets the world" do
    assert BayesicNif.hello() == :world
  end
end
