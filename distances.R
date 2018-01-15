#/Users/chloe/abx/items/items


distances <- readr::read_delim("by_vowel_distances.txt", " ")
item <- readr::read_delim("data_new.item", " ")

item_B <- dplyr::select(distances, dplyr::ends_with("_B"))
item_B_ <- dplyr::inner_join(item_B, item, by=c(file_B="#file", onset_B="onset", offset_B="offset"))
item_B__ <- dplyr::rename_at(item_B_, names(item_B_)[!endsWith(names(item_B_), "_B")], function(x) paste0(x, "_B"))
