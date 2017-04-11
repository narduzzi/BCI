clc;
clear all;
close all;

[signal, header] = sload('data_ricardo1/data_ricardo1.bdf');
signal = signal';


for i=1:3
    figure(i)
    plot(signal(i,:))
end


%% 
% CAR
col = length(signal(1,:));
lin = length(signal(:,1));
for i=1:col
    mean_signal = mean(signal(1:64,i));
    for j=1:64
        signal(j,i) = signal(j,i)-mean_signal;
    end
end

for i=1:3
    figure(3+i)
    plot(signal(i,:))
end


%%

% Decimate
% Downsampling

signal = signal';
signal = downsample(signal,8);
signal = signal';

for i=1:3
    figure(9+i)
    plot(signal(i,:))
end

% header: /4 et après arrondir au supérieur => ceil



%%
% Filtering

[b,a] = butter(4, [1 40] / ( 2048/ 2), 'bandpass');
for i=1:64
    filt_signal(i,:) = filtfilt(b, a, signal(i,:));
end

for i=1:3
    figure(6+i)
    plot(filt_signal(i,:))
end

% %% 
%     i = 1;
% for j=17:32
% 
%     subplot(4,4,i)
%     plot(signal(j,:))
%     i = 1+i;
% end
% 
% 
% 
% %% 
% 
% save('data_omar1.mat', 'filt_signal', '-v7.3')

%% 


    