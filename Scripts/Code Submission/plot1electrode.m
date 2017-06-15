function  plot1electrode( electrode, header )
% Function that takes as input one electrode signal,
% and plot different views of this electrode.

% Figure 1 shows the signal during 5 different ranges of time,
% from less zoomed to the most zoomed. 

% Figure 2 shows the signal with the start and the end of the trajectories
% plotted in 2 different ways. 

% Figure 3 shows one trajectory (1 electrode) with the waypoints 
% and shows if they are passed or missed. 


figure(1)

subplot(5,1,1)
plot(electrode)

subplot(5,1,2)
plot(electrode(round(length(electrode)*0.4):round(length(electrode)*0.5)))

subplot(5,1,3)
plot(electrode(round(length(electrode)*0.4):round(length(electrode)*0.41)))

subplot(5,1,4)
plot(electrode(round(length(electrode)*0.4):round(length(electrode)*0.401)))

subplot(5,1,5)
plot(electrode(round(length(electrode)*0.4):round(length(electrode)*0.4001)))

figure(2)
subplot(2,1,1)
plot(electrode)
start_traj_index = find(header.EVENT.TYP == 1);
end_traj_index = find(header.EVENT.TYP == 255);

for i=1:length(start_traj_index)
    y1=get(gca,'ylim');
    hold on
    plot([header.EVENT.POS(start_traj_index(i)) header.EVENT.POS(start_traj_index(i))],y1)
end

for i=1:length(start_traj_index)
    y1=get(gca,'ylim');
    hold on
    plot([header.EVENT.POS(end_traj_index(i)) header.EVENT.POS(end_traj_index(i))],y1)
end

subplot(2,1,2)
plot(electrode)
hold on;
plot(header.EVENT.POS(start_traj_index), electrode(header.EVENT.POS(start_traj_index)), 'o', header.EVENT.POS(end_traj_index), electrode(header.EVENT.POS(end_traj_index)), 'x') 
legend('signal','start', 'end')




figure(3)
s = start_traj_index(12);
e = end_traj_index(12);
plot(electrode(header.EVENT.POS(s):header.EVENT.POS(e)))

for i=4:length(header.EVENT.POS(s:e))-1
    if header.EVENT.TYP(s+i) == 16
        hold on;
        plot(header.EVENT.POS(s+i)-header.EVENT.POS(s)+1, electrode(header.EVENT.POS(s+i)), 'x', 'LineWidth', 1.5, 'MarkerSize', 10)
        16
    end
    if header.EVENT.TYP(s+i) == 48
        hold on;
        plot(header.EVENT.POS(s+i)-header.EVENT.POS(s)+1, electrode(header.EVENT.POS(s+i)), 'o', 'LineWidth', 1.5, 'MarkerSize', 10)
        48
    end
end

end




