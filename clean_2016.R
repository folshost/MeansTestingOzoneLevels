

data_2016 = data.frame(read.csv("C:/Users/Maxwell/Documents/LSU/Classes/EXST/EXST7087/PROJECT/daily_81102_2016.csv"))

data_2016$Address <- as.character(data_2016$Address)
data_2016$Address <- lapply(data_2016$Address, function(x){substr(x, 0, 100)})
data_2016$Address <- as.character(data_2016$Address)
write.csv(data_2016, "C:/Users/Maxwell/Documents/LSU/Classes/EXST/EXST7087/PROJECT/daily_81102_2016_mod.csv", row.names = F)
