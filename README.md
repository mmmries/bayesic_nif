# BayesicNif

A string matching library similar to a NaiveBayes classifier, but optimized for use cases where you have many possible matches.

This is especially useful if you have two large lists of names/titles/descriptions to match with each other.

> This library is based on the [pure elixir Bayesic](https://hex.pm/packages/bayesic) library. For performance reasons, this library does the data manipulation in a rust NIF. This provides a ~8x improvement in training time and ~10-20x improvement in classification time.

## Usage

Pull in this library from hex.pm. Then in your project you can do the following.

```elixir
matcher = Bayesic.new()
          |> Bayesic.train("novel", ["it","was","the","best","of","times"])
          |> Bayesic.train("news", ["tonight","on","the","seven","o'clock"])
          |> Bayesic.prune(0.25)

Bayesic.classify(matcher, ["the","best","of"])
# => [{"novel", 1.0}, {"news", 0.667}]
Bayesic.classify(matcher, ["the","time"])
# => [{"novel", 0.667}, {"news", 0.667}]
```

## How It Works

This library uses the basic idea of [Bayes Theorem](https://en.wikipedia.org/wiki/Bayes%27_theorem).

It records which tokens it has seen for each possible classification. Later when you pass a set of tokens and ask for the most likely classification it looks for all potential matches and then ranks them by considering the probabily of any given match according to the tokens that it sees.

Tokens which exist in many records (ie not very unique) have a smaller impact on the probability of a match and more unique tokens have a larger impact.

In order to keep things fast, the classification will not include all possible classes, only the ones that are more likely than the naive prior probability of `1 / num_of_classes`.

## Performance

Performance varies a lot depending on the size and type of your data.
I have a built in a benchmark that you can run via `mix run benchmarks/training_and_classifying.exs`.
This benchmark loads in 60k movies and tokenizes their titles by finding all the words (downcased) in the title of the movie.
We benchmark the time it takes to train on that dataset and also the time it takes to do a specific classification as well as a more generic classification.

Currently this benchmark shows the following results on my laptop:

```
Name                    ips        average  deviation         median         99th %
match 1 word         1.21 M     0.00083 ms  ±2729.82%           0 ms           0 ms
match 3 words        0.74 M     0.00136 ms  ±1631.93%           0 ms           0 ms
training          0.00001 M      142.06 ms     ±5.56%      139.68 ms      170.46 ms
```

This means it takes 142ms to train the classifier on 60k titles and 0.8 - 1.4µs to do a classification of tokens on that classifier.