acoustic <- readr::read_delim("/Users/chloe/geo/acoustic_measures.txt", "\t")

# We want to use fixed length windows because ABXpy normalizes times but Easy ABX doesn't I think?
## Get minimum constriction time to set the left edge of the window
## Note: I substract interburst duration because constriction time is taken up to
## glottal release for ejectives and up to oral release for aspirated stops.
## As interburst=0 for aspirated stops, it won't change the aspirates' constriction
acoustic$constriction_norm <- as.numeric(acoustic$constriction - acoustic$interburst)

### Take min value because I don't want other material to interfere
min_constriction <- min(acoustic$constriction_norm)

## Get average vowel duration to set the right edge of the window
## Note: I add interburst duration for the same reason as I substracted it for
## the constriction time. 
acoustic$vowel_oral_burst <- acoustic$`v-duration` + acoustic$interburst
mean_vowel <- mean(acoustic$vowel_oral_burst)
qu1_vowel <- as.numeric(quantile(acoustic$vowel_oral_burst, .25))

data_item_ <- readr::read_delim("data_okay.item", " ")

data_item_$duration <- (data_item_$offset - data_item_$onset) * 1000
## Get mean duration of CV sequence
mean_dur <- mean(data_item_$duration)

## We had a mean CV window duration of mean_dur
## We will now have a shorter window of min_constriction + mean_vowel
fixed_mean <- min_constriction + mean_vowel
fixed_qu1 <- min_constriction + qu1_vowel

## ABXpy run on fixed length window
distances <- readr::read_delim("/Users/chloe/geo/fixed_length/data_fixed.csv", "\t")
data <- readr::read_delim("/Users/chloe/geo/fixed_length/data_fixed.item", " ")