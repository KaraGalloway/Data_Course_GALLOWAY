library(tidyverse)
library(ggplot2)


dat <- read.csv("Utah_Religions_by_County.csv")

dat_tidy <- dat %>% 
  pivot_longer(cols = -c(County, Pop_2010), names_to = "Religion", values_to = "Proportion") %>% 
  drop_na()

# I wonder where Utah's population is spread
ggplot(dat_tidy, aes(x = County, y = Pop_2010)) +
  geom_point() +
  labs(title = "Pop Distribution By County") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
  theme_minimal()
# Looks like Salt Lake County has the highest pop... checks out!

# What about the religion spread?
dat_relig_mean <- dat_tidy %>% 
  group_by(Religion) %>% 
  summarize(mean_proportion = mean(Proportion))

ggplot(dat_relig_mean, aes(x = Religion, y = mean_proportion)) +
  geom_bar(stat = "identity") +
  labs(title = "Religion Proportion") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
# Looks like a lot of LDS and a lot of people who are religious.., also checks out 

# I want to make a stacked bar graph to see what religions are the most popular in each county
# Let's see if I can figure this out

ggplot(dat_tidy, aes(x = County, y = Proportion, fill = Religion)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Okay too many counties let's try maybe 5 big counties
mycounties <- c("Salt Lake County", "Davis County", "Weber County", "Kane County", "Utah County")

# Also the religious / non religious numbers mask the different specific religions so let's take those out
dat_mycounties <- dat_tidy %>% 
  filter(County %in% mycounties) %>% 
  filter(!Religion %in% c("Non.Religious","Religious"))

ggplot(dat_mycounties, aes(x = County, y = Proportion, fill = Religion)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Much better

# Proportion of religious to non religious people in each county?
dat_nonrelig_relig <- dat_tidy %>% 
  filter(Religion %in% c("Non.Religious", "Religious"))

ggplot(dat_nonrelig_relig, aes(x = Religion, y = Proportion)) +
  geom_bar(stat = "identity") +
  facet_wrap(~County) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
# Wow, not a single county in Utah has more non-religious people than religious

# Okay now for the actual questions
# Relation between population and proportion of religions

ggplot(dat_tidy, aes(x = Pop_2010, y = Proportion)) +
  geom_point() +
  facet_wrap(~Religion, scales = "free_y") +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Population vs Proportion of Religions")
# Looks like for a few of them it seems to be related; Muslim for example

# Relation between nonreligious population and proportion of religions

dat_nonrelig <- dat_tidy %>%
  filter(Religion == "Non.Religious")

# So to be honest I used chat GPT to help me with this one and I don't really understand the plot....
# Looks like it doesn't correlate?
ggplot(dat_tidy, aes(x = Religion, y = Proportion)) +
  geom_point(data = dat_nonrelig, aes(color = "Non.Religious")) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~Religion, scales = "free_y") +
  labs(title = "Proportion of Each Religion vs Proportion of Non-Religious")

# I wonder if I can do it with just one other religion?
dat_lds <- dat_tidy %>% 
  filter(Religion %in% c("LDS","Non.Religious"))

ggplot(dat_lds, aes(x = Religion, y = Proportion)) +
  geom_bar(stat = "identity") +
  facet_wrap(~County) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Hmm the plot above is interesting but it doesn't quite show correlation
# Let's try something else?

ggplot(dat, aes(x = Non.Religious , y = LDS)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Looks like, at least for the most part, the more LDS people there are 
# the fewer non religious people there are in a county

# Let's try something else to get all the religions involved
dat_tidy_ro <- dat %>% #ro = religion only
  pivot_longer(cols = -c(County, Pop_2010, Religious, Non.Religious), names_to = "Religion", values_to = "Proportion") %>% 
  drop_na()

ggplot(dat_tidy_ro, aes(x = Non.Religious , y = Proportion, color = Religion)) +
  geom_point() +
  facet_wrap(~County) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Hey this kind of worked! It definitely looks like the LDS proportion is
# related to the non religious proportion in a county

ggplot(dat_tidy_ro, aes(x = Non.Religious , y = Proportion, color = Religion)) +
  geom_point() +
  #facet_wrap(~County) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# I kind of like it better without the facets
# Makes it easier to see the correlation between the LDS population (negative line)
# compared to the other religions (more random looking)