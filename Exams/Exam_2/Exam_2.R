library(tidyverse)
library(ggplot2)
library(gganimate)
library(MASS)
library(easystats)
library(ggpubr)
library(MASS)
library(easystats)

setwd("//Users//kpuff//DataClass//Data_Course_GALLOWAY//Exams//Exam_2")
#1
dat <- read_csv(".//unicef-u5mr.csv")
names(dat)

#2
tidy_dat <- dat %>% 
  pivot_longer(cols = starts_with("U5MR"),names_to = "Year", values_to = "Mortality Rate", names_prefix = "U5MR") %>% 
  drop_na() %>% 
  mutate(Year = as.numeric(str_extract(Year, "\\d+")))

names(tidy_dat)

#3/4
plot_1 <- ggplot(tidy_dat, aes(x = Year, y = `Mortality Rate`, group = CountryName))+
  geom_line() +
  facet_wrap(~ Continent)

print(plot_1)

#5/6
sum_dat <- tidy_dat %>% 
  group_by(Continent, Year) %>% 
  summarize(Mortality_mean = mean(`Mortality Rate`, na.rm = TRUE))

plot_2 <- ggplot(sum_dat, aes(x = Year, y = Mortality_mean, group = Continent, color = Continent))+
  geom_line()

print(plot_2)

tidy_dat$Continent <- as.character(tidy_dat$Continent)

#7 
mod1 <- glm(data = tidy_dat, formula = `Mortality Rate` ~ Year)
mod2 <- glm(data = tidy_dat, formula = `Mortality Rate` ~ Year + Continent)
mod3 <- glm(data = tidy_dat, formula = `Mortality Rate` ~ Year * Continent)

#8
compare_models(mod1,mod2,mod3)
compare_performance(mod1,mod2,mod3)
# I think mod 2 is the best! Lowest R^2 value

#9
tidy_dat$Continent <- as.factor(tidy_dat$Continent)
tidy_dat$mod2pred <- predict(mod2, tidy_dat)
tidy_dat$mod1pred <- predict(mod1, tidy_dat)
tidy_dat$mod3pred <- predict(mod3, tidy_dat)

tidy_dat_pivot <- tidy_dat %>% 
  pivot_longer(cols = starts_with("mod"),names_to = "Model", values_to = "ModelNum", names_prefix = "mod") %>% 
  drop_na()

#mod1
mod1plot <- ggplot(tidy_dat, aes(x = Year, y = `Mortality Rate`)) +
  #geom_smooth(method = 'glm',se = FALSE)
  geom_line(aes(y = mod1pred))
#mod2
mod2plot <- ggplot(tidy_dat, aes(x = Year, y = `Mortality Rate`, color = Continent, group = Continent)) +
  #geom_smooth(method = 'glm', formula = y ~ x, se = FALSE)
  geom_line(aes(y = mod2pred))
#mod3
mod3plot <- ggplot(tidy_dat, aes(x = Year, y = `Mortality Rate`, color = Continent, group = Continent)) +
  #geom_smooth(method = 'glm',formula = y ~ x, se = FALSE)
  geom_line(aes(y = mod3pred))

ggplot(tidy_dat_pivot, aes(x = Year, y = ModelNum, color = Continent)) +
  geom_line(aes(y = ModelNum)) +
  facet_wrap(~Model, labeller = labeller(Model = c("1pred" = "Mod 1",
                                        "2pred" = "Mod 2",
                                        "3pred" = "Mod 3")))
