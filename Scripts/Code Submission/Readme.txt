Two types of codes can be found:

1) Codes for processing the signal, epoching, epoching, feature extraction, building, testing and evaluation of the models

2) Codes on the raw signal or for the behavioral analysis

Small description of the codes:

1) Codes for processing the signal, epoching,  feature extraction, building, testing and evaluation of the models:

For each subject, a matlab script containing the whole pipeline from the signal processing to the test of the models on the second
sesssion. This can be done by running the scripts "basi_pipeline_'subject'", each subject having his own models. The processing is basically the
same only the models differ. This script takes the data from the two sessions process them and train on the first session
and test on the second. ROC curves, class errors and AUC are provided. The test with the medium condition is also performed
and the results are given as persentage classified in easy or hard. To load the data ensure that the files are located at
the right place.

The functions "model_PCA", "model_fisher" and "model_reliefF" can be used to perform cross validation on different feature selection
methods with 3 discriminant classifiers and 3 SVM classifiers, they also plot the results of the mean errors as a function of 
the features.

"scatter_plot_features" can be used to have a feature anlysis of the train set, namely the first session. It was used to
plot the features of the best subject (the one that performed the best results of the second session) 
but if the parameters are changed it can be done on any subject. It plots scatter plots of featrues, "best features" per model
with respect of electrodes or frequence. 

The code for the online session can also be found under "ndf_ah2_online_tid"

The code for the competition can be found under "competition" and takes the three best models from the second session testing, 
 trains on the first session and test on the competition data.

Note: DO NOT HESITATE TO MODIFY THE CODE TO FIT THE NAME OF YOUR FILES OR FOLDERS

2) Codes on the raw signal or for the behavioral analysis:
For generating plots showing the difficulty perceived by the subjects, run the code "self_assess". 
For generating plots showing statistics on temporal aspects of the experiment, run the code "trajectory_time". 
For plotting the success rate of a subject, run the code "plotSucessRate". 
For plotting electrodes in the temporal domains with the labels of the trajectories, run "plotRaw".
For plotting experimental aspects as trajectory triggers on the EEG signal, run "plot1electrode". 
For plotting alpha waves, beta waves, PSD of the electrodes, run "freqanalysis". 


IMPORTANT Note: 
The data from the second session of the subject AH2 (Simon) contains a small mistake. 
In the header, in the structure containing the type of events (header.EVENT.TYP), there is 2 times the number "1" at line 150 and 152.
This is not possible since "1" indicates a new trajectory. Therefore, the first one should be changed to another value for good processing by the functions of the BCI.
You can for example replace the "1" of line 150 by "32332". 
