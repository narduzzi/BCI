addpath(genpath('..\Recordings'));
path='Recordings/ad3_08032017/biosemi/ad3_08032017.bdf';
text='Recordings/ad3_08032017/unity/ad3_08032017_ses_1_condition.txt';
data = main_eeg(path,8,1,40,4,text);