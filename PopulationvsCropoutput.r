#Installs and loads necessary data manipulation programs 
install.packages("tidyverse")
library(tidyverse)

#attempted to merge data set before cleaning each one separately, it was a mess 
PopVsYield <- Population %>% left_join(DP_LIVE_27112021025158158, by = "TIME")
remove(PopVsYield)

#Filtered the population down to fit the years 1990-2020
ShortPop <- filter(Population, TIME >= 1990)
#Removed data on men and women separately, retained total pop.
ShortPop <- filter(ShortPop, SUBJECT == "TOT")
#Removed avg. growth from data, retained million persons variable
PopinMill <- filter(ShortPop, MEASURE == "MLN_PER")
#changed variable name Value to population_mil
PopinMill <- rename(PopinMill, "population_mil" = Value)
#Used subset to select only the variables LOCATION, TIME, and population_mil
CleanedPop <- subset(PopinMill, select = c(LOCATION, TIME, population_mil))                

#Used to trim TIME to 1990-2020
ShortCrop <- filter(DP_LIVE_27112021025158158, TIME <= 2020)

#The following commented out code was me trimming out tons per hectare
#and trying to find meaningfull data, I decided to go another direction.
#ShortCropTH <- filter(ShortCrop, MEASURE == "TONNE_HA" )
#ShortCropTH <- rename(ShortCropTH, "CropProd_TonPerHectare" = Value)
#CleanedCrop <- subset(ShortCropTH, select = c(LOCATION, SUBJECT, TIME, CropProd_TonPerHectare))
#CalcTotalCrop <- CleanedCrop %>%
 # group_by(LOCATION, TIME )
#CalcTotalCrop2 <- CalcTotalCrop %>% 
 # group_by(TIME)
#CalcTotalCrop2 <- CalcTotalCrop %>%
 # group_by( TIME )
#CalcTotalCrop2 <- ungroup(CalcTotalCrop2)
#CalcTotalCrop2 %>%
 # group_by("TIME")

#Extracts the value of each crop grown in thousands of tons
ShortCropTon <- filter(ShortCrop, MEASURE == "THND_TONNE")
#Uses subset to extract variables LOCATION, SUBJECT, TIME, and Value
CleanedTon <- subset(ShortCropTon, select = c(LOCATION, SUBJECT, TIME, Value))
#Renames Value variable as CropProd_ThndTon
CleanedTon <- rename(CleanedTon, "CropProd_ThndTon" = Value)
#Used to group data by location, not sure if necessary
GroupedTon <- CleanedTon %>%
  group_by(LOCATION)
#Spreads the variables in SUBJECT which are RICE, WHEAT, SOYBEANS, and MAIZE
#and preserves the value in CropProd_ThndTon
GroupedTon <- CleanedTon %>%
  spread(key = SUBJECT, value = CropProd_ThndTon)
#Creates a new column with the total amount of crops produces in each country
SumTon <- GroupedTon %>%
  mutate(TotalGrainProd = RICE + WHEAT + SOYBEAN + MAIZE)
#Joins population and crop production data into one data frame
JoinedData <- SumTon %>%
  left_join(CleanedPop, by = c("LOCATION", "TIME"))
#Renames JoinedData to FinalData
FinalData <- JoinedData
#Following slices remove global, OES, and BRICS data 
FinalData2 <- slice(FinalData, -c(1117:1147) )
FinalData3 <- slice(FinalData2, -c(775:745))
CountriesFinal <- slice(FinalData3, -c(94:124))

ggplot(CountriesFinal) +
  geom_line(mapping = aes(x = population_mil, y = TotalGrainProd), color = "blue")

ggplot(CountriesFinal) +
  geom_point(mapping = aes(x = population_mil, y = TotalGrainProd, color = LOCATION, alpha = .5 ))

