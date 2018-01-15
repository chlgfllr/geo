#/Users/chloe/abx/items/items

distances <- readr::read_delim("by_vowel_distances.txt", " ")
item <- readr::read_delim("data_new.item", " ")

item_B <- dplyr::select(distances, dplyr::ends_with("_B"))
item_B_ <- dplyr::inner_join(item_B, item, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
item_B__ <- dplyr::rename_at(item_B_, names(item_B_)[!endsWith(names(item_B_), "_B")], function(x) paste0(x, "_B"))

item_A <- dplyr::select(distances, dplyr::ends_with("_A"))
item_A_ <- dplyr::inner_join(item_A, item, by=c(file_A="#file", onset_A="onset", offset_A="offset"))
item_A__ <- dplyr::rename_at(item_A_, names(item_A_)[!endsWith(names(item_A_), "_A")], function(x) paste0(x, "_A"))

