function [ features_extracted ] = process_session2( signal_down,header_down)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%%
%Processing Second session
signal_down = signal_down(1:64,:);

%Band pass filtering
disp('Bandpass filtering second session...')
downfactor = 8;
sampling_freq = 2048;
low=1;
high=40;
order=5;
Fs = sampling_freq/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%Partitioning
disp('Partitioning second session...')
[easy,medium,hard] = partitioning_testsession(header_down,signal_filtered);
indices = [1:64];

%%
disp('Feature extraction second session...')
window_size = sampling_freq/downfactor;
step_size = window_size/2;
features_extracted = features_extraction(easy(indices,:),hard(indices,:),-1,header_down,window_size,step_size);
%features_extracted = features_extraction(easy(indices,:),hard(indices,:),medium(indices,:),header_down,window_size,step_size);

end

