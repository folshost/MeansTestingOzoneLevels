run_models <- function(df, left_date_bound, right_date_bound, name) {
  models_left <- list(c())
  models_right <- list(c())
  dir.create(paste("./Models/",name,sep=""))
  workpath = getwd()
  newpath = paste(workpath,"/Models/",name, sep = "")
  (newpath)
  setwd(newpath)
  #print(levels(df$concat))
  #(seq_along(levels(df$concat)))
  count <- 1
  for(i in seq_along(levels(df$concat))){
    level_name = levels(df$concat)[count]
    level_data = subset(df, concat==level_name, c('datelocal','arithmean'))
    train_left = subset(level_data, datelocal<=as.Date(left_date_bound)) #, c('arithmean'))[['arithmean']]
    train_right = subset(level_data, datelocal>as.Date(right_date_bound))  #, c('arithmean'))[['arithmean']]
    
    mean_train_left=ts(train_left$arithmean,start=c(1997,1,1),frequency=365.25)
    mean_train_right=ts(train_right$arithmean,start=c(2001,1,1),frequency=365.25)
    
    fit_left=nnetar(mean_train_left,p=30,P=,Size=10,repeats=15,lambda = "auto")
    fit_right=nnetar(mean_train_right,p=30,P=,Size=10,repeats=15,lambda = "auto")
    
    print(paste("County: ", count,  level_name))
    left_filename = paste(level_name,"_left_",name,".rds",sep="")
    right_filename = paste(level_name,"_right_",name,".rds",sep="")
    #print(left_filename)
    #print(right_filename)
    saveRDS(fit_left,left_filename)
    saveRDS(fit_right,right_filename)
    models_left[[1]][count] <- fit_left
    models_right[[1]][count] <- fit_right
    
    pred=forecast(fit_left,31)
    autoplot(pred)
    predictions=pred$mean
    autoplot(predictions)
    
    count <- count+1
  }
  print(models_left)
  
  
  count <- 1
  models_left <- list(c())
  models_right <- list(c())
  for(i in seq_along(levels(df$concat))){
    level_name = levels(df$concat)[count]
    fit_left=readRDS(paste(level_name,"_left_",name,".rds",sep=""))
    fit_right=readRDS(paste(level_name,"_right_",name,".rds",sep=""))
    
    models_left[[1]][count] <- fit_left
    models_right[[1]][count] <- fit_right
    
    count <- count+1
  }
  setwd(workpath)
}

