function [ features_extracted ] = process_session1( signal_down,header_down)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%channel selection
signal2 = signal1(1:64,:);

downfactor = 8;
sampling_freq = 2048;
low=1;
high=40;
order=5;
disp('Bandpass filtering...')
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

disp('Selecting electodes...')
centered_electrodes = load('25_centered_electrodes.mat');
[indices] = index_of_electrodes(centered_electrodes.label,header_down);
indices = [1:64] %should be 5,4,38

disp('Feature extraction Sess1...')
window_size = sampling_freq/downfactor;
step_size = window_size/2;
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header,window_size,step_size);

end