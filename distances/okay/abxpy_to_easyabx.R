acoustic <- readr::read_delim("/Users/chloe/geo/acoustic_measures.txt", "\t")

# We want to use fixed length windows because ABXpy normalizes times but Easy ABX doesn't if I understand well?
## Get minimum constriction time to set the left edge of the window
acoustic$constriction_norm <- as.numeric(acoustic$constriction - acoustic$interburst)
### Take min value because I don't want other material to interfere
min_constriction <- min(acoustic$constriction_norm)
## Get average vowel duration to set the right edge of the window
acoustic$vowel_oral_burst <- acoustic$`v-duration` + acoustic$interburst
mean_vowel <- mean(acoustic$vowel_oral_burst)
qu3_vowel <- as.numeric(quantile(acoustic$vowel_oral_burst, .75))

data_item_ <- readr::read_delim("data_okay.item", " ")

data_item_$duration <- (data_item_$offset - data_item_$onset) * 1000
## Get mean duration of CV sequence
mean_dur <- mean(data_item_$duration)

## We had a mean CV window duration of mean_dur
## We will now have a shorter window of min_constriction + mean_vowel
fixed_length <- qu1_constriction + mean_vowel
