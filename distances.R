# If needed
library(plyr)

########################################################################
# Files
distances <- readr::read_delim("by_vowel_distances_initial.txt", " ")
item <- readr::read_delim("data_initial.item", " ")

########################################################################
# Sort distances - output dis2txt file - tokens in initial position
# With distance scores
sort_dist_score <- dplyr::select(distances, dplyr::starts_with("file"))
score <- dplyr::select(distances, dplyr::starts_with("d"))
sort_dist_score <- dplyr::bind_cols(sort_dist_score, score)
sort_dist_score_ <- t(apply(sort_dist_score, 1, sort))
sort_dist_score__ <- dplyr::as_tibble(sort_dist_score_)
sort_dist_score___ <- dplyr::arrange(sort_dist_score__, V2)
# 2317 actual pairs tested 
dist_sorted_score <- unique(sort_dist_score___)

how_many_repetitons <- sort_dist_score___
how_many_repetitons <- ddply(.data = how_many_repetitons,.(V2,V3),nrow)
# Just to make sure the distance scores are matched to the right pairs
scores_unique <- dist_sorted_score
score_repetitions <- dplyr::bind_cols(how_many_repetitons, scores_unique)
# If yes: 
which_not_duplicated <- subset(score_repetitions, V1=="1")
which_not_duplicated$V21 <- NULL
which_not_duplicated$V31 <- NULL
which_not_duplicated$V1 <- NULL

# In the data, there are 2289 duplicated pairs
which_duplicated <- subset(score_repetitions, V1=="2")
which_duplicated$V21 <- NULL
which_duplicated$V31 <- NULL
which_duplicated$V1 <- NULL

# Et on a bien le nombre de paires présentes dans le tableau de base
2289*2+28

#########################################################################
# Now what are the pairs tested? 
item_B <- dplyr::select(distances, dplyr::ends_with("_B"))
item_B_ <- dplyr::inner_join(item_B, item, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
item_B__ <- dplyr::rename_at(item_B_, names(item_B_)[!endsWith(names(item_B_), "_B")], function(x) paste0(x, "_B"))

item_A <- dplyr::select(distances, dplyr::ends_with("_A"))
item_A_ <- dplyr::inner_join(item_A, item, by=c(file_A="#file", onset_A="onset", offset_A="offset"))
item_A__ <- dplyr::rename_at(item_A_, names(item_A_)[!endsWith(names(item_A_), "_A")], function(x) paste0(x, "_A"))

# Prepare les colonnes qui m interessent dans A et B
item_B_clean <- item_B__
item_B_clean$pulm_B <- NULL
item_B_clean$place_B <- NULL
item_B_clean$vowel_B <- NULL
item_B_clean$position_B <- NULL
colnames(item_B_clean)[colnames(item_B_clean)=="speaker_B"] <- "speaker"
colnames(item_B_clean)[colnames(item_B_clean)=="question_B"] <- "question"

item_A_clean <- item_A__
item_A_clean$pulm_A <- NULL
item_A_clean$place_A <- NULL
item_A_clean$vowel_A <- NULL
item_A_clean$position_A <- NULL
item_A_clean$speaker_A <- NULL
item_A_clean$question_A <- NULL

# Selectionne le distance score
distance_score <- dplyr::select(distances, dplyr::starts_with("d"))

# Met tout dans un meme tibble
distances_better <- dplyr::bind_cols(item_A_clean, item_B_clean, distance_score)
# Save file
write.table(distances_better, "distances_better.csv", sep = ";", row.names = F, col.names = T, quote = F)