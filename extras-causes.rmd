## Bayesian estimation of the



### How does this all work? {#extra-bayes-explain}

Behind the scenes, the model is being used to _simulate_ new data: `add_fitted_samples` does
thousands of simulations for what the average prediction will be, and then the `mean_qi` function
summarises them, giving us mean, and the 2.5 and 97.5th percentiles. That is, we say in 95% of the
simulations the mean was between `conf.low` and `conf.high`.

Because of the way the model was fitted, this is the same as making real probability statements
about our prediction.

It might be useful to know that these simulations are said to be _samples from the posterior
distribution_ --- that is, the distribution of probabilities once we combined our data with our
_prior probability_.

##### Why doesn't this work on my laptop or at home?

The `rstanarm` package is
[slightly fiddly to install](https://github.com/plymouthPsychology/installR), and if you don't get
it right then this code won't work.

We've done it for you on university computers though, and on the RStudio server that you have login
details for. So you if you want to run this at home use
[RStudio server](https://rstudio.plymouth.ac.uk/).
