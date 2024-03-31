### Reprex for help interpreting model coefficients

I could use help interpreting model coefficients in a multivariate poisson GLM with a spatial random effect.

The script `reprex-spatial-random-effect.R` in this repository provides code to simulate a spatial dataset of multivariate species abundances in response to an explanatory variable `Fire severity` and a spatially structured latent variable. 

This script also contains code to fit two models to this dataset: 1) a multivariate poisson GLM with a non-spatial, site-level random effect, and 2) a multivariate poisson GLM with a spatial random effect.

Here are the simulated 'known truths' for the slope beta coefficients representing the associations between 5 different species abundances and `Fire severity`.

| spp  |        b1|
|------|------|
|spp1 |-0.69314718|
|spp2| -0.09531018|
|spp3  |0.00000000|
|spp4 | 0.09531018|
|spp5 | 0.69314718|

Model 1 (with a non-spatial random effect) recovered beta 1 coefficients closer to these values than Model 2 (with a spatial random effect):

Model 1 summary of estimated b1 coefficients:

  |                              |      Mean     |
  |------|------|
|B[Fire_severity (C2), spp1 (S1)] |-0.77439142 |
|B[Fire_severity (C2), spp2 (S2)]| -0.07943399 |
|B[Fire_severity (C2), spp3 (S3)] | 0.09497635 |
|B[Fire_severity (C2), spp4 (S4)]|  0.01570744 |
|B[Fire_severity (C2), spp5 (S5)] | 0.69535776|

Model 2 summary of estimated b1 coefficients:

|                              |      Mean|
  |------|------|
|B[Fire_severity (C2), spp1 (S1)]| -0.73044569 |
|B[Fire_severity (C2), spp2 (S2)] | 0.04536074 |
|B[Fire_severity (C2), spp3 (S3)]| -0.02598279 |
|B[Fire_severity (C2), spp4 (S4)]| -0.05475742 |
|B[Fire_severity (C2), spp5 (S5)] | 0.71697044|

In fact, the mean estimate of b1 coefficients for spp2 and spp3 have switched signs from the expected 'known truth' when the spatial random effect is included in the model.

Is the deviation from the 'known truths' in the spatial model because the b1 coefficients are no longer interpreted as the change in mean species abundance expected with a one unit shift in X (Fire severity), but rather the change in mean species abundance given a one unit shift in Fire severity *conditional* on the spatial random effect?

Is it possible to estimate from the 'known truths' of the simulated data set what we would expect the model to recover if it contains a spatial random effect? I checked the alpha parameter, and the spatial model does estimate the scale of autocorrelation correctly (0.35).
