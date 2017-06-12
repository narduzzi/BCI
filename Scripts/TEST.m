close all;
clear all;
clc;

addpath(genpath('..\Recordings'));
recording_session = 'ah2_31032017';
user = '_simon1';

path=strcat('Recordings/',recording_session,user,'/biosemi/data',user,'.bdf');
text=strcat('Recordings/',recording_session,user,'/unity/',recording_session,'_ses_1_condition.txt');

%[easy,hard_assist,hard_noassist,features_extracted] = main_eeg(path,8,1,40,4,text);

rawsignal = path;
downfactor = 8;
low=1;
high=40;
order=4;

%%
%%Main part
%Test
disp('Loading data...')
[signal,header] = sload(rawsignal);
signal = signal';
%channel selection
signal = signal(1:64,:);

%%
disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down,signal_down] = downsampling(header,signal,downfactor);

%%
disp('Applying car...');
%signal_filtered = car(signal_filtered);
signal_down = car(signal_down);
disp('CAR done.');

%%
low = 5;
high = 40;
order= 5;
disp('Bandpass filtering...')
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%%
disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

%%
disp('Selecting electodes...')
centered_electrodes = load('25_centered_electrodes.mat');
[indices] = index_of_electrodes(centered_electrodes.label,header_down);
indices = [1:64] %should be 5,4,38

%%
disp('Feature extraction...')
window_size = 256;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header,window_size,step_size);
%%
features = features_extracted(:,3:size(features_extracted,2));
labels = features_extracted(:,1);
K = 400

[NCA_TRAIN_ERROR,NCA_TEST_ERROR] = models_evaluation(features_extracted,1000,K);

save('Results/NCA/Simon_TRAIN_ERROR_K400.mat','NCA_TRAIN_ERROR');
save('Results/NCA/Simon_TEST_ERROR_K400.mat','NCA_TEST_ERROR');

