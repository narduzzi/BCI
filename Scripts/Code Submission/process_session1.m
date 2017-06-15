function [ features_extracted ] = process_session1( signal_down,header_down,text)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
signal_down = signal_down(1:64,:);


downfactor = 8;
sampling_freq = 2048;
low=1;
high=40;
order=5;
disp('Bandpass filtering...')
Fs = sampling_freq/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

indices = [1:64];

disp('Feature extraction Sess1...')
window_size = sampling_freq/downfactor;
step_size = window_size/2;
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header_down,window_size,step_size);

end