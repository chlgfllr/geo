library(readr)
<<<<<<< HEAD
library(ggplot2)
library(dplyr) 
=======
>>>>>>> 9a21c1804aec4b6ccc0731c03797663af7a4d75b

## Mise en forme du dataset
my.dataset <- read_delim("items_020.csv", ";", 
                         escape_double = FALSE, trim_ws = TRUE)
my.dataset
<<<<<<< HEAD

## Creation d'une colonne pour la variable question or answer
my.dataset$q_or_a <- substr(my.dataset$filename, 17, 17)
my.dataset$q_or_a <- as.character(my.dataset$q_or_a)
my.dataset$q_or_a[my.dataset$q_or_a == "1"] <- "q"
my.dataset$q_or_a[my.dataset$q_or_a == "2"] <- "a"

## Modification de la colonne glottalization
my.dataset$glottalization[my.dataset$glottalization == "-1"] <- "1"

## Creation d'une colonne ratio de glottalization
my.dataset$ratio_glo <- my.dataset$vot / my.dataset$duration_v
my.dataset$ratio_glo[my.dataset$ratio_glo > 1] <- "1"


my.data <- filter(my.dataset, q_or_a=="1", following_v !="o", following_v !="u")
attach(my.data)

plot.question <- ggplot(my.data, aes(glottalization)) +
  geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat="count") + scale_y_continuous(labels=scales::percent) +
  labs(y="relative frequencies", fill= my.data$glottalization, title = "Question context") + 
  facet_grid(following_v~position_wd*speaker)
plot.question
=======
my.dataset$q_or_a <- substr(my.dataset$filename, 17, 17)
my.dataset$q_or_a <- as.character(my.dataset$q_or_a)
my.dataset$q_or_a[my.dataset$q_or_a == "1"] <- "q"
my.dataset$q_or_a[my.dataset$q_or_a == "2"] <- "a"
>>>>>>> 9a21c1804aec4b6ccc0731c03797663af7a4d75b
