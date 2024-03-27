library(tidyverse)
library(modelr)
library(easystats)
library(GGally)

grad <- read_csv("GradSchool_Admissions.csv")
names(grad)

grad <- grad %>% 
  mutate(admit = factor(admit,levels = c(0,1), labels = c("Failure","Success")))

grad %>% 
  select(admit,gre,gpa,rank) %>% 
  ggpairs(aes(color=admit))

#They look a lot more similar than I expected...
#the biggest difference looks like rank

grad %>% 
  ggplot(aes(x = gpa, color = admit)) +
  geom_density() +
  facet_wrap(~admit) +
  theme_minimal()

#it looks like the gpa distribution for admits is higher than
#the distribution for non admits

grad %>% 
  ggplot(aes(x = gre, color = admit)) +
  geom_density() +
  facet_wrap(~admit) +
  theme_minimal()

#same thing with gre

grad %>% 
  ggplot(aes(x = rank, color = admit)) +
  geom_density() +
  facet_wrap(~admit) +
  theme_minimal()

#the failures are kind of everywhere with rank but admits
#with rank 1 and 2 are the most common

ggpubr::ggqqplot(grad$gpa)

#makes sense because you can only get up to a 4.0

#now lets try to make some models!

grad <- read_csv("GradSchool_Admissions.csv")

mod1 <- glm(data = grad,
            formula = admit~gpa, family = binomial)
mod2 <- glm(data = grad,
            formula = admit~gre, family = binomial)
mod3 <- glm(data = grad,
            formula = admit~rank, family = binomial)
mod4 <- glm(data = grad,
            formula = admit~gpa*gre*rank, family = binomial)
#compare!

comps <- compare_performance(mod1,mod2,mod3,mod4,
                             rank = TRUE)
comps

#mod4 did the best

comps %>% plot()

#yeah definitely mod4

#let's look at some predictions


grad$pred_mod1 <- predict(mod1, newdata = grad, type = "response")
grad$pred_mod2 <- predict(mod2, newdata = grad, type = "response")
grad$pred_mod3 <- predict(mod3, newdata = grad, type = "response")
grad$pred_mod4 <- predict(mod4, newdata = grad, type = "response")

grad_preds <- grad %>%
  mutate(
    pred_mod1 = predict(mod1, newdata = ., type = "response"),
    pred_mod2 = predict(mod2, newdata = ., type = "response"),
    pred_mod3 = predict(mod3, newdata = ., type = "response"),
    pred_mod4 = predict(mod4, newdata = ., type = "response")
  ) %>%
  pivot_longer(cols = starts_with("pred_mod"), names_to = "model", values_to = "pred")


ggplot(grad_preds, aes(x = admit, y = pred, color = model)) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_segment(aes(x = 0, y = 0, xend = 1, yend = 1), linetype = 2, color = "black", alpha = 0.5) +
  theme_minimal() +
  scale_color_bluebrown()

#hmm looks like they're all pretty off...

