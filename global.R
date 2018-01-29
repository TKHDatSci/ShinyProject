
library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)
library(data.table)
# library(anytime)
library(maps)
library(leaflet)
library(tidyverse)
library(sf)

# convert matrix to dataframe
state_stat <- data.frame(state.name = rownames(state.x77), state.x77)
# remove row names


rownames(state_stat) <- NULL
# create variable with colnames as choice
choice <- colnames(state_stat)[-1]



londonst.df <- fread("~/Desktop/LondonCrime/MyLondon2017Data.csv", stringsAsFactors = F)
londonst.df <- as.data.frame(londonst.df)

# londonout <-londonst.df %>% select(crime.type,longitude,latitude) %>% na.omit()
# outline <- londonout[chull(londonout$latitude, londonout$longitude), ]
# 
# londonout <- londonst.df %>%
#   select(crime.type, latitude, longitude) %>%
#   mutate(n = as.numeric(table(londonst.df$crime.type)[londonst.df$crime.type])) %>%
#   na.omit()
# 
# outline <- londonout[chull(londonout$latitude, londonout$longitude), ]


#stop and search
londonstop.df <- fread("~/Desktop/LondonCrime/londonstopandsearch.csv", stringsAsFactors = F)
londonstop.df <- as.data.frame(londonstop.df)




#remove the na  from st
londonst.df <- londonst.df%>% filter(.,!is.na(longitude))
#remove na from stop and search
londonstop.df <- londonstop.df%>% filter(.,!is.na(Longitude))# %>%summarise(.,n())



head(londonstop.df)
str(londonst.df)


#test1 <- anytime(londonst.df$Month) used for converting month column to date
#londonst.df <-londonst.df %>% mutate(mdate = as.Date(anytime(londonst.df$Month,asUTC =FALSE),"%m/%d/%Y"))
londonst.df <-londonst.df %>% mutate( rdate= as.Date(rdate))



#Lower case column names
names(londonst.df) <- tolower(names(londonst.df))
names(londonstop.df) <- tolower(names(londonstop.df))

#remove the space between columns
names(londonst.df) <- sub(" ", ".", names(londonst.df)) #run secon time in case tehre are more than one space 
names(londonst.df) <- sub(" ", ".", names(londonst.df))

#stop and serach
names(londonstop.df) <- sub(" ", ".", names(londonstop.df)) #run secon time in case tehre are more than one space 
names(londonstop.df) <- sub(" ", ".", names(londonstop.df))

# london2017<- unique(london2017)

#only include 1st quarter of 2017
london2017<- 
  londonst.df %>% filter( rdate >= as.Date("2017-01-01") & rdate < as.Date("2017-05-01") )
#max0min inputdates
maxCrimeD <-  max(london2017$rdate)
minCrimeD <-  min(london2017$rdate)

# remove the 4 digit from lsoa.name
london2017 <-london2017 %>% mutate(lsoa.name = substr(lsoa.name, 1, nchar(lsoa.name)-4))


#Data Table for Data section
londonDT <- london2017 %>% select (.,-v1,-crime.id,-lsoa.code,-context,-falls.within,-rdate)

#crime type for dropdown
crime.type <- london2017 %>% distinct(crime.type)

#regionname
region <- unique(londonDT$lsoa.name)

# barplot(londonDT[,londonDT$lsoa.name], 
#         main=londonDT$lsoa.name,
#         ylab="Number ",
#         xlab="Year")





dat <- data.frame(xx = c(runif(100,20,50),runif(100,40,80),runif(100,0,30)),yy = rep(letters[1:3],each = 100))

# #hist
# crime.type.grp <- crime.type.grp %>%mutate(crime.type = as.factor(crime.type), NumCrimeType= as.vector(NumCrimeType))
# p <- ggplot(data=crime.type.grp, aes(x=crime.type, y=NumCrimeType)) +
#   geom_bar(stat="identity", position=position_dodge(), colour="black") +
#   scale_fill_manual(values=c("#999999", "#E69F00"))
# #p


#anti-social beh has no crimeid and outcome
# london2017%>% filter(.,crime.id=="")
# london2017 %>% distinct(lsoa.name)

#londonborg <-london2017 %>% distinct(substr(lsoa.name, 1, nchar(lsoa.name)-4))

#remove na from stop and search
test <- london2017 %>% distinct(crime.id, crime.type, last.outcome.category)
# summary of crime type
crime.type.grp  <- london2017 %>% group_by(crime.type,rdate) %>% summarise(., NumCrimeType = n())

crime.type.grp %>% summarise(total = sum())

#outcome category
outcome.type <- london2017 %>% distinct(.,last.outcome.category)

outcome.type.grp  <- london2017 %>% group_by(last.outcome.category) %>% summarise(., NumOutType = n())



#   london2017 %>% distinct(reported.by)


#STOP AND SEARCH
londonstop2017 <- londonstop.df %>% filter( date >= as.Date("2017-01-01") & date < as.Date("2017-05-01") )
#outcomes
stop <-londonstop2017 %>% distinct(outcome)


stopsearch <- unique(londonstop2017)

stopsearch <- head(stopsearch,1000)


#sample set
london2017 <- head(london2017,1000)
