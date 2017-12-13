library(readr)
library(ggplot2)
library(dplyr) 

## Mise en forme du dataset
my.dataset <- read.csv("items_020.csv", ";", 
                       stringsAsFactors = F,
                       header = T
                       )
my.dataset


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
my.dataset$ratio_glo <- substr(my.dataset$ratio_glo, 1, 6)

## Creation d'une colonne question or answer
my.dataset$q_or_a <- substr(my.dataset$filename, 17, 17)
my.dataset$q_or_a <- as.character(my.dataset$q_or_a)
my.dataset$q_or_a[my.dataset$q_or_a == "1"] <- "q"
my.dataset$q_or_a[my.dataset$q_or_a == "2"] <- "a"

## Save the modified dataset as a csv file
write.table(my.dataset, "modified_items_020.csv", sep = ",")



########################
## Modification of the data_not_invisible.item file
data.item <- read.table("data_not_invisible.item", sep = "", header = T, comment.char = "@")
## Creation d'une colonne pour la variable question or answer
data.item$question <- substr(data.item$X.file, 17, 17)
data.item$question <- as.character(data.item$question)
data.item$question[data.item$question == "1"] <- "q"
data.item$question[data.item$question == "2"] <- "a"
data.item
write.table(data.item, "data_new.item", sep = " ", row.names = F, quote = F)