check_models <- function(df, name){
  count <- 1
  models_left <- list(c())
  models_right <- list(c())
  for(i in seq_along(levels(df$concat))){
    level_name = levels(df$concat)[count]
    path=paste("./Models/",name,"/",level_name,"_left_",name,".rds",sep="")
    #print(path)
    fit_left=readRDS(path)
    fit_right=readRDS(paste("./Models/",name,"/",level_name,"_right_",name,".rds",sep=""))
    
    models_left[[1]][count] <- fit_left
    models_right[[1]][count] <- fit_right
    
    count <- count+1
  }
  
  count <- 1
  pred_left_1 <- list(c())
  pred_left_2 <- list(c())
  pred_left_3 <- list(c())
  pred_right_1 <- list(c())
  pred_right_2 <- list(c())
  pred_right_3 <- list(c())
  for(i in seq_along(levels(df$concat))){
    #mean_train_left=ts(train_left$arithmean,start=c(1997,1,1),frequency=365.25)
    #mean_train_right=ts(train_right$arithmean,start=c(2001,1,1),frequency=365.25)
    
    fit_left=models_left[[1]][count]
    fit_right=models_right[[1]][count]
    
    pred_97=forecast(fit_left[[1]],31)
    pred_val_left = data.frame(summary(pred_97))
    pred_01=forecast(fit_right[[1]],31)  
    pred_val_right = data.frame(summary(pred_01))
    if( count == 1){
      pred_left = pred_val_left
      
      pred_right = pred_val_right
    }  else {
      pred_left = pred_left+pred_val_left
      
      pred_right = pred_right+pred_val_right
    }
    
    pred_val_right = subset(pred_val_right, T, c('Point.Forecast','Lo.95', 'Hi.95'))
    pred_val_left = subset(pred_val_left, T, c('Point.Forecast','Lo.95', 'Hi.95'))
    pred_left_1[[1]][count] <- list(pred_val_left$Point.Forecast)
    pred_right_1[[1]][count] <- list(pred_val_right$Point.Forecast)
    pred_left_2[[1]][count] <- list(pred_val_left$Lo.95)
    pred_right_2[[1]][count] <- list(pred_val_right$Lo.95)
    pred_left_3[[1]][count] <- list(pred_val_left$Hi.95)
    pred_right_3[[1]][count] <- list(pred_val_right$Hi.95)
    
    count <- count+1
  }
  pred_left_point = subset(pred_left, T, c('Point.Forecast'))/51
  pred_left_low = subset(pred_left, T, c('Lo.95'))/51
  pred_left_high = subset(pred_left, T, c('Hi.95'))/51
  pred_right_point = subset(pred_right, T, c('Point.Forecast'))/51
  pred_right_low = subset(pred_right, T, c('Lo.95'))/51
  pred_right_high = subset(pred_right, T, c('Hi.95'))/51
  
  
  #(pred_left_high$Hi.95)
  #hist(pred_left_low$Lo.95)
  #hist(pred_left_point$Point.Forecast)
  #hist(pred_right_high$Hi.95)
  #hist(pred_right_low$Lo.95)
  #hist(pred_right_point$Point.Forecast)
  #summary(pred_left_point)
  #sd(pred_left_point)
  
  dir.create(paste("./Results/",name,sep=""))
  
  vals_left_point = data.frame(pred_left_1[[1]])
  vals_left_point <- matrix(unlist(vals_left_point), ncol = 31, byrow = TRUE)
  vals_left_point <- t(vals_left_point)
  vals_left_lo = data.frame(pred_left_2)
  vals_left_lo <- matrix(unlist(vals_left_lo), ncol = 31, byrow = TRUE)
  vals_left_lo <- t(vals_left_lo)
  vals_left_hi = data.frame(pred_left_3[[1]])
  vals_left_hi <- matrix(unlist(vals_left_hi), ncol = 31, byrow = TRUE)
  vals_left_hi <- t(vals_left_hi)
  vals_right_point = data.frame(pred_right_1[[1]])
  vals_right_point <- matrix(unlist(vals_right_point), ncol = 31, byrow = TRUE)
  vals_right_point <- t(vals_right_point)
  vals_right_lo = data.frame(pred_right_2)
  vals_right_lo <- matrix(unlist(vals_right_lo), ncol = 31, byrow = TRUE)
  vals_right_lo <- t(vals_right_lo)
  vals_right_hi = data.frame(pred_right_3[[1]])
  vals_right_hi <- matrix(unlist(vals_right_hi), ncol = 31, byrow = TRUE)
  vals_right_hi <- t(vals_right_hi)
  count <- 1
  num_same <- 0
  num_diff <- 0
  for(i in seq(length(vals_left_point[,1]))){
    mu_left <- sum(vals_left_point[count,])/length(vals_left_point[count,])
    mu_right <- sum(vals_right_point[count,])/length(vals_right_point[count,])
    
    sd_d = sqrt((sd(vals_left_point[count,])^2)/length(vals_left_point[count,])+
                  (sd(vals_right_point[count,])^2)/length(vals_right_point[count,]))
    
    lower_bound <- (mu_left-mu_right)-1.96*sd_d
    upper_bound <- (mu_left-mu_right)+1.96*sd_d
    
    if( lower_bound < upper_bound){
      if( lower_bound < 0 & upper_bound >0){
        print(paste('Day ',count, ' '))
        num_same <- num_same+1
      } else {
        print(paste("Day ",count," Significantly different                                         ***"))
        num_diff <- num_diff+1
        png(file=paste("./Results/",name,"/",name,"_day_",count,".png",sep=""),
            width=600,height=350)
        hist(vals_left_point[count,],main=paste("Vals on ",count," of January"))
        dev.off()
      }
    } else if (upper_bound<lower_bound){
      if( upper_bound < 0 & lower_bound > 0){
        print(paste("Day ",count," "))
        num_same <- num_same+1
      } else{
        print(paste("Day ",count," Significantly different                                         ***"))
        num_diff <- num_diff+1
        png(file=paste("./Results/",name,"/",name,"_day_",count,".png",sep=""),
            width=600,height=350)
        hist(vals_left_point[count,],main=paste("Vals on ",count," of January"))
        dev.off()
      }
    } else{
      print(paste("Day ",count," "))
      num_same <- num_same+1
    }
    print(paste("Lower: ", lower_bound, " Upper: ", upper_bound))
    print("--------------------------------------------------")
    count <- count+1
  }
  print(paste("Number of days same: ",num_same))
  print(paste("Number of days different: ", num_diff))
}
