% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/glmpca.R
\name{glmpca}
\alias{glmpca}
\title{GLM-PCA}
\usage{
glmpca(Y, L, fam = c("poi", "nb", "mult", "bern"), ctl = list(maxIter =
  1000, eps = 1e-04), penalty = 1, verbose = FALSE,
  init = list(factors = NULL, loadings = NULL), nb_theta = 100,
  X = NULL, Z = NULL, sz = NULL)
}
\arguments{
\item{Y}{matrix of count data with features as rows and observations as
columns.}

\item{L}{the desired number of latent dimensions (integer).}

\item{fam}{character describing the likelihood to use for the data (poisson,
negative binomial, binomial approximation to multinomial, bernoulli).}

\item{ctl}{a list of control parameters for optimization.}

\item{penalty}{the L2 penalty for the latent factors (default = 1).
Regression coefficients are not penalized.}

\item{verbose}{logical value indicating whether the current deviance should
be printed after each iteration (default = FALSE).}

\item{init}{a list containing initial estimates for the factors (\code{U}) and
loadings (\code{V}) matrices.}

\item{nb_theta}{see \code{\link[MASS]{negative.binomial}} (\code{nb_theta}->\eqn{\infty}
equivalent to Poisson).}

\item{X}{a matrix of column (observations) covariates. Any column with all
same values (eg. 1 for intercept) will be removed. This is because we force
the intercept and want to avoid collinearity.}

\item{Z}{a matrix of row (feature) covariates, usually not needed.}

\item{sz}{numeric vector of size factors to use in place of total counts.}
}
\value{
A list containing:
\describe{
  \item{factors}{a matrix \code{U} whose rows match the columns (observations) of \code{Y}. It is analogous to the principal components in PCA. Each column of the factors matrix is a different latent dimension.}
  \item{loadings}{a matrix \code{V} whose rows match the rows (features/dimensions) of \code{Y}. It is analogous to loadings in PCA. Each column of the loadings matrix is a different latent dimension.}
  \item{coefX}{a matrix \code{A} of coefficients for the observation-specific covariates matrix \code{X}. Each row of coefX corresponds to a row of \code{Y} and each column corresponds to a column of \code{X}. The first column of coefX contains feature-specific intercepts which are included by default.}
  \item{coefZ}{a matrix \code{G} of coefficients for the feature-specific covariates matrix \code{Z}. Each row of coefZ corresponds to a column of \code{Y} and each column corresponds to a column of \code{Z}. By default no such covariates are included and this is returned as NULL.}
  \item{dev}{a vector of deviance values. The length of the vector is the number of iterations it took for GLM-PCA's optimizer to converge. The deviance should generally decrease over time. If it fluctuates wildly, this often indicates numerical instability, which can be improved by increasing the \code{penalty} parameter.}
  \item{family}{an S3 object of class glmpca_family. This is a minor extension to the \link[stats]{family} or \link[MASS]{negative.binomial} object used by functions like \link[stats]{glm} and \link[MASS]{glm.nb}. It is basically a list with various internal functions and parameters needed to optimize the GLM-PCA objective function. For the negative binomial case, it also contains the final estimated value of the dispersion parameter (\code{nb_theta}).}
}
}
\description{
This function implements the GLM-PCA dimensionality reduction
  method for high-dimensional count data.
}
\details{
The basic model is \eqn{R = AX'+ZG'+VU'}, where \eqn{E[Y] = M
  = linkinv(R)}. Regression coefficients are \code{A} and \code{G}, latent
  factors are \code{U} and loadings are \code{V}. The objective function being optimized is the deviance between \code{Y} and \code{M}, plus an L2 (ridge) \code{penalty} on \code{U} and \code{V}. Note that glmpca uses a random initialization, so for fully reproducible results one may use \code{set.seed}.
}
\examples{
#create a simple dataset with two clusters
mu<-rep(c(.5,3),each=10)
mu<-matrix(exp(rnorm(100*20)),nrow=100)
mu[,1:10]<-mu[,1:10]*exp(rnorm(100))
clust<-rep(c("red","black"),each=10)
Y<-matrix(rpois(prod(dim(mu)),mu),nrow=nrow(mu))
#visualize the latent structure
res<-glmpca(Y, 2)
factors<-res$factors
plot(factors[,1],factors[,2],col=clust,pch=19)

}
\references{
Townes FW, Hicks SC, Aryee MJ, and Irizarry RA (2019).
Feature Selection and Dimension Reduction for Single Cell RNA-Seq based on a Multinomial Model.
\emph{biorXiv}
\url{https://www.biorxiv.org/content/10.1101/574574v1}

Townes FW (2019).
Generalized Principal Component Analysis.
\emph{arXiv}
\url{https://arxiv.org/abs/1907.02647}
}
\seealso{
\code{\link[stats]{prcomp}}
}
