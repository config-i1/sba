obs <- 73
MLRData <- data.frame(size=rep(1, obs),
                      materials=1,
                      type="commercial",
                      projects=1,
                      year=2000)
set.seed(41)
MLRData$type <- sample(c("detached","semi-detached","apartment","other"), obs, replace=TRUE)
MLRData$size <- round(runif(obs, 60, 100) *
                          sapply(MLRData$type, switch,
                                 "detached"=1.05,
                                 "semi-detached"=1.4,
                                 "apartment"=10,
                                 "other"=0.9), 2)
MLRData$year <- MLRData$year + rpois(obs, 8)
MLRData$materials <- round(MLRData$size * 2 * rlnorm(obs, 0, 0.1)*(MLRData$year/2000)^4,2)
MLRData$projects <- rbinom(obs, 7, 0.5)

MLRData$overall <- (0.5 * MLRData$size + MLRData$materials*(1+sapply(MLRData$type, switch,
                                                                     "detached"=0.15,
                                                                     "semi-detached"=0.1,
                                                                     "apartment"=0,
                                                                     "other"=0)) -
                        1.5 * MLRData$projects + 0.1 * MLRData$year + sapply(MLRData$type, switch,
                                                                             "detached"=50,
                                                                             "semi-detached"=25,
                                                                             "apartment"=0,
                                                                             "other"=0) +
                        rnorm(obs, 0, 30))
summary(MLRData)

boxplot(size~type, MLRData)
plot((size)~(materials), MLRData)
plot(log(size)~log(materials), MLRData)
spread(MLRData)

MLRDataSample <- MLRData[MLRData$type!="apartment",]
spread(MLRDataSample)
SBA_Chapter_11_Costs <- MLRDataSample[,c("overall","size","materials","type","projects","year")]
SBA_Chapter_11_Costs$type <- factor(SBA_Chapter_11_Costs$type, levels=c("detached","semi-detached","other"))
save(SBA_Chapter_11_Costs, file="data/SBA_Chapter_11_Costs.Rdata")
