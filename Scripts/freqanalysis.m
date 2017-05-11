function freqanalysis(signal_down,condition_text)
%This function takes a down sampled signal, filter it between 1 and 40 Hz
%restrict the number of electrodes to 2extract the trajectories with their 
%conditions and then perform fft and  filtering to see alpha and beta bands
%on each trajectory on different plots
% It takes as Input the signal down sampled and the file texted where the
% the difficulty labels are stored 

%%
close all
load(signal_down);
signal_filtered =  band_filter(1,40,5,256,signal_down);
centered_electrodes = load('25_centered_electrodes.mat');
[indices] = index_of_electrodes(centered_electrodes.label,header_down.Label);
signal25  = signal_filtered(indices,:);
signal_avg = mean(signal25,1);
[easy hard_assist hard_noassist] = partitioning2(header_down,signal_avg,condition_text);
idx_easy = 0;
idx_easy = [idx_easy find(easy == 1e4)];
idx_hard_noassist = 0;
idx_hard_noassist = [idx_hard_noassist find(hard_noassist == 1e4)];
Fs = 256;
vars = [];
moy = [];
%Compute the success rate 
trajectories_diff = text2matrix(condition_text);
[matrix_success, rate_success] = user_performance(header_down.EVENT.TYP);
easy_success = rate_success(trajectories_diff==0);
hard_success = rate_success(trajectories_diff == 2);
%%
%Frequency representation
figure(1)
for i = 1:length(idx_easy)-1
    condition = easy(idx_easy(i)+1:idx_easy(i+1)-1);
    L = length(condition);
    Y = fft(condition);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    subplot(3,2,i);
    window_size = 50;
    s_mavg = filter(ones(1,window_size)/window_size, 1, P1);
    plot(f,s_mavg);
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis([0 50 0 0.4]);
    vars(1,i) = var(condition);
    moy(1,i) = mean(condition);
    hold on
    %hard
    condition = hard_noassist(idx_hard_noassist(i)+1:idx_hard_noassist(i+1)-1);
    L = length(condition);
    Y = fft(condition);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    subplot(3,2,i);
    window_size = 50;
    s_mavg = filter(ones(1, window_size)/window_size, 1, P1);
    plot(f,s_mavg);
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    vars(2,i) = var(condition);
    moy(2,i) = mean(condition);
    axis([0 50 0 0.4]);
    legend('Easy','Hard')
    title(['Frequency representation of trajectory' int2str(i)])
end
subplot(3,2,6);
trials = [ 1 2 3 4 5];
plot(trials,easy_success)
hold on
plot(trials,hard_success)
legend('easy','hard')
xlabel('Trials')
ylabel('Success rate')

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
plot(trials,vars(1,:));
hold on;
plot(trials,vars(2,:));
legend('Easy','Hard');
title('Variance of the trajectories signal')
xlabel('Trajectories');
ylabel('Variance')
figure(4)
plot(trials,moy(1,:));
hold on;
plot(trials,moy(2,:));
legend('Easy','Hard');
title('Average of the trajectories signal')
xlabel('Trajectories');
ylabel('Average')
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
axis_size_alpha = [5 15 0 0.4];
%easy
figure(5)
for i = 1:length(idx_easy)-1
    condition = easy(idx_easy(i)+1:idx_easy(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    Y = fft(condition_filtered);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    axis(axis_size_alpha);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, P1);
    plot(f,s_mavg);
    axis(axis_size_alpha);
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    hold on
    
    %hard
    condition = hard_noassist(idx_hard_noassist(i)+1:idx_hard_noassist(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    Y = fft(condition_filtered);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    axis(axis_size_alpha);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, P1);
    plot(f,s_mavg);
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis(axis_size_alpha);
    legend('Easy','Hard');
    title(['Alpha band of trajectory' int2str(i)]);
end

subplot(3,2,6);
plot(trials,easy_success)
hold on
plot(trials,hard_success)
legend('easy','hard')
xlabel('Trials')
ylabel('Success rate')
title('Success rate of trajectories per difficulty')

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
axis_size_beta=[10 35 0 0.1];

figure(7)
for i = 1:length(idx_easy)-1
    %easy
    condition = easy(idx_easy(i)+1:idx_easy(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    Y = fft(condition_filtered);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    axis(axis_size_beta);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, P1);
    plot(f,s_mavg);
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis(axis_size_beta);
    hold on
    
    %hard
    condition = hard_noassist(idx_hard_noassist(i)+1:idx_hard_noassist(i+1)-1);
    condition_filtered = band_filter(low,high,order,Fs,condition);
    L = length(condition_filtered);
    Y = fft(condition_filtered);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    axis(axis_size_beta);
    subplot(3,2,i);
    s_mavg = filter(ones(1, window_size)/window_size, 1, P1);
    plot(f,s_mavg);
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis(axis_size_beta);
    legend('Easy','Hard');
    title(['Beta band trajectory' int2str(i)])
end

subplot(3,2,6);
plot(trials,easy_success)
hold on
plot(trials,hard_success)
legend('easy','hard')
xlabel('Trials')
ylabel('Success rate')
title('Success rate of trajectories per difficulty')