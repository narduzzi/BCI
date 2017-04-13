function [data] = main(rawsignal,downfactor,low,high,order)
%This function takes EEG bdf files,extract the raw data signals with the
%header 


biosig_installer
[signal header] = sload(rawsignal);
signal = signal';

%CAR spatial filtering
signal = car(signal);

%Downsampling
downfactor = 8;
[header_down signal_down] = downsampling(header,signal,downfactor);

%Bandpass filtering
low = 1;
high = 40;
order= 5;
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%Partitining by conditions
[easy hard_assist hard_noassist] = partitioning(header_down,signal_filtered);

%Windowing
%window_size = ;
%stepsize = ;
windows_easy = split(easy,window_size,step_size);
windows_hard_assist = split(hard_noassists,window_size,step_size);
windows_hard_noassist = split(hard_noassist,window_size,step_size);

%Feature extraction...
%data = feature_extract(windows...);
end