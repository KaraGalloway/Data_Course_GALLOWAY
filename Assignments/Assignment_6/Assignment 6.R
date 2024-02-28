library(tidyverse)
library(gganimate)
library(ggplot2)
install.packages("transformr")
library(transformr)

dat = read_csv("./BioLog_Plate_Data.csv")
names(dat)

Water <- dat %>% 
  filter(grepl("Clear_Creek", `Sample ID`)| grepl("Waste_Water",`Sample ID`))
Dirt <- dat %>% 
  filter(grepl("Soil", `Sample ID`))

Water$Sample_Type <- "Water"
Dirt$Sample_Type <- "Dirt"

full <- rbind(Water,Dirt)
full_long <- full %>% 
  pivot_longer(cols = starts_with("Hr"),names_to = "Time", values_to = "Absorbance", names_prefix = "Hr_")

filtered_dat <- full_long %>% 
  filter(Dilution == 0.001) %>% 
  drop_na() %>% 
  mutate(Time = as.numeric(gsub("Hr_", "", Time)))

dat_plot <- ggplot(filtered_dat, aes(x = Time, y = Absorbance, color = Sample_Type, group = Sample_Type))+
  geom_line(aes(group = Time),position = position_jitter(w = .1, h = 0)) +
  geom_smooth(method = 'loess',se = FALSE) +
  facet_wrap(~ Substrate)

print(dat_plot)

acid_data <- full_long %>% 
  filter(Substrate == 'Itaconic Acid') %>% 
  group_by(Dilution, Time, `Sample ID`) %>% 
  summarize(Absorbance_mean = mean(Absorbance, na.rm = TRUE))

acid_data$Time <- factor(acid_data$Time, levels = c("24", "48", "144"))
acid_data$Time <- as.numeric(acid_data$Time)

animated_plot <- ggplot(acid_data, aes(x = Time, y = Absorbance_mean,color = `Sample ID`, group = `Sample ID`)) +
  geom_line() +
  transition_reveal(Time) +
  facet_wrap(~ Dilution)

animate(animated_plot)
