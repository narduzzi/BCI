function freqanalysis(signal_down,header_down,condition_text)
%This function takes a down sampled signal, filter it between 1 and 40 Hz
%restrict the number of electrodes to 64 extract the trajectories with their 
%conditions and then perform fft and  filtering to see alpha and beta bands
%on each trajectory on different plots and on each electrodes with averaged
%trajectories.
% It takes as Input the signal down sampled and the file texted where the
% the difficulty labels are stored 

%%
close all

%%
signal_filtered = band_filter(1,40,5,256,signal_down);
signal64  = signal_filtered(1:64,:);
signal_avg = mean(signal64,1);
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
%%
%Frequency representation
figure(1)
for i = 1:length(idx_easy)-1
    condition = easy(idx_easy(i)+1:idx_easy(i+1)-1);
    length_easy(i) = length(condition);
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
    length_hard(i) = length(condition);
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


%%
%Compute the spectrum per average condition for the 64 electrodes 
min_easy = min(length_easy);
min_hard = min(length_hard);
[easy hard_assist hard_noassist] = partitioning2(header_down,signal_filtered,condition_text);
mat_easy = [];
mat_hard = [];

for i=1:64
    f_easy = [];
    s_easy = [];
    condition_easy =[];
    f_hard = [];
    s_hard = [];
    condition_hard =[];
    for j=1:5
        condition_easy = easy(i,idx_easy(j)+1:idx_easy(j+1)-1);
        condition_easy = condition_easy(1:min_easy);
        L = length(condition_easy);
        Y = fft(condition_easy);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f_easy(j,:) = Fs*(0:(L/2))/L;
        window_size = 50;
        s_mavg_easy(j,:) = filter(ones(1, window_size)/window_size, 1, P1);
        
        condition_hard = hard_noassist(i,idx_hard_noassist(j)+1:idx_hard_noassist(j+1)-1);
        condition_hard = condition_hard(1:min_hard);
        L = length(condition_hard);
        Y = fft(condition_hard);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f_hard(j,:) = Fs*(0:(L/2))/L;
        window_size = 50;
        s_mavg_hard(j,:) = filter(ones(1, window_size)/window_size, 1, P1);
    end
    electrode_freqs_easy(i,:) = mean(f_easy,1);
    electrode_power_easy(i,:) = mean(s_mavg_easy,1);
    electrode_freqs_hard(i,:) = mean(f_hard,1);
    electrode_power_hard(i,:) = mean(s_mavg_hard,1);
end
figure(8)
for i=1:16
    subplot(4,4,i)
    plot(electrode_freqs_easy(i,:),electrode_power_easy(i,:))
    hold on
    plot(electrode_freqs_hard(i,:),electrode_power_hard(i,:))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis([0 55 0 0.7]);
    legend('Easy','Hard');
    title(['Power spectrum electrode' int2str(i)])
end

figure(9)
for i=1:16
    subplot(4,4,i)
    plot(electrode_freqs_easy(i+16,:),electrode_power_easy(i+16,:))
    hold on
    plot(electrode_freqs_hard(i,:),electrode_power_hard(i,:))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis([0 55 0 0.7]);
    legend('Easy','Hard');
    title(['Power spectrum electrode' int2str(i+16)])
end

figure(10)
for i=1:16
    subplot(4,4,i)
    plot(electrode_freqs_easy(i+32,:),electrode_power_easy(i+32,:))
    hold on
    plot(electrode_freqs_hard(i,:),electrode_power_hard(i,:))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis([0 55 0 0.7]);
    legend('Easy','Hard');
    title(['Power spectrum electrode' int2str(i+32)])
end

figure(11)
for i=1:16
    subplot(4,4,i)
    plot(electrode_freqs_easy(i+48,:),electrode_power_easy(i+48,:))
    hold on
    plot(electrode_freqs_hard(i,:),electrode_power_hard(i,:))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    axis([0 55 0 0.7]);
    legend('Easy','Hard');
    title(['Power spectrum electrode' int2str(i+48)])
end

end
