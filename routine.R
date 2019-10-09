  
library(dplyr)
library(tibble)
library(lubridate)

# Put some desired stations into a list

folder <- "C:/path/"  

# Create list with file names
file_list <- list.files(path=folder, pattern="*.csv") 

paste(folder, file_list[1], sep = "")

# Read files and put them together
# Using 3 stations for my place of interest
all_rain <- lapply(seq(1,3), function(i)
read.csv(paste(folder, file_list[i], sep=""),
         header=TRUE, skip=13, dec = ",", sep = ";"))
	
# check
glimpse(all_rain) 


#---------
# Organize and select necessary data

all_rain[[1]] 
names(all_rain[[1]])    

# Desired columns (date and rain)
# 1,3, 14:44
# Column names: EstacaoCodigo, Data, Chuva01:Chuva31 

# Extracting columns of interest
rain_wide <-
all_rain %>%    
lapply("[", , c(1,3,14:44))
	
# Working with one station at a time
# nome:  s01457000 (Tapirapua, Mato Grosso state, Brazil)
s01457000 <-    
rain_wide[1] %>%
as.data.frame()

# df in "long" format
s01457000 <-    
s01457000  %>%
gather(key = rainfall, value = amount, -Data, -EstacaoCodigo)   

# create date columns
s01457000 <-
s01457000 %>%
mutate(Year = year(as.Date(s01457000$Data)),      
       Month = month(as.Date(s01457000$Data))) %>%     

s01457000$rainfall <- substring(s01457000$rainfall,6,7) 

as.numeric(s01457000$rainfall)    

s01457000$Data <- as.Date(paste(s01457000$Year,
                            s01457000$Month, s01457000$rainfall, sep="-"), format="%Y-%m-%d") 
							
s01457000$Jday <- format(s01457000$Data, "%j")  

# Reorder columns positions
s01457000 <- s01457000[,c(1,2,5,6,3,7,4)]    
s01457000 <- setNames(s01457000, c("STATION", "DATE", "YEAR", "MONTH", "DAY", "JDAY", "RAIN"))  # renomear colunas

# Putting into chronological order
s01457000 %>%
s01457000 <-    
arrange (as.character(DATE)) 

# Deleting duplicated lines
s01457000 <- 
s01457000 %>%
unique() %>%
edit()

# In case you want to get rid of "NAs"
s01457000 <- na.omit(s01457000) 

# Obs: Get rid of NAs is optional and not always desirable: you may want to posteriorly fill these NAs with other data,
# so it may be good to know where they are 
