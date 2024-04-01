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
 |B[Fire_severity (C2), spp1 (S1)]  |-0.8731268 |
 |B[Fire_severity (C2), spp2 (S2)] | -0.1009772 |
 |B[Fire_severity (C2), spp3 (S3)]  |-0.1928004 |
 |B[Fire_severity (C2), spp4 (S4)]   |0.2030243 |
 |B[Fire_severity (C2), spp5 (S5)]  | 0.6712431 |

Model 2 summary of estimated b1 coefficients:

|                              |      Mean|
  |------|------|
| B[Fire_severity (C2), spp1 (S1)] | -0.9392138| 
| B[Fire_severity (C2), spp2 (S2)] | -0.1949200 | 
| B[Fire_severity (C2), spp3 (S3)]|  -0.1580849 | 
| B[Fire_severity (C2), spp4 (S4)] |  0.2176851 | 
| B[Fire_severity (C2), spp5 (S5)] |  0.6902558 | 

Both models provide coefficient estimates slightly biased from the simulated 'known truths'. Also, the mean value of the alpha parameter estimated by the spatial Model 2 is 0.18, but was simulated to be 0.35. 

Is there anything I can do to improve parameter estimation by these models to get closer to the 'known truths'? The mcmc convergence diagnostics (gelman-rubin psrf and effective sample sizes) all indicate that mcmc sampling is adequate.

I was also wondering if the interpretation of the b1 coefficient changes when the model includes either a non-spatial or a spatial site-level random effect. Rather than the change in mean species abundance expected with a one unit shift in X (Fire severity), should they be interpreted as the change in mean species abundance given a one unit shift in Fire severity *conditional* on the random effect?
