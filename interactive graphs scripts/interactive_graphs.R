#load packages
install.packages("plyr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("ggExtra")
install.packages("heatmaply")
install.packages("htmlwidgets")
install.packages("dygraphs")

library(plyr)
library(lubridate)
library(ggplot2)
library(dplyr)
library(ggExtra)
library(heatmaply)
library(tidyr)
library(htmlwidgets)
library(dygraphs)
load("data/processed/bottle.RData")

# changing to numeric for filtering purposes
bottle$line <- as.numeric(bottle$line)
bottle$station <- as.numeric(bottle$station)


#filter bottle data

max_depth <- 300

bottle_filter <- bottle %>%
  subset(station <= 60) %>%
  filter(depth >= 0 & depth <= max_depth,
         line >= 76.7 & line <= 93.3)


#dygraph 

ts_mean_year <- bottle_filter %>%
  group_by(year) %>%
  summarise(mean_oxy = mean(oxygen,na.rm = TRUE))

# Filter out years with less than n stations
for (row in 1:nrow(ts_mean_year)){
  if (ts_mean_year[row, "year"] %in% yrs_under_threshold$year){
    ts_mean_year[row, "mean_oxy"] <- NaN
  }
}
ts_int<- dygraph(ts_mean_year, main = "Mean Yearly  Oxygen Levels up to 300 Meters",ylab="Oxygen (mL/L)") %>% 
  dyShading(from = 1949, to = 2020, color = "#E0DFDF")%>%
  dyRangeSelector() %>% 
  dyOptions(colors = "#8AC4D0",fillGraph = TRUE, fillAlpha = 0.8, gridLineColor = "#E0DFDF" ) %>%
  dyShading(from = 1957, to = 1958, color = "#FBEEAC")%>%
  dyShading(from = 1965, to = 1966, color = "#FBEEAC")%>%
  dyShading(from = 1972, to = 1973, color = "#FBEEAC")%>%
  dyShading(from = 1982, to = 1983, color = "#FBEEAC")%>%
  dyShading(from = 1987, to = 1988, color = "#FBEEAC")%>%
  dyShading(from = 1991, to = 1992, color = "#FBEEAC")%>%
  dyShading(from = 1997, to = 1998, color = "#FBEEAC")%>%
  dyShading(from = 2015, to = 2016, color = "#FBEEAC")%>%
  dyEvent(1957, "Strong El Niño", labelLoc = "top")%>%
  dyEvent(1965, "Strong El Niño", labelLoc = "top")%>%
  dyEvent(1972, "Strong El Niño", labelLoc = "top")%>%  
  dyEvent(1982, "Strong El Niño", labelLoc = "top")%>%  
  dyEvent(1987, "Strong El Niño", labelLoc = "top")%>% 
  dyEvent(1991, "Strong El Niño", labelLoc = "top")%>%
  dyEvent(1997, "Strong El Niño", labelLoc = "top")%>%
  dyEvent(2015, "Strong El Niño", labelLoc = "top")%>%
  dySeries(label="Mean Oxygen Level")
ts_int

htmlwidgets::saveWidget(widget = ts_int,
                        file = "ts_int.html",
                        selfcontained = TRUE)





#heat map visual ###
## Counting unique stations for each quarter
bottle_station_count <- bottle_filter %>%
  unite('station_id', line:station, remove = FALSE)

bottle_station_count <- bottle_station_count %>%
  unite('time', c(year, quarter), remove = FALSE)

bottle_station_count <- bottle_station_count %>% 
  select(c("station_id", time, oxygen)) %>% 
  na.omit()

station_number_check <- bottle_station_count %>%
  select(c("station_id","time")) %>%
  unique() %>% 
  count(time)

station_number_check

## Counting unique stations for each year
bottle_station_count <- bottle_filter %>%
  unite('station_id', line:station, remove = FALSE)

year_check_pre <- bottle_station_count %>% 
  select(c("station_id","year","oxygen")) %>%
  na.omit()

year_check <- year_check_pre %>%
  select(c("station_id","year")) %>%
  unique() %>% 
  count(year)
year_check


## Return years that have less than n stations
n <- 3
yrs_under_threshold <- data.frame(year = double())

for (row in 1:nrow(year_check)) {
  stations <- year_check[row, "n"]
  year <- year_check[row, "year"]
  
  if (stations < n){
    yrs_under_threshold <- rbind(yrs_under_threshold, year)
  }
}
yrs_under_threshold

# return quarters that have less than n stations

qts_under_threshold <- data.frame(time = character())

for (row in 1:nrow(station_number_check)) {
  stations <- station_number_check[row, "n"]
  quarter <- station_number_check[row, "time"]
  
  if (stations < n){
    qts_under_threshold <- rbind(qts_under_threshold, quarter)
  }
}
qts_under_threshold


#### Heat map visual

# mean heatmap with quarters

mean_data_quarterly <- bottle_filter %>%
  group_by(year,quarter) %>%
  summarise(mean_oxy = mean(oxygen,na.rm = TRUE))
mean_data_quarterly

quarter_obs_count<- bottle_filter %>% group_by(year,quarter)%>%count()
quarter_obs_count



add_missing_data<-data.frame("year"=c(1956,1956,1965,1967,1967,1968,1968,1970,1970,1970,1971,1971,1971,1973,1973,
                                      1973,1974,1974,1974,1976,1977,1977,1977,1978,1980,1980,1980,1981,1982,1982,
                                      1982,1991,2009,2018,2020,2020,2020),
                             "quarter"=c(3,4,4,1,4,3,4,1,2,4,2,3,4,1,2,3,1,2,3,3,1,2,3,4,1,2,3,4,2,3,4,2,2,3,2,3,4),
                             "mean_oxy"=c(NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
                                           ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,
                                           NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN))
add_missing_data

total_mean_quarterly <- rbind(add_missing_data, mean_data_quarterly) # append empty values with mean data

# filter out quarters with under 5 stations sampled
total_mean_quarterly <- total_mean_quarterly %>%
  unite('time', c(year, quarter), remove = FALSE)  # add time column
# change mean_oxy to NaN for selected times
for (row in 1:nrow(total_mean_quarterly)){
  if (total_mean_quarterly[row, "time"] %in% qts_under_threshold$time){
    total_mean_quarterly[row, "mean_oxy"] <- NaN
  }
}
total_mean_quarterly <- total_mean_quarterly[c("year", "quarter", "mean_oxy")]

total_mean_quarterly <- arrange(total_mean_quarterly, year) %>%
  mutate(quarter = recode(quarter,'2' = 'Spring','3' =  'Summer','4'='Fall','1' = 'Winter' ))


#mean heatmap quarterly with observations in hover

txt_mean_quarter<-c("Obs:124","Obs:152","Obs:192","Obs:210","Obs:507","Obs:955","Obs:603","Obs:NaN","Obs:820","Obs:851",
       "Obs:959","Obs:778","Obs:1535","Obs:1353","Obs:991","Obs:589","Obs:1907","Obs:2445","Obs:1877","Obs:1132",
       "Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:858","Obs:721","Obs:1227","Obs:NaN","Obs:NaN",
       "Obs:354","Obs:845","Obs:45","Obs:426","Obs:555","Obs:618","Obs:747","Obs:675","Obs:1262","Obs:1465",
       "Obs:1825","Obs:1521","Obs:1554","Obs:1766","Obs:1978","Obs:1411","Obs:656","Obs:340","Obs:512","Obs:705",
       "Obs:277","Obs:397","Obs:560","Obs:301","Obs:237","Obs:516","Obs:409","Obs:426","Obs:341","Obs:338",
       "Obs:1315","Obs:1072","Obs:129","Obs:266","Obs:NaN","Obs:708","Obs:562","Obs:349","Obs:430","Obs:119",
       "Obs:716","Obs:871","Obs:NaN","Obs:NaN","Obs:420","Obs:NaN","Obs:NaN","Obs:NaN",
       "Obs:574","Obs:595","Obs:1306","Obs:877","Obs:1177","Obs:1392","Obs:NaN","Obs:NaN","Obs:NaN",
       "Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:1649","Obs:NaN","Obs:255","Obs:NaN","Obs:NaN",
       "Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:1113","Obs:1704","Obs:1541",
       "Obs:1393","Obs:1471","Obs:NaN","Obs:492","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:427",
       "Obs:NaN","Obs:1340","Obs:1128","Obs:1073","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:1265",
       "Obs:NaN","Obs:NaN","Obs:NaN","Obs:NaN","Obs:312","Obs:425","Obs:624","Obs:649","Obs:822","Obs:2473","Obs:2153","Obs:1113","Obs:1137",
       "Obs:777","Obs:966","Obs:834","Obs:834","Obs:1079","Obs:819","Obs:833","Obs:988","Obs:958","Obs:941",
       "Obs:934","Obs:945","Obs:825","Obs:959","Obs:2401","Obs:974","Obs:895","Obs:867","Obs:1079","Obs:857",
       "Obs:866","Obs:777","Obs:900","Obs:895","Obs:NaN","Obs:1659","Obs:1117","Obs:559","Obs:880","Obs:886",
       "Obs:1102","Obs:611","Obs:1067","Obs:702","Obs:781","Obs:781","Obs:1306","Obs:297","Obs:827","Obs:743",
       "Obs:800","Obs:826","Obs:793","Obs:842","Obs:791","Obs:803","Obs:838","Obs:1192","Obs:810","Obs:830",
       "Obs:1388","Obs:371","Obs:1096","Obs:1245","Obs:1932","Obs:706","Obs:761","Obs:804","Obs:814","Obs:835",
       "Obs:816","Obs:984","Obs:602","Obs:814","Obs:778","Obs:802","Obs:810","Obs:833","Obs:988","Obs:564",
       "Obs:821","Obs:816","Obs:785","Obs:1084","Obs:791","Obs:761","Obs:1313","Obs:251","Obs:813","Obs:824",
       "Obs:840","Obs:851","Obs:867","Obs:835","Obs:824","Obs: 881","Obs:861","Obs:889","Obs:1086","Obs:710",
       "Obs:595","Obs:789","Obs:1188:","Obs:428","Obs:867","Obs:837","Obs:NaN","Obs:1647","Obs:845","Obs:832",
       "Obs:828","Obs:581","Obs:1009","Obs:715","Obs:823","Obs:746","Obs:797","Obs:812","Obs:1285","Obs:308",
       "Obs:821","Obs:810","Obs:807","Obs:834","Obs:812","Obs:907","Obs:458","Obs:728","Obs:822","Obs:827",
       "Obs:809","Obs:796","Obs:795","Obs:826","Obs:860","Obs:853","Obs:746","Obs:848","Obs:1040","Obs:611",
       "Obs:801","Obs:821","Obs:NaN","Obs:579","Obs:1647","Obs:818","Obs:419","Obs:802","Obs:836","Obs:799",
       "Obs:NaN","Obs:NaN","Obs:NaN","Obs:809")

m <- list(
  l = 50,
  r = 50,
  b = 100,
  t = 100,
  pad = 4
)

yform <- list(categoryorder = "array",
              categoryarray = c( "Winter",
                                 "Fall",
                                 "Summer",
                                 "Spring"
                                 ))

mycols <- c("#28527A","#8AC4D0","#F4D160","#FBEEAC")
na_vals<-c("#E0DFDF")
mean_heatmap_quarterly2 <- plot_ly(x = total_mean_quarterly$year, 
                                   y = total_mean_quarterly$quarter,
                                   z = total_mean_quarterly$mean_oxy, 
                                   text=txt_mean_quarter,
                                   type = "heatmap",
                                   colors = mycols,
                                   reversescale = T, 
                                   hovertemplate= "Year:%{x} <br> Quarter: %{y} <br> Mean Oxygen Level: %{z} mL/L <br> %{text} <extra></extra>") %>%
  layout(title = paste("Mean Quarterly Oxygen Levels up to", max_depth, "meters <br> Data from Core CalCOFI stations"),
         yaxis = yform, 
         plot_bgcolor = na_vals, margin=m,
         legend=list(title=list(text='Oxygen Level(mL/L)')))
  


mean_heatmap_quarterly2


htmlwidgets::saveWidget(widget = mean_heatmap_quarterly2,
                        file = "mean_quarter_heatmap.html",
                        selfcontained = TRUE)



# test to make sure values displayed are correct
test_ox_data<- bottle_filter %>% filter(year== 2000) %>% select(c("oxygen"))%>%na.omit()
ox_sum<-sum(test_ox_data$oxygen,na.rm = TRUE)
ox_sum/nrow(test_ox_data)


