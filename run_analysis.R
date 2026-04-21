library(tidyverse)
library(here)
#------------------------------------------------------------------------------#
# I. Relevant Objects

column_names <- 
        read_table(here("uci_har_dataset", "features.txt"), 
                           col_names = F) |> 
        pull(2) |> 
        str_replace_all(c("\\(\\)"="",","="_","[()]"="_","-"="_"))
column_names <- make.unique(column_names, sep = "_")

activities_lookup_table <- 
        read_table(here("uci_har_dataset", "activity_labels.txt"), 
                   col_names = c("code", "activity")) |>
        mutate(activity = str_to_lower(activity))
#------------------------------------------------------------------------------#
# II. Creating the Tibbles & Merging

# A. Train Data Set

train_subject_ids <- 
        read_table(here("uci_har_dataset", "train", "subject_train.txt"), 
                   col_names = "subject_ids")

train_activity_codes <- 
        read_table(here("uci_har_dataset", "train", "y_train.txt"), 
                   col_names = "activity_codes") |> 
        mutate(
                activity_codes = activity_codes |> 
                        recode_values(
                                from = activities_lookup_table$code,
                                to = activities_lookup_table$activity	
                        )
        )

train_measurements <- 
        read_table(here("uci_har_dataset", "train", "X_train.txt"), 
                   col_names = column_names) |> 
        select(matches("mean|std"))

train <- bind_cols(train_subject_ids, train_activity_codes, train_measurements)

# B. Test Data Set

test_subject_ids <- 
        read_table(here("uci_har_dataset", "test", "subject_test.txt"), 
                   col_names = "subject_ids")

test_activity_codes <- 
        read_table(here("uci_har_dataset", "test", "y_test.txt"), 
                   col_names = "activity_codes") |> 
        mutate(
                activity_codes = activity_codes |> 
                        recode_values(
                                from = activities_lookup_table$code,
                                to = activities_lookup_table$activity	
                        )
        )

test_measurements <- 
        read_table(here("uci_har_dataset", "test", "X_test.txt"), 
                   col_names = column_names) |> 
        select(matches("mean|std"))

test <- bind_cols(test_subject_ids, test_activity_codes, test_measurements)

# C. Merging

merged <- bind_rows(train,test)
summarise_column_names <- names(merged)[-c(1,2)]
#------------------------------------------------------------------------------#
# III. Creating the New Data Set & Saving

tidy_dataset <- merged |> 
        group_by(subject_ids, activity_codes) |> 
        summarise(across(all_of(summarise_column_names),mean), .groups="drop") |> 
        arrange(subject_ids, activity_codes)

write_delim(tidy_dataset, "tidy_dataset.txt", delim = " ")
#------------------------------------------------------------------------------#