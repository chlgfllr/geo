acoustic <- readr::read_delim("/Users/chloe/geo/acoustic_measures.txt", "\t")

# We want to use fixed length windows because ABXpy normalizes times but Easy ABX doesn't if I understand well?
## Get minimum constriction time to set the left edge of the window
min_constriction <- min(acoustic$constriction)
## Get average vowel duration to set the right edge of the window
mean_vowel <- mean(acoustic$`v-duration`)
qu_vowel <- as.numeric(quantile(acoustic$`v-duration`, .75))

data_item_ <- readr::read_delim("data_okay.item", " ")

data_item_$duration <- (data_item_$offset - data_item_$onset) * 1000
## Get mean duration of CV sequence
mean_dur <- mean(data_item_$duration)

## We had a mean CV window duration of mean_dur
## We will now have a shorter window of min_constriction + mean_vowel
fixed_length <- min_constriction + mean_vowel
