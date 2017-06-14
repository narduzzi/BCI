function plotRaw(signal,header)
% Function that takes the EEG signal (64 electrodes) as input.
% It plots the 64 EEG chanels of the signal in 4 windows,
% 16 electrodes per window. 
close all

start_traj_index = find(header.EVENT.TYP == 1);
end_traj_index = find(header.EVENT.TYP == 255);

figure(1)
for i=1:16
    subplot(4,4,i)
    plot(signal(i,:))
    hold on
    plot(header.EVENT.POS(start_traj_index), signal(i,header.EVENT.POS(start_traj_index)), 'o', header.EVENT.POS(end_traj_index), signal(i,header.EVENT.POS(end_traj_index)), 'x') 
    legend('signal','start', 'end')
    title(['electrode ' int2str(i)])
end

figure(2)
for i=1:16
    subplot(4,4,i)
    plot(signal(i+16,:))
    hold on
    plot(header.EVENT.POS(start_traj_index),signal(i+16,header.EVENT.POS(start_traj_index)), 'o', header.EVENT.POS(end_traj_index), signal(i+16,header.EVENT.POS(end_traj_index)), 'x') 
    legend('signal','start', 'end')
    title(['electrode ' int2str(i+16)])
end

figure(3)
for i=1:16
    subplot(4,4,i)
    plot(signal(i+32,:))
    hold on
    plot(header.EVENT.POS(start_traj_index), signal(i+32,header.EVENT.POS(start_traj_index)), 'o', header.EVENT.POS(end_traj_index), signal(i+32,header.EVENT.POS(end_traj_index)), 'x') 
    legend('signal','start', 'end')
    title(['electrode ' int2str(i+32)])

end

figure(4)
for i=1:16
    subplot(4,4,i)
    plot(signal(i+48,:))
    hold on
    plot(header.EVENT.POS(start_traj_index), signal(i+48,header.EVENT.POS(start_traj_index)), 'o', header.EVENT.POS(end_traj_index), signal(i+48,header.EVENT.POS(end_traj_index)), 'x') 
    legend('signal','start', 'end')
    title(['electrode ' int2str(i+48)])
end
end

