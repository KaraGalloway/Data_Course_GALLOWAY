library(ggplot2)
library(tidyverse)
library(modelr)
library(easystats)
library(broom)
library(fitdistrplus)

## 1 ####
mushdat <- read_csv("mushroom_growth.csv")
#heehee I like this data name

## 2 ####
glimpse(mushdat)
summary(mushdat)
names(mushdat)

#plot 1, growth rate vs light
ggplot(mushdat, aes(x = Light, y = GrowthRate, color = Species)) +
  geom_point() +
  facet_wrap(~Species)
#plot 2, growth rate vs nitrogen
ggplot(mushdat, aes(x = Nitrogen, y = GrowthRate, color = Species)) +
  geom_point() +
  facet_wrap(~Species)
#plot 3, growth rate vs temperature
ggplot(mushdat, aes(x = Temperature, y = GrowthRate, color = Species)) +
  geom_point() +
  facet_wrap(~Species)
#plot 4, growth rate vs humidity
ggplot(mushdat, aes(x = Humidity, y = GrowthRate, color = Species)) +
  geom_point() +
  facet_wrap(~Species)

## 3 ####
#model time!

#model 1, Light
mod1 = lm(GrowthRate ~ Light, data = mushdat)
summary(mod1)

#visual aid!
ggplot(mushdat, aes(x = Light, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


#model 2, Nitrogen
mod2 = lm(GrowthRate ~ Nitrogen, data = mushdat)
summary(mod2)

#visual aid!
ggplot(mushdat, aes(x = Nitrogen, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()
#very....flat....


#model 3, Temperature
mod3 = lm(GrowthRate ~ Temperature, data = mushdat)
summary(mod3)

#visual aid!
ggplot(mushdat, aes(x = Temperature, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


#model 4, Humidity
mod4 = lm(GrowthRate ~ Humidity, data = mushdat)
summary(mod4)

#visual aid!
ggplot(mushdat, aes(x = Humidity, y = GrowthRate)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()

## 4 + 5 ####
#mean square roots~~~

mean(mod1$residuals^2)
mean(mod2$residuals^2)
mean(mod3$residuals^2)
mean(mod4$residuals^2)

#they all give such high numbers but model 1 has the lowest MSE

## 6 ####

mushpred <- mushdat %>% 
  add_predictions(mod1)
mushpred %>% dplyr::select("GrowthRate","pred")

newmush = data.frame(Light = c(25, 30, 35, 40 ,45, 50))

pred = predict(mod1, newdata = newmush)

hyp_mush <- data.frame(Light = newmush$Light,
                       pred = pred)

mushpred$PredictionType <- "Real"
hyp_mush$PredictionType <- "Hypothetical"

fullmush <- full_join(mushpred,hyp_mush)
#okay these mush names are getting a little out of hand.....

## 7 ####
ggplot(fullmush, aes(x = Light, y = pred, color = PredictionType))+
  geom_point() +
  geom_point(aes(y=GrowthRate),color="brown") +
  theme_minimal()
