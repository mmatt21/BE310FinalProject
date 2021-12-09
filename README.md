# BE310FinalProject
Analysis of population vs staple crop production. 
Raw data for this project was gathered from the Organisation for Economic Co-operation and Development and came in the form of two separate data sets. 
The first contained population data organized by year, country, and gender. (PopulationData.csv)
The second contained crop yield data organized by year, country, and grain type. (CropProductionData.csv)
The data was uploaded to R Studio where Tidyverse packages were used to perform the following tidying operations
Cleaned the population data set first
  Selected only the years 1990-2020 (org. 1950-2020)
  Removed data on avg. growth and men and women populations separately
  Retained total population in millions 
  Cleaned data contained location, year, and total population with 1736 entries
Next I cleaned the crop yield data
  Selected the years 1990-2020 (org. 1990-2030)
  Extracted data on total production in thousand tons of each crop
  Removed tons per hectare and hectares planted 
  Extracted the location, time, type, and value columns into new DF
  Spread the type column containing crop type to form new columns with each crop individually, matched the value to each data point 
  Mutated to create a new column containing to sum of all the grains produced
  Cleaned data contains location, year, grain type, and total produced with 1178 entries 
At this point I was left with two separte tidy dataframes that needed to be merged. 
  Used a left join to match the population data with the crop production data, excluding non-matches 
  Cleaned this data further by removing global statistics, retaining only country specific data
Plots were done using ggplot point functions 
Additional file is my r script used to tidy data and create the plots



