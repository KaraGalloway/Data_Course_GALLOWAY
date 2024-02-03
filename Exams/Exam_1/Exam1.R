library(tidyverse)
library(ggplot2)

##I.####
df <- read.csv("./data/cleaned_covid_data.csv")

##II.####
A_states<- df[grepl("^A",df$Province_State),]

##III.####
ggplot(A_states, mapping = aes(x = Last_Update, y = Deaths)) + 
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) +
  facet_wrap(~ Province_State, scales = "free")

##IV.####
state_max_fatality_rate <- df %>% 
  group_by(Province_State) %>%
  summarize(Maximum_Fatality_ratio = max(Case_Fatality_Ratio, na.rm = TRUE)) %>%
  arrange(desc(Maximum_Fatality_ratio))

##V.####
state_max_fatality_rate$Province_State <- factor(state_max_fatality_rate$Province_State, levels = state_max_fatality_rate$Province_State)
ggplot(state_max_fatality_rate, mapping = aes(x = Province_State, y = Maximum_Fatality_ratio)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90))

##VI.####
us_covid_deaths <- df %>% 
  arrange(Last_Update) %>%
  group_by(Last_Update) %>%
  summarize(all_deaths = sum(Deaths))
ggplot(us_covid_deaths, mapping = aes(x = Last_Update, y = all_deaths)) +
  geom_bar(stat = "identity")
# or
ggplot(us_covid_deaths, mapping = aes(x = Last_Update, y = all_deaths)) +
  geom_point()

