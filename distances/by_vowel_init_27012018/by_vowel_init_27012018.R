# Essai du script sur un autre data.item file 
# Deux discrimination tasks tested:
### By new/echo
### By question/answer
##### Pourquoi ? Parce que je veux savoir si les mêmes résultats chelou apparaissent ou si c'est un artefact
data_item <- readr::read_delim("data.item", " ")
distances_newecho <- readr::read_delim("distances_newecho.txt", " ")

library(gridExtra)
library(plyr)
library(ggplot2)
names(distances_newecho)[which(names(distances_newecho)=="d(A, B)")] <- "dist"

# Now what are the pairs tested? 
item_B <- dplyr::select(distances_newecho, dplyr::ends_with("_B"))
item_B_ <- dplyr::inner_join(item_B, data_item, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
item_B__ <- dplyr::rename_at(item_B_, names(item_B_)[!endsWith(names(item_B_), "_B")], function(x) paste0(x, "_B"))

item_A <- dplyr::select(distances_newecho, dplyr::ends_with("_A"))
item_A_ <- dplyr::inner_join(item_A, data_item, by=c(file_A="#file", onset_A="onset", offset_A="offset"))
item_A__ <- dplyr::rename_at(item_A_, names(item_A_)[!endsWith(names(item_A_), "_A")], function(x) paste0(x, "_A"))

# Prepare les colonnes qui m interessent dans A et B
item_B_clean <- item_B__
item_B_clean$pulm_B <- NULL
item_B_clean$vowel_B <- NULL
item_B_clean$position_B <- NULL
colnames(item_B_clean)[colnames(item_B_clean)=="speaker_B"] <- "speaker"
colnames(item_B_clean)[colnames(item_B_clean)=="question_B"] <- "question"
colnames(item_B_clean)[colnames(item_B_clean)=="new_B"] <- "new"
colnames(item_B_clean)[colnames(item_B_clean)=="place_B"] <- "place"

item_A_clean <- item_A__
item_A_clean$pulm_A <- NULL
item_A_clean$place_A <- NULL
item_A_clean$vowel_A <- NULL
item_A_clean$position_A <- NULL
item_A_clean$speaker_A <- NULL
item_A_clean$question_A <- NULL
item_A_clean$new_A <- NULL

# Selectionne le distance score
distance_score <- dplyr::select(distances_newecho, dplyr::starts_with("d"))

# Met tout dans un meme tibble
distances_better <- dplyr::bind_cols(item_A_clean, item_B_clean, distance_score)
distances_better$file_A <- NULL
distances_better$onset_A <- NULL
distances_better$offset_A <- NULL
distances_better$file_B <- NULL
distances_better$onset_B <- NULL
distances_better$offset_B <- NULL
distances_better$question <- NULL


# Save file
write.table(distances_better, "distances_better_newecho.csv", sep = ";", row.names = F, col.names = T, quote = F)

#keeping.order <- function(.data, fn, ...) { 
#   col <- ".sortColumn"
#   data[,col] <- 1:nrow(.data) 
#   out <- fn(data, ...) 
#   if (!col %in% colnames(out)) stop("Ordering column not preserved by function") 
#   out <- out[order(out[,col]),] 
#   out[,col] <- NULL 
#   out 
# } 


# Create a new table with fewer information                   
names(distances_better)[which(names(distances_better)=="#item_A")] <- "item_A"
names(distances_better)[which(names(distances_better)=="#item_B")] <- "item_B"
#how_many_repetitons_all <- ddply(.data = distances_better,.(item_A,item_B),nrow)
#how_many_repetitons_all <- keeping.order(.data = distances_better, ddply, .(item_A,item_B), mutate, v=scale(v))

# Create subsets
# speaker_column <- dplyr::select(distances_better, dplyr::starts_with("speaker"))
# phone_columns <- dplyr::select(distances_better, dplyr::starts_with("phone"))
# distance_column <- dplyr::select(distances_better, dplyr::starts_with("d"))
# newecho_column <- dplyr::select(distances_better, dplyr::starts_with("new_A"))
# question_column <- dplyr::select(distances_better, dplyr::starts_with("ques"))
#better_table_distances <- dplyr::bind_cols(how_many_repetitons_all, speaker_column, phone_columns, distance_column, newecho_column, question_column)

# Plot the results
some_plot <- ggplot2::ggplot(data=distances_better, ggplot2::aes(x=dist)) +
  ggplot2::geom_histogram() +
  ggplot2::facet_wrap(~ speaker) #, scales = 'free_y')
print(some_plot)

distances_better$glottal_A <- ifelse(grepl(">", distances_better$phone_A), "ejective", "aspirate")
distances_better$glottal_B <- ifelse(grepl(">", distances_better$phone_B), "ejective", "aspirate")
distances_better$same_value <- distances_better$glottal_A == distances_better$glottal_B
distances_better$same_value <- ifelse(distances_better$same_value == "FALSE", "contrast", "same")

# better_table_distances$contrast_tested <- better_table_distances$same_value
# better_table_distances$contrast_tested <- ifelse(better_table_distances$glottal_A == "ejective", "ejective", "aspirate")

some_other_plot <- ggplot2::ggplot(data=distances_better, ggplot2::aes(x=dist)) +
  ggplot2::geom_histogram() +
  ggplot2::geom_vline(data = distances_better, xintercept=median(distances_better$dist, color = "red")) +
  ggplot2::facet_wrap(same_value ~ speaker) #, scales = 'free_y') 
# On voit qu'il y a une difference assez evidente de distribution des resultats entre les deux speakers, mais pas forcement en fonction du contraste teste
print(some_other_plot)

new_plot <- ggplot2::ggplot(distances_better, ggplot2::aes(x = as.factor(speaker), y=dist, fill=place)) +
  ggplot2::geom_boxplot() + 
  ggplot2::facet_grid(same_value~new) +#, labeller = labeller(question = labels)) +
  ggplot2::theme_minimal() #+
  #ggplot2::scale_fill_discrete(name="Condition tested", labels=c("Ejective-Aspirate", "Ejective-Ejective,\n or Aspirate-Aspirate"))
# Grosse difference entre les speakers
print(new_plot)


#################@
# Maintenant avec le question 
distances_question <- readr::read_delim("distances_question.txt", " ")

names(distances_question)[which(names(distances_question)=="d(A, B)")] <- "dist"

# Now what are the pairs tested? 
item_B_question <- dplyr::select(distances_question, dplyr::ends_with("_B"))
item_B_question_ <- dplyr::inner_join(item_B_question, data_item, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
item_B_question__ <- dplyr::rename_at(item_B_question_, names(item_B_question_)[!endsWith(names(item_B_question_), "_B")], function(x) paste0(x, "_B"))

item_A_question <- dplyr::select(distances_question, dplyr::ends_with("_A"))
item_A_question_ <- dplyr::inner_join(item_A_question, data_item, by=c(file_A="#file", onset_A="onset", offset_A="offset"))
item_A_question__ <- dplyr::rename_at(item_A_question_, names(item_A_question_)[!endsWith(names(item_A_question_), "_A")], function(x) paste0(x, "_A"))

# Prepare les colonnes qui m interessent dans A et B
item_B_question_clean <- item_B_question__
item_B_question_clean$pulm_B <- NULL
item_B_question_clean$vowel_B <- NULL
item_B_question_clean$position_B <- NULL
colnames(item_B_question_clean)[colnames(item_B_question_clean)=="speaker_B"] <- "speaker"
colnames(item_B_question_clean)[colnames(item_B_question_clean)=="question_B"] <- "question"
colnames(item_B_question_clean)[colnames(item_B_question_clean)=="new_B"] <- "new"
colnames(item_B_question_clean)[colnames(item_B_question_clean)=="place_B"] <- "place"

item_A_question_clean <- item_A_question__
item_A_question_clean$pulm_A <- NULL
item_A_question_clean$place_A <- NULL
item_A_question_clean$vowel_A <- NULL
item_A_question_clean$position_A <- NULL
item_A_question_clean$speaker_A <- NULL
item_A_question_clean$question_A <- NULL
item_A_question_clean$new_A <- NULL

# Selectionne le distance score
distance_score_question <- dplyr::select(distances_question, dplyr::starts_with("d"))

# Met tout dans un meme tibble
distances_better_question <- dplyr::bind_cols(item_A_question_clean, item_B_question_clean, distance_score_question)
distances_better_question$file_A <- NULL
distances_better_question$onset_A <- NULL
distances_better_question$offset_A <- NULL
distances_better_question$file_B <- NULL
distances_better_question$onset_B <- NULL
distances_better_question$offset_B <- NULL
distances_better_question$new <- NULL


# Save file
write.table(distances_better_question, "distances_better_question.csv", sep = ";", row.names = F, col.names = T, quote = F)

# Create a new table with fewer information                   
names(distances_better_question)[which(names(distances_better_question)=="#item_A")] <- "item_A"
names(distances_better_question)[which(names(distances_better_question)=="#item_B")] <- "item_B"
#how_many_repetitons_all <- ddply(.data = distances_better,.(item_A,item_B),nrow)
#how_many_repetitons_all <- keeping.order(.data = distances_better, ddply, .(item_A,item_B), mutate, v=scale(v))

# Create subsets
# speaker_column <- dplyr::select(distances_better_question, dplyr::starts_with("speaker"))
# phone_columns <- dplyr::select(distances_better_question, dplyr::starts_with("phone"))
# distance_column <- dplyr::select(distances_better_question, dplyr::starts_with("d"))
# newecho_column <- dplyr::select(distances_better_question, dplyr::starts_with("new_A"))
# question_column <- dplyr::select(distances_better_question, dplyr::starts_with("ques"))
#better_table_distances <- dplyr::bind_cols(how_many_repetitons_all, speaker_column, phone_columns, distance_column, newecho_column, question_column)

# Plot the results
some_plot_question <- ggplot2::ggplot(data=distances_better_question, ggplot2::aes(x=dist)) +
  ggplot2::geom_histogram() +
  ggplot2::facet_wrap(~ speaker) #, scales = 'free_y')
print(some_plot_question)

distances_better_question$glottal_A <- ifelse(grepl(">", distances_better_question$phone_A), "ejective", "aspirate")
distances_better_question$glottal_B <- ifelse(grepl(">", distances_better_question$phone_B), "ejective", "aspirate")
distances_better_question$same_value <- distances_better_question$glottal_A == distances_better_question$glottal_B
distances_better_question$same_value <- ifelse(distances_better_question$same_value == "FALSE", "contrast", "same")

# better_table_distances$contrast_tested <- better_table_distances$same_value
# better_table_distances$contrast_tested <- ifelse(better_table_distances$glottal_A == "ejective", "ejective", "aspirate")

some_other_plot_question <- ggplot2::ggplot(data=distances_better_question, ggplot2::aes(x=dist)) +
  ggplot2::geom_histogram() +
  ggplot2::geom_vline(data = distances_better_question, xintercept=median(distances_better_question$dist, color = "red")) +
  ggplot2::facet_wrap(same_value ~ speaker) #, scales = 'free_y') 
# On voit qu'il y a une difference assez evidente de distribution des resultats entre les deux speakers, mais pas forcement en fonction du contraste teste
print(some_other_plot_question)

new_plot_question <- ggplot2::ggplot(distances_better_question, ggplot2::aes(x = as.factor(speaker), y=dist, fill=place)) +
  ggplot2::geom_boxplot() + 
  ggplot2::facet_grid(same_value~question) +#, labeller = labeller(question = labels)) +
  ggplot2::theme_minimal() #+
#ggplot2::scale_fill_discrete(name="Condition tested", labels=c("Ejective-Aspirate", "Ejective-Ejective,\n or Aspirate-Aspirate"))
# Grosse difference entre les speakers
print(new_plot_question)


grid.arrange(new_plot, new_plot_question, nrow=2)

plot_question <- ggplot2::ggplot(distances_better_question, ggplot2::aes(x = as.factor(place), y=dist, fill=same_value)) +
  ggplot2::geom_boxplot(position = "dodge") + 
  ggplot2::facet_grid(speaker~question) +#, labeller = labeller(question = labels)) +
  ggplot2::theme_minimal()
print(plot_question)
