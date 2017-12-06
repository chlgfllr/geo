library(readr)

## Mise en forme du dataset
my.dataset <- read_delim("items_020.csv", ";", 
                         escape_double = FALSE, trim_ws = TRUE)
my.dataset
my.dataset$q_or_a <- substr(my.dataset$filename, 17, 17)
my.dataset$q_or_a <- as.character(my.dataset$q_or_a)
my.dataset$q_or_a[my.dataset$q_or_a == "1"] <- "q"
my.dataset$q_or_a[my.dataset$q_or_a == "2"] <- "a"