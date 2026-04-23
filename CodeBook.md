Most important variables of the final tibble (tidy_dataset):

- subject_ids (numeric), containing the ids of the subjects
- activity_codes (character), containing the activity names 
- All of the remaining variables are numeric, they are normalized and bounded 
within [-1,1], and refer to different types of measurements. The complete list of 
measurements can be found in the "features.txt" file that is attached to the downloadable file of the [Human Activity Recognition database](http://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones), 
which includes the mean and standard deviation estimates and other estimates
as well. Moreover, the "features_info.txt" file provides the relevant information 
about all those variables. For example:
  - tBodyAcc_mean_X refers to the mean body acceleration along the X-axis in the time domain.
    - t signifies a time domain signal (as opposed to f for the frequency domain)
    - BodyAcc refers to the body acceleration signal (as opposed to the gravity component, 
which is signified by GravityAcc)
    - mean refers to the mean value computed over the sliding 2.56-second window
    - X refers to the X-axis of the 3-axial measurement
