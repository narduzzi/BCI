Two types of codes can be found:

1) Codes for processing the signal, epoching, epoching, feature extraction, building, testing and evaluation of the models

2) Codes on the raw signal or with the ???

Small description of the codes:

1) Codes for processing the signal, epoching, epoching, feature extraction, building, testing and evaluation of the models
For each subject, a matlab script containing the whole pipeline from the signal processing to the ?? was established.

2) Codes on the raw signal or with the ???
For generating plots showing the difficulty perceived by the subjects, run the code "self_assess". 
For generating plots showing statistics on temporal aspects of the experiment, run the code "trajectory_time". 
For plotting the success rate of a subject, run the code "plotSucessRate". 
For plotting electrodes in the temporal domains, run "plotRaw".
For plotting experimental aspects as trajectory triggers on the EEG signal, run "plot1electrode". 
For plotting alpha waves, beta waves, PSD of the electrodes, run "freqanalysis". 


IMPORTANT Note: 
The data from the second session of the subject AH2 (Simon) contains a small mistake. 
In the header, in the structure containing the type of events (header.EVENT.TYP), there is 2 times the number "1" at line 150 and 152.
This is not possible since "1" indicates a new trajectory. Therefore, the first one should be changed to another value for good processing by the functions of the BCI.
You can for example replace the "1" of line 150 by "32332". 
