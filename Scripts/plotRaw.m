function plotRaw(signal)
% Function that takes the EEG signal (64 electrodes) as input.
% It plots the 64 EEG chanels of the signal in 4 windows,
% 16 electrodes per window. 

figure(1)
for i=1:16
    subplot(4,4,i)
    plot(signal(i,:))
end

figure(2)
for i=1:16
    subplot(4,4,i)
    plot(signal(i+16,:))
end

figure(3)
for i=1:16
    subplot(4,4,i)
    plot(signal(i+32,:))
end

figure(4)
for i=1:16
    subplot(4,4,i)
    plot(signal(i+48,:))
end
end

