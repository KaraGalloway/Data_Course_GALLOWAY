library(ggplot2)
library(tidyverse)
Toxic_Release_Data <- read.csv("C:/Users/kpuff/DataClass/Data_Course_GALLOWAY/Utah_Toxic_Release_Spills_Inventory_2015-2018_EPA_20240206.csv")
utah_county_data <- Toxic_Release_Data[Toxic_Release_Data$X7..COUNTY == "UTAH",]

ggplot(utah_county_data, aes(x = X33..CHEMICAL)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

# On second thought... turns out this data isn't the easiest to read or work with...