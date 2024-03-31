library(MASS)
library(Hmsc)
set.seed(123) # set seed for random number generator to ensure results are reproducible
n <- 100 # number of observations
ns <- 5 # number of species

#####
# Simulate multivariate spatial dataset
#####

# simulate relationships between species abundance and fire severity
b0 <- log(rep(10, ns)) # y-intercept for each species is 10
b1 <- log(c(2,1.1,1,1.1,2))*c(-1,-1,0,1,1) # slopes for each species (spp 1&2 decrease by factor of 2 & 1.1, spp3 no change, spp 4&5 increase by factor of 1.1 &2)
beta <- cbind(b0,b1) # bind beta coefficients together
X <- cbind(rep(1,n),runif(n, min = 0, max = 1)) # fire severity measurements

# simulate spatial autocorrelation in the abundances
xycoords <- data.frame(x = runif(n, 152.1,152.5), y = runif(n, 28.1, 28.5)*-1) # make spatial coordinates for survey locations
sigma.spatial <- c(2) # standard deviation of spatial covariance
alpha.spatial <- c(0.35) # spatial scale parameter 'alpha' for spatial covariance
sigma <- sigma.spatial^2*exp(-as.matrix(dist(xycoords))/alpha.spatial) # exponentially decreasing spatial covariance matrix
eta <- mvrnorm(mu=rep(0,n), Sigma=sigma) # draw spatially structured residuals from a multivariate normal distribution (spatially structured latent variable)
beta.spatial <- c(1,2,-2,-1,0) # define how species are spatially auto-correlated (i.e., respond to spatially structured latent variable (eta))
spatial_res <- eta%*%t(beta.spatial) # calculate spatially structured residuals for each species
lambda <- exp((X%*%t(beta))) + spatial_res # add spatial residuals to mean expected abundance of each species due to fire severity

# make final data frame of simulated species abundances with spatial autocorrelation
y <- data.frame(apply(data.frame(lambda), 2, function(x) rpois(n, x))) # simulate species abundance observations from the poisson distribution
colnames(y) <- c('spp1', 'spp2', 'spp3', 'spp4', 'spp5') # add column names to data frame
df <- data.frame(xycoords, y, Fire_severity = X[,2], Spatial_latent_variable = eta) # add fire severity and spatial latent variable

#####
# Fit multivariate model with non-spatial, site-level random effect
#####

# set up random effect
studyDesign <- data.frame(sample = as.factor(1:nrow(df)))
rL <- HmscRandomLevel(units = studyDesign$sample)

# set up the model
m <- Hmsc(Y = as.matrix(df[,3:7]),
          XData = df,
          XFormula = ~ Fire_severity,
          distr = 'poisson',
          studyDesign = studyDesign, 
          ranLevels = list(sample = rL))

# fit the model with MCMC sampling
#m_fit <- sampleMcmc(m, nChains = 4, samples = 1000, thin = 100, transient = 2500, verbose = F, nParallel = 4)
#saveRDS(m_fit, 'model_100thinning_mult.rds')
m_fit <- readRDS('model_100thinning_mult.rds')
mpost <- convertToCodaObject(m_fit)
summary(mpost$Beta)$statistics

#####
# Fit multivariate model with spatial random effect
#####

# set up spatial random effect
studyDesign <- data.frame(sample = as.factor(1:nrow(df)))
rL.spatial <- HmscRandomLevel(sData = df[,c(1,2)])

# set up the model
m <- Hmsc(Y = as.matrix(df[,3:7]),
          XData = df,
          XFormula = ~ Fire_severity,
          distr = 'poisson',
          studyDesign = studyDesign, 
          ranLevels = list(sample = rL.spatial))

# fit the model with MCMC sampling
#m_fit <- sampleMcmc(m, nChains = 4, samples = 1000, thin = 100, transient = 2500, verbose = F, nParallel = 4)
#saveRDS(m_fit, 'model_100thinning_mult_spatial.rds')
m_fit <- readRDS('model_100thinning_mult_spatial.rds')
mpost <- convertToCodaObject(m_fit)
summary(mpost$Beta)$statistics