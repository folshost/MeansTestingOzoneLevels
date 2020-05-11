library(easypackages) # this makes calling other packages ... easy using the next line to put them all in one process,
libraries("plyr","reshape2","ggplot2","readxl","foreign","forecast","tseries","lubridate","xts","tsbox","fpp2") # these are the packages needed for this code to run. They are all loaded here. 

source("./Functions/TSConvert.R") # adds the function 
source("./run_models.R")
ozone = read.csv("./ozone/cleaned_sorted_ozone_1996_2004.csv",header=T)
ozone$datelocal <- as.Date(ozone$datelocal)
ozone_tmp = ozone 
ozone_tmp$datelocal <- as.POSIXlt(ozone_tmp$datelocal)
ozone_tmp$day <- ozone_tmp$datelocal$mday
ozone_tmp$month <- ozone_tmp$datelocal$mon+1

ozone_tmp$day_of_year <- paste(as.character(ozone_tmp$month),as.character(ozone_tmp$day),sep="_")

jan_1 <- subset(ozone_tmp, day_of_year=='1_1')
hist(jan_1[['arithmean']]^(1/2))

ozone2 <- subset(ozone, datelocal>=as.Date('1997-01-01'), c('datelocal', 'arithmean', 'concat'))
#ozone2_ <- subset(ozone2, concat=='ArizonaMaricopa')

setwd("C:/Users/Maxwell/Documents/LSU/Classes/EXST/EXST7087/PROJECT")
#ozone2 = ozone2_
# Original run
run_models(ozone2, "2000-12-31","2000-12-31", "even_split")
check_models(ozone2, "even_split")

run_models(ozone2, "1998-12-31","1998-12-31", "25_75")
check_models(ozone2, "25_75")

run_models(ozone2, "2002-12-31","2002-12-31", "75-25")
check_models(ozone2, "75-25")

run_models(ozone2, "2001-12-31","2001-12-31", "left_625")
check_models(ozone2, "left_625")


run_models(ozone2, "2003-12-31","2003-12-31", "7_to_1")
check_models(ozone2, "7_to_1")

run_models(ozone2, "1997-12-31","1997-12-31", "1_to_7")
check_models(ozone2, "1_to_7")

run_models(ozone2, "1998-12-31","2002-12-31", "even_split_4_year_gap")
check_models(ozone2, "even_split_4_year_gap")

run_models(ozone2, "2000-12-31","2002-12-31", "66_33_2_year_gap")
check_models(ozone2, "66_33_2_year_gap")


ozone3 = subset(ozone2, datelocal>=as.Date('2001-01-01'))

run_models(ozone3,"2002-12-31","2002-12-31","late_even_split")
check_models(ozone3, "late_even_split")

run_models(ozone3,"2003-12-31","2003-12-31","late_75_25")
check_models(ozone3, "late_75_25")

run_models(ozone3,"2001-12-31","2001-12-31","late_25_75")
check_models(ozone3, "late_25_75")

hist(vals_1997[1,])



jan = read.csv("./ozone/january_96_avg.csv",header=T)
mean_test=ts(jan$value,start=c(1996,1,1),frequency=31)

ozone2_train=subset(ozone2,ozone2$datelocal<=as.Date("2001-12-31"))
ozone2_test=subset(ozone2,ozone2$datelocal>as.Date("2001-12-31"))
mean_train=ts(ozone2_train$arithmean,start=c(1997,1,1),frequency=365.25)
mean_test=ts(ozone2_test$arithmean,start=c(2002,1,1),frequency=365.25)

fit=nnetar(mean_train,p=30,P=,Size=10,repeats=10,lambda = "auto")
pred=forecast(fit,31)
autoplot(pred)
predictions=pred$mean
autoplot(predictions)

fit2=arima(mean_train,order=c(29,0,1))
pred2=forecast(fit2,31)
autoplot(pred2)
predictions2=pred2$mean
autoplot(predictions2)


results=data.frame(Test=ozone2_test$arithmean,PredictionsNN=as.vector(predictions),PredictionsARIMA=as.vector(predictions2),Date=ozone2_test$datelocal)
results$Diff1=(results$Test-results$PredictionsNN)
results$Diff2=(results$Test-results$PredictionsARIMA)
mean_square_errorNN=sqrt(mean(results$Diff1^2))
mean_errorNN=mean(abs(results$Diff1))
mean_square_errorARIMA=sqrt(mean(results$Diff2^2))
mean_errorARIMA=mean(abs(results$Diff2))



ozone4 = ozone3
d=0.4
k=round(nrow(ozone4)*d)
l=nrow(ozone4)-k
train=ozone4[1:l,]
test=ozone4[(l+1):nrow(ozone4),]

freq=366
Allcases_train=TSConvert(train,"arithmean",freq)
Allcases_test=TSConvert(test,"arithmean",freq)
AllCases=TSConvert(ozone4,"arithmean",freq)
AllCases_ma=ma(AllCases,order=3)

fit1=nnetar(Allcases_train,p=7,Size=10,repeats=50,lambda = "auto")
for1=forecast(fit1,k)
autoplot(for1)
predictions1=for1$mean
autoplot(predictions1)

fit2=nnetar(Allcases_train)
for2=forecast(fit2,k)
autoplot(for2)
predictions2=for2$mean
autoplot(predictions2)

fit3=auto.arima(Allcases_train) 
for3=forecast(fit3,h=k)
autoplot(for3)
predictions3=for3$mean
autoplot(predictions3)

fit4=arima(Allcases_train,order=c(2,0,1))
for4=forecast(fit4,k)
autoplot(for4)
predictions4=for4$mean
autoplot(predictions4)

results=data.frame(Date=test$datelocal,Test=test$arithmean,PredNN=as.vector(predictions1),
                   PredAutoNN=as.vector(predictions2),PredAutoARIMA=as.vector(predictions3),
                   PredARIMA=as.vector(predictions4))
results$Ensamble1=rowMeans(results[,c(3,5)])
results$Ensamble2=rowMeans(results[,3:5])

p1=ggplot() +
  geom_line(data = results, aes(x = Date, y = Test, colour = "Actual Values")) +
  geom_line(data = results, aes(x = Date, y = PredNN,   colour = "Predictions NN"))  +
  geom_line(data = results, aes(x = Date, y = PredARIMA,   colour = "Predictions ARIMA"))  +
  geom_line(data = results, aes(x = Date, y = PredAutoARIMA,   colour = "Predictions Auto ARIMA"))  +
  geom_line(data = results, aes(x = Date, y = PredAutoNN,   colour = "Predictions Auto Neural Network"))  +
  geom_line(data = results, aes(x = Date, y = Ensamble1,   colour = "Predictions Ensamble1"))  +
  geom_line(data = results, aes(x = Date, y = Ensamble2,   colour = "Predictions Ensamble2"))  +
  ylab('Cases')+ggtitle(paste0("Comparison of Predicted vs True Number of Cases for ",round(nrow(ozone4)*d)," days"))+
  theme_bw()
ggsave(paste0("./Results/Graphs/Predictions_vs_Test_days_",k,".pdf"),p1)
p1


ozone3 = ozone2
# Try seeing if smoothing means I have no usable data
ozone4 = subset(ozone3,as.Date(ozone3$datelocal)>=as.Date("1997-01-01"))
maxtemp=ts(ozone4$arithmean,start=c(1997,1,1),frequency=366)
autoplot(maxtemp)
p1=ggplot()+
  geom_line(data = ozone4, aes(x = datelocal, y = arithmean)) + ylab('Arithmetic Mean PM10')
ggsave("./Results/Graphs/Maximum_Temperature.pdf",p1)
p1
#=============== Apply a moving average ===============================================================
ozone4$wk_mean=ma(ozone4$arithmean,order=7)
ozone4$mt_mean=ma(ozone4$arithmean,order=30)
#============= 
p2=ggplot() +
  geom_line(data = ozone4, aes(x = datelocal, y = arithmean, colour = "Raw Data")) +
  geom_line(data = ozone4, aes(x = datelocal, y = wk_mean,   colour = "Weekly Moving Average"))  +
  geom_line(data = ozone4, aes(x = datelocal, y = mt_mean, colour = "Monthly Moving Average"))  +
  ylab('Arithmetic Mean PM10')
ggsave("./Results/Graphs/Multi_Moving_Averages.pdf",p2)
p2
mt_mean=ma(maxtemp,order=30)
autoplot(mt_mean)
#=============== Decomposing a timeseries ============================================================
decomp=decompose(mt_maxtemp,type="additive")
autoplot(decomp)

detrend=mt_maxtemp-decomp$trend
autoplot(detrend)

deseason=mt_maxtemp-decomp$seasonal
autoplot(deseason)
#=============== Remove Random Noise and analyze =====================================================
nonoise_maxtemp=mt_maxtemp-decomp$random
autoplot(decomp$random)
sd(as.vector(na.omit(decomp$random)))
clean_maxtemp=na.omit(nonoise_maxtemp)
autoplot(clean_maxtemp)

clean_decomp=decompose(clean_maxtemp,type="additive")
autoplot(clean_decomp)

#=============== Test for stationary ==================================================================
adf.test(na.omit(clean_maxtemp)) #The small p value indicates stationary i.e mean variance and autocorrelation don't change over time
Acf(clean_maxtemp) # The autocorrelation function
Pacf(clean_maxtemp) # The partial autocorrelation function


