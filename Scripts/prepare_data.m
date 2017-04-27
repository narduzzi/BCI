clear all
clc

data={'data_loic1','data_omar1','data_ricardo1','data_simon1'};

for i=1:length(data)
%biosig_installer
rawsignal=strcat(data{i},'.bdf');
[signal,header] = sload(rawsignal);
signal = signal';

%CAR spatial filtering
signal = car(signal);
%Downsampling
downfactor = 8;
[header_down,signal_down] = downsampling(header,signal,downfactor);
filename=strcat(data{i},'.mat');
save(filename,'header_down','signal_down');
end