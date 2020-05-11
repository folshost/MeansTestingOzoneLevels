library(easypackages) # this makes calling other packages ... easy using the next line to put them all in one process,
libraries("plyr","reshape2","ggplot2","readxl","foreign","forecast","tseries","lubridate","xts","tsbox","fpp2") # these are the packages needed for this code to run. They are all loaded here. 

source("./Functions/TSConvert.R") # adds the function 
high_uptime = read.csv("high_uptime_records_1996_2012.csv",header=T)
high_uptime$datelocal <- as.Date(high_uptime$datelocal)
high_uptime2 <- subset(high_uptime, address=='1242 JERSEY ST WYLAM AL', c('datelocal', 'arithmeticmean', 'address'))
hu2 = high_uptime2

y_96 = seq(as.Date('1996-01-01'), by='day', length.out=366)
y_2k = seq(as.Date('2000-01-01'), by='day', length.out=366)
y_24 = seq(as.Date('2004-01-01'), by='day', length.out=366)
y_28 = seq(as.Date('2008-01-01'), by='day', length.out=366)
y_12 = seq(as.Date('2012-01-01'), by='day', length.out=366)

days = data.frame(c(y_96, y_2k, y_24, y_28, y_12))

colnames(days) <- c('datelocal')

hu3 = merge(days, hu2, all=T)
which(is.na(hu3))
hu3[c(75:80),2] = c(39, 24, 8, 15, 13, 13)
hu3[c(132:137),2] = c(20,47,43,19,17,21)
hu3[183,2] = 29
hu3[c(469:470),2] = c(47,26)
hu3[c(717:718),2] = c(16,8)
hu3[c(992:993),2] = c(13,19)
hu3[c(1662:1666),2] = c(43,45,51,56,49)

hu2_train=subset(hu2,hu2$datelocal<=as.Date("2008-11-30"))
hu2_test=subset(hu2,hu2$datelocal>as.Date("2008-11-30"))
mean_train=ts(hu2_train$arithmeticmean,start=c(1996,1,1),frequency=366)
mean_test=ts(hu2_test$arithmeticmean,start=c(2008,12,1),frequency=366)

fit=nnetar(mean_train,p=30,P=,Size=10,repeats=50,lambda = "auto")
pred=forecast(fit,31)
autoplot(pred)
predictions=pred$mean
autoplot(predictions)

fit2=arima(mean_train,order=c(29,0,1))
pred2=forecast(fit2,31)
autoplot(pred2)
predictions2=pred2$mean
autoplot(predictions2)


results=data.frame(Test=hu2_test$arithmeticmean,PredictionsNN=as.vector(predictions),PredictionsARIMA=as.vector(predictions2),Date=hu2_test$datelocal)
results$Diff1=(results$Test-results$PredictionsNN)
results$Diff2=(results$Test-results$PredictionsARIMA)
mean_square_errorNN=sqrt(mean(results$Diff1^2))
mean_errorNN=mean(abs(results$Diff1))
mean_square_errorARIMA=sqrt(mean(results$Diff2^2))
mean_errorARIMA=mean(abs(results$Diff2))



hu4 = hu3
d=0.4
k=round(nrow(hu4)*d)
l=nrow(hu4)-k
train=hu4[1:l,]
test=hu4[(l+1):nrow(hu4),]

freq=366
Allcases_train=TSConvert(train,"arithmeticmean",freq)
Allcases_test=TSConvert(test,"arithmeticmean",freq)
AllCases=TSConvert(hu4,"arithmeticmean",freq)
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

results=data.frame(Date=test$datelocal,Test=test$arithmeticmean,PredNN=as.vector(predictions1),
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
  ylab('Cases')+ggtitle(paste0("Comparison of Predicted vs True Number of Cases for ",round(nrow(hu4)*d)," days"))+
  theme_bw()
ggsave(paste0("./Results/Graphs/Predictions_vs_Test_days_",k,".pdf"),p1)
p1



# Try seeing if smoothing means I have no usable data
hu4 = subset(hu3,as.Date(hu3$datelocal)>=as.Date("1996-01-01") & as.Date(hu3$datelocal)<as.Date("1997-01-01") )
maxtemp=ts(hu4$arithmeticmean,start=c(1996,1,1),stop=c(1997,1,1),frequency=366)
autoplot(maxtemp)
p1=ggplot()+
  geom_line(data = hu4, aes(x = datelocal, y = arithmeticmean)) + ylab('Arithmetic Mean PM10')
ggsave("./Results/Graphs/Maximum_Temperature.pdf",p1)
p1
#=============== Apply a moving average ===============================================================
hu4$wk_mean=ma(hu4$arithmeticmean,order=7)
hu4$mt_mean=ma(hu4$arithmeticmean,order=30)
#============= 
p2=ggplot() +
  geom_line(data = hu4, aes(x = datelocal, y = arithmeticmean, colour = "Raw Data")) +
  geom_line(data = hu4, aes(x = datelocal, y = wk_mean,   colour = "Weekly Moving Average"))  +
  geom_line(data = hu4, aes(x = datelocal, y = mt_mean, colour = "Monthly Moving Average"))  +
  ylab('Arithmetic Mean PM10')
ggsave("./Results/Graphs/Multi_Moving_Averages.pdf",p2)
p2
mt_mean=
  
  (maxtemp,order=30)
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


