# Load required libraries
library(xlsx); library(tidyr); library(ggplot2)
library(MASS); library(caret); library(kernlab)

# Define working directory
setwd("C:/Users/Felipe/Documents/Coursera/myFiles/09_DevelopingDataProducts/myShiny")

# Load Li Ma's data
fileName <- "LiMa_AM_FEM_DOE_In625_10k_32run.xlsx"; sheetNumber <- 1
FEMdata <- read.xlsx(fileName, sheetIndex = sheetNumber, header = FALSE,
                     colClasses = "character", stringsAsFactors = FALSE)
namesRow <- 8; startRow <- 14; nomRow <- 11; varRow <- 13
names(FEMdata) <- FEMdata[namesRow,]
numRegressors <- ncol(FEMdata)-3 # Number of regressors
# Nominal simulation parameters
nomValues <- FEMdata[nomRow,]; nomValues <- nomValues[,2:(numRegressors+1)]
nomValues[,1:numRegressors] <- as.numeric(unlist(nomValues))
# Variation in simulation parameters
varValues <- FEMdata[varRow,]; varValues <- varValues[,2:(numRegressors+1)]
varValues[,1:numRegressors] <- as.numeric(unlist(varValues))
# Read DOE data (+1,0,-1)
FEMdata <- FEMdata[startRow:nrow(FEMdata),]
FEMdata[,2:ncol(FEMdata)] <- as.numeric(unlist(FEMdata[,2:ncol(FEMdata)]))
# Correct first column
names(FEMdata)[1] <- "numRun"
FEMdata$numRun <- gsub("Run No.","", FEMdata$numRun, perl=TRUE)
FEMdata$numRun <- extract_numeric(FEMdata$numRun)
# Define nominal values for thermo-physical properties read from tables
nomValues$Cp <- 658 # J/kg/K
nomValues$Rho <- 7892 # kg/m^3
nomValues$k <- 28 # W/m/K
nomValues$kp <- 0.3 # W/m/K
# Transform to numeric values
for (i in 1:numRegressors){
  FEMdata[,i+1] <- rep(1,nrow(FEMdata)) +
    FEMdata[,i+1]*rep(unlist(varValues[i]),nrow(FEMdata))
  FEMdata[,i+1] <- FEMdata[,i+1] * rep(unlist(nomValues[i]),nrow(FEMdata))
}
# Remove extra variables
rm(namesRow,nomRow,startRow,varRow,sheetNumber,fileName)
rm(i,numRegressors); rm(varValues)


# Construct model
require(caret); require(kernlab)
myTraining <- FEMdata
# Gaussian process regression with four regressors
GPRmodel1 <- gausspr(W ~ P+v, data = myTraining, kernel="rbfdot")
GPRmodel2 <- gausspr(L ~ P+v, data = myTraining, kernel="rbfdot")

# Prediction functions

#' Predict melt pool width for SLM of Inconel 625 for a combination of power and speed.
#' 
#' This function uses a Gaussian Process regression trained with data points obtained
#' from an ABAQUS finite element model of selective laser melting of Inconel 625, and
#' predicts melt pool width for some user-specified laser power and scan speed.
#' 
#' @param Ppred Laser power in Watts
#' @param vpred Scan speed in mm/s
#' @return width Melt pool width in microns
#'
width <- function(Ppred, vpred){
  width  <- predict(GPRmodel1, data.frame(P = Ppred, v = vpred))
}


#' Predict melt pool length for SLM of Inconel 625 for a combination of power and speed.
#' 
#' This function uses a Gaussian Process regression trained with data points obtained
#' from an ABAQUS finite element model of selective laser melting of Inconel 625, and
#' predicts melt pool length for some user-specified laser power and scan speed.
#' 
#' @param Ppred Laser power in Watts
#' @param vpred Scan speed in mm/s
#' @return length Melt pool length in microns
#'
length <- function(Ppred, vpred){
  length  <- predict(GPRmodel2, data.frame(P = Ppred, v = vpred))
}