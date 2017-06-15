close all;
clear all;
clc;

%This script compute average for each conditions over time for a specific
%subject

%load data
addpath(genpath('..\Recordings'));
recording_session = 'ag7_24032017';
user = '_ricardo1';
load('chanlocs.mat');
loc_mat=chanlocs;
path=strcat('Recordings/',recording_session,user,'/biosemi/data',user,'.bdf');
text=strcat('Recordings/',recording_session,user,'/unity/',recording_session,'_ses_1_condition.txt');

rawsignal = path;
downfactor = 8;
low=1;
high=40;
order=4;

%%
%%Main part
%Test
disp('Loading data...')
[signal,header] = sload('data_ricardo1.bdf');
signal = signal'; 
%channel selection
signal = signal(1:64,:);

%%CAR
disp('Applying car...');
signal = car(signal);
disp('CAR done.');
%%downsampling
downfactor = 8;
disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down,signal_down] = downsampling(header,signal,downfactor);
%to change to get alpha (7.5 to 12.5 Hz) or beta (13 to 30 Hz) waves
low = 13;
high = 30;
order= 5;
%bandpass filtering
disp('Bandpass filtering...')
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%%Partionioning filtering to get data seperated between each conditions
disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);
window_size = 200;
step_size = window_size/2;

splitted_easy = split(easy,window_size,step_size);
splitted_hard_assist = split(hard_assist,window_size,step_size);
splitted_hard_noassist = split(hard_noassist,window_size,step_size);

%mean of each conditions over time
mean_easy=mean(splitted_easy');
mean_hard_assist=mean(splitted_hard_assist');
mean_hard_noassist=mean(splitted_hard_noassist');

%topoplot for each conditions
figure();
topoplot(mean_easy,loc_mat,'conv','on');

figure();
topoplot(mean_hard_assist,loc_mat,'conv','on');

figure();
topoplot(mean_hard_noassist,loc_mat,'conv','on');
%save matrix for grand average over subjects (test_topoplot.m)
save('topoplot_ricardo3','mean_easy','mean_hard_assist','mean_hard_noassist');