function freqanalysis(signal_down,condition_text)
%This function takes a down sampled signal, filter it between 1 and 40 Hz
%extract the trajectories with their conditions and then perform fft and 
%filtering to see alpha and beta bands on each trajectory on different
%plots

%%
close all
load(signal_down);
signal_filtered =  band_filter(1,40,5,256,signal_down);
electrode = 47;
[easy hard_assist hard_noassist] = partitioning2(header_down,signal_filtered,condition_text);
idx_easy = 0;
idx_easy = [idx_easy find(easy(electrode,:) == 1e4)];
idx_hard_noassist = 0;
idx_hard_noassist = [idx_hard_noassist find(hard_noassist(electrode,:) == 1e4)];
Fs = 256;
vars = [];
moy = [];
%%
%Frequency representation
figure(1)
for i = 1:length(idx_easy)-1
    condition = easy(electrode,idx_easy(i)+1:idx_easy(i+1)-1);
    
    L = length(condition);
    nfft = 2^(nextpow2(L));
    df = Fs/nfft;
    f = 0:df:Fs/2;
    Y = fft(condition,nfft);
    Y = Y(1:nfft/2 + 1);
    axis([0 50 0 4000]);
    subplot(3,2,i);
    window_size = 50;
    s_mavg = filter(ones(1,window_size)/window_size, 1, abs(Y));
    plot(f,s_mavg);
    axis([0 50 0 4000]);
    vars(1,i) = var(condition);
    moy(1,i) = mean(condition);
    hold on
    %hard
    condition = hard_noassist(electrode,idx_hard_noassist(i)+1:idx_hard_noassist(i+1)-1);
    L = length(condition);
    nfft = 2^(nextpow2(L));
    df = Fs/nfft;
    f = 0:df:Fs/2;
    Y = fft(condition,nfft);
    Y = Y(1:nfft/2 + 1);
    axis([0 50 0 4000]);
    subplot(3,2,i);
    window_size = 50;
    s_mavg = filter(ones(1, window_size)/window_size, 1, abs(Y));
    plot(f,s_mavg);
    axis([0 50 0 4000]);
    vars(2,i) = var(condition);
    moy(2,i) = mean(condition);
    legend('easy','hard')
    title(['frequency representation trajectory' int2str(i)])
end


figure(2)
Y = fft(condition);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
avg = 0.5;
s_mavg = filter(ones(1, avg*Fs)/avg/Fs, 1, P1);
plot(f,s_mavg)
title('Single-Sided Amplitude Spectrum of last hard trajctory')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure(3)
trials = [ 1 2 3 4 5];
plot(trials,vars(1,:));
hold on;
plot(trials,vars(2,:));
legend('easy','hard');
% hold on;
% plot(trials,vars(3,:));
% legend('easy','hard assist','hard');

figure(4)
trials = [ 1 2 3 4 5];
plot(trials,moy(1,:));
hold on;
plot(trials,moy(2,:));
legend('easy','hard');
% hold on;
% plot(trials,moy(3,:));
% legend('easy','hard assist','hard');

%%
%Frequency seperation
%alpha waves
low = 7.5;
high = 12.5;
Fs = 256;
order = 5;
window_size = 50;
axis_size_alpha = [5 15 0 3200];
%easy
figure(5)
for i = 1:length(idx_easy)-1
    condition = easy(electrode,idx_easy(i)+1:idx_easy(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    avg = 0.5;
    L = length(condition_filtered);
    nfft = 2^(nextpow2(L));
    df = Fs/nfft;
    f = 0:df:Fs/2;
    Y = fft(condition_filtered,nfft);
    Y = Y(1:nfft/2 + 1);
    axis(axis_size_alpha);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, abs(Y));
    plot(f,s_mavg);
    axis(axis_size_alpha);
    hold on
    
    %hard
    condition = hard_noassist(electrode,idx_hard_noassist(i)+1:idx_hard_noassist(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    nfft = 2^(nextpow2(L));
    df = Fs/nfft;
    f = 0:df:Fs/2;
    Y = fft(condition_filtered,nfft);
    Y = Y(1:nfft/2 + 1);
    axis(axis_size_alpha);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, abs(Y));
    plot(f,s_mavg);
    axis(axis_size_alpha);
    legend('easy','hard');
    title(['alpha band trajectory' int2str(i)]);
end
figure(6)
window_size = 256;
s_mavg = filter(ones(1, window_size)/window_size, 1, condition_filtered);
plot(s_mavg);
%%
%beta waves
low = 12.5;
high = 30;
Fs = 256;
order = 5;
axis_size_beta=[10 35 0 2000];

figure(7)
for i = 1:length(idx_easy)-1
    %easy
    condition = easy(electrode,idx_easy(i)+1:idx_easy(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    nfft = 2^(nextpow2(L));
    df = Fs/nfft;
    f = 0:df:Fs/2;
    Y = fft(condition_filtered,nfft);
    Y = Y(1:nfft/2 + 1);
    axis(axis_size_beta);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, abs(Y));
    plot(f,s_mavg);
    axis(axis_size_beta);
    hold on
    
    %hard
    condition = hard_noassist(electrode,idx_hard_noassist(i)+1:idx_hard_noassist(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    nfft = 2^(nextpow2(L));
    df = Fs/nfft;
    f = 0:df:Fs/2;
    Y = fft(condition_filtered,nfft);
    Y = Y(1:nfft/2 + 1);
    axis(axis_size_beta);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, abs(Y));
    plot(f,s_mavg);
    axis(axis_size_beta);
    legend('easy','hard');
    title(['beta band trajectory' int2str(i)])
end