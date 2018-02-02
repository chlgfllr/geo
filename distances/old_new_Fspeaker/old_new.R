# Compare old and new distances for the F speaker
library(plyr)
library(ggplot2)

old_distances <- readr::read_delim("/Users/chloe/abx/items/initial/distances_before.txt", " ")
old_item <- readr::read_delim("/Users/chloe/abx/items/data_initial.item", " ")
new_distances <- readr::read_delim("/Users/chloe/geo/distances/mono/initial/mono_question.txt", " ")
new_item <- readr::read_delim("/Users/chloe/geo/distances/mono/initial/data_mono.item", " ")

########
old_item_ <- subset(old_item, speaker == "she")
old_item_B <- dplyr::select(old_distances, dplyr::ends_with("_B"))
old_item_B_ <- dplyr::inner_join(old_item_B, old_item_, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
old_item_B__ <- dplyr::rename_at(old_item_B_, names(old_item_B_)[!endsWith(names(old_item_B_), "_B")], function(x) paste0(x, "_B"))
old_item_A <- dplyr::select(old_distances, dplyr::ends_with("_A"))
old_item_A_ <- dplyr::inner_join(old_item_A, old_item_, by=c(file_A="#file", onset_A="onset", offset_A="offset"))
old_item_A__ <- dplyr::rename_at(old_item_A_, names(old_item_A_)[!endsWith(names(old_item_A_), "_A")], function(x) paste0(x, "_A"))

new_item_ <- subset(new_item, speaker == "s08")
new_item_B <- dplyr::select(new_distances, dplyr::ends_with("_B"))
new_item_B_ <- dplyr::inner_join(new_item_B, new_item_, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
new_item_B__ <- dplyr::rename_at(new_item_B_, names(new_item_B_)[!endsWith(names(new_item_B_), "_B")], function(x) paste0(x, "_B"))
new_item_A <- dplyr::select(new_distances, dplyr::ends_with("_A"))
new_item_A_ <- dplyr::inner_join(new_item_A, new_item_, by=c(file_A="#file", onset_A="onset", offset_A="offset"))
new_item_A__ <- dplyr::rename_at(new_item_A_, names(new_item_A_)[!endsWith(names(new_item_A_), "_A")], function(x) paste0(x, "_A"))

# Prepare les colonnes qui m interessent dans A et B
old_item_B_clean <- old_item_B__
old_item_B_clean$pulm_B <- NULL
old_item_B_clean$place_B <- NULL
old_item_B_clean$vowel_B <- NULL
old_item_B_clean$position_B <- NULL
# old_item_B_clean$question <- NULL
colnames(old_item_B_clean)[colnames(old_item_B_clean)=="speaker_B"] <- "speaker"
colnames(old_item_B_clean)[colnames(old_item_B_clean)=="question_B"] <- "question"

old_item_A_clean <- old_item_A__
old_item_A_clean$pulm_A <- NULL
old_item_A_clean$place_A <- NULL
old_item_A_clean$vowel_A <- NULL
old_item_A_clean$position_A <- NULL
old_item_A_clean$speaker_A <- NULL
old_item_A_clean$question_A <- NULL

# Selectionne le distance score
old_distance_score <- dplyr::select(old_distances, dplyr::starts_with("d"))

# Met tout dans un meme tibble
old_distances_better <- dplyr::bind_cols(old_item_A_clean, old_item_B_clean, old_distance_score)

# Create a new table with fewer information                   
names(old_distances_better)[which(names(old_distances_better)=="#item_A")] <- "item_A"
names(old_distances_better)[which(names(old_distances_better)=="#item_B")] <- "item_B"
how_many_repetitons_all <- ddply(.data = old_distances_better,.(item_A,item_B),nrow)

# Create subsets
speaker_column <- dplyr::select(old_distances_better, dplyr::starts_with("speaker"))
phone_columns <- dplyr::select(old_distances_better, dplyr::starts_with("phone"))
distance_column <- dplyr::select(old_distances_better, dplyr::starts_with("d"))
question_column <- dplyr::select(old_distances_better, dplyr::starts_with("quest"))
better_table_distances <- dplyr::bind_cols(how_many_repetitons_all, speaker_column, phone_columns, distance_column, question_column)






# Plot the results
some_plot <- ggplot2::ggplot(data=better_table_distances, ggplot2::aes(x=dist)) +
  ggplot2::geom_histogram() +
  ggplot2::facet_wrap(~ speaker) #, scales = 'free_y')
print(some_plot)

better_table_distances$glottal_A <- ifelse(grepl(">", better_table_distances$phone_A), "ejective", "aspirate")
better_table_distances$glottal_B <- ifelse(grepl(">", better_table_distances$phone_B), "ejective", "aspirate")
better_table_distances$same_value <- better_table_distances$glottal_A == better_table_distances$glottal_B
better_table_distances$same_value <- ifelse(better_table_distances$same_value == "FALSE", "contrast", "same")

# better_table_distances$contrast_tested <- better_table_distances$same_value
# better_table_distances$contrast_tested <- ifelse(better_table_distances$glottal_A == "ejective", "ejective", "aspirate")

some_other_plot <- ggplot2::ggplot(data=better_table_distances, ggplot2::aes(x=dist)) +
  ggplot2::geom_histogram() +
  ggplot2::geom_vline(data = better_table_distances, xintercept=median(better_table_distances$dist, color = "red")) +
  ggplot2::facet_wrap(same_value ~ speaker) #, scales = 'free_y') 
# On voit qu'il y a une difference assez evidente de distribution des resultats entre les deux speakers, mais pas forcement en fonction du contraste teste
print(some_other_plot)

labels <- c(a = "Answer", q = "Question")
new_plot <- ggplot2::ggplot(better_table_distances, ggplot2::aes(x = as.factor(speaker), y=dist, fill=same_value)) +
  ggplot2::geom_boxplot() + 
  ggplot2::facet_grid(~question, labeller = labeller(question = labels)) +
  ggplot2::theme_minimal() +
  ggplot2::scale_fill_discrete(name="Condition tested", labels=c("Ejective-Aspirate", "Ejective-Ejective,\n or Aspirate-Aspirate"))
# Grosse difference entre les speakers
print(new_plot)
