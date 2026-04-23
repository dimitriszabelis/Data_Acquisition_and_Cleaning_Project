# Data Acquisition & Cleaning Project

This is the data acquisition and cleaning project of the "[Getting and Cleaning Data](https://www.coursera.org/learn/data-cleaning?specialization=jhu-data-science)" 
course of the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) 
from Johns Hopkins University.

## Data Source & Data Sets

Both data sets of this project are sourced from [Human Activity Recognition database](http://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones)
that resides in the UC Irvine Machine Learning Repository (see [1] for the license).

The database features data collected from the sensors (accelerometer and gyroscope) 
of the Samsung Galaxy S smartphone. It includes recordings of 30 subjects performing six 
daily activities (laying, sitting, standing, walking, walking upstairs, walking downstairs) while carrying the smartphone.

The database is randomly partitioned into two data sets. The train data set captures 
the measurements of 70% of the subjects, while the test data set captures the measurements 
of 30% of the subjects.

- X_train.txt & X_test.txt contain the measurements
- subject_train.txt & subject_test.txt contain the subject ids
- y_train.txt & y_test.txt contain the activity codes

## How the run_analysis.R Script Works

### I. Relevant Objects

Two relevant objects are created:

- col_names
        - This object holds the column names of the measurement tibbles (train_measurements/test_measurements).
        - It is created by loading "features.txt", extracting only the second column, 
        which holds the column names, and cleaning the column names.
- activities_lookup_table
        - This object will serve as the lookup table for converting from the activity codes 
        to the actual activity names.
        - It is created by reading in "activity_labels.txt".
        
### II. Creating the Tibbles & Merging

For each one of the two data sets (z = train/test) the following objects are constructed:

- z_subject_ids
        - Created by reading in subject_train.txt / subject_test.txt, and setting the column name 
        to be equal to “subject_ids”.
        - The column names of the respective objects from the two data sets must be the same 
        to then be able to bind the two tibbles.
-  z_activity_codes
        - Created by reading in y_train.txt / y_test.txt, setting the column name 
        to be equal to “activity_codes”, and replacing the activity codes with the 
        actual activity names (recode_values()).
- z_measurements
        - Created by reading in X_train.txt / X_test.txt (using read_table(col_names = col_names)),
        and selecting only the columns referring to the mean and standard deviation for each 
        measurement (select(matches("mean|std")))

After constructing these three objects for each data set, bind_cols() is used to 
combine all three tibbles for each data set into a larger tibble (train/test tibbles).

since, the column names and types are the same and the two larger tibbles only differ 
in the subject ids, bind_rows() is used to merge them into one tibble (merged) containing 
both the training and the test data sets.

### III. Creating the New Data Set & Saving

A new tibble (tidy_dataset) is created by finding the mean of each variable in "merged" 
for each activity and subject id (activity_codes, subject_ids), and then sorting by both
the activity and the subject id.

Last, write_delim() is used to write this new tibble into the "tidy_dataset.txt" file.

[1] License: 

- Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012