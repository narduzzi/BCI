close all;
clear all;
clc;

addpath(genpath('..\Recordings'));
recording_session_train = 'ag7_24032017';
user = 'ricardo';

path=strcat('Recordings/',recording_session_train,'_',user,'1','/biosemi/data_',user,'1','.bdf');
text=strcat('Recordings/',recording_session_train,'_',user,'1','/unity/',recording_session_train,'_ses_1_condition.txt');

rawsignal = path;
downfactor = 8;
sampling_freq = 2048;
low=1;
high=40;
order=4;

%Main part
disp('Loading data...')
[signal,header] = sload(rawsignal);
signal = signal';
%channel selection
signal = signal(1:64,:);

disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down,signal_down] = downsampling(header,signal,downfactor);

disp('Applying car...');
%signal_filtered = car(signal_filtered);
signal_down = car(signal_down);
disp('CAR done.');

low = 5;
high = 40;
order= 5;
disp('Bandpass filtering...')
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

disp('Selecting electodes...')
centered_electrodes = load('25_centered_electrodes.mat');
[indices] = index_of_electrodes(centered_electrodes.label,header_down);
indices = [1:64] %should be 5,4,38

disp('Feature extraction...')
window_size = sampling_freq/downfactor;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header,window_size,step_size);
%%
[MODEL] = model_FFS(features_extracted);
%%
save('Results/FFS/Ricardo_MODEL.mat','MODEL');
