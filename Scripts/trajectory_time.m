function [time_easy, time_hardassist, time_hardnoassist, time_waypoint_easy, time_waypoint_hardassist, time_waypoint_hardnoassist] = trajectory_time( header, filename )
% Calculate the time between the beginning and the end of each trajectory,
% and the time between each waypoint. 
%   header : the variable should not be downsampled (original header)
%   filename: name of the file like "simon1" for example
% The function computes the mean time of trajectory for each condition and
% then makes a boxplot for each condition. 
% In the 2nd part, the function also computes the time between each
% waypoint for each trajectory and per condition. A boxplot of the time is
% then plotted for each condition. 

% Retrieve the conditions
file_cond = strcat(filename, '_ses_1_condition.txt');
file_cond = strcat('data_', file_cond);
condition = text2matrix(file_cond);

% Part 1: Calculate the time of each trajectory
index_1 = find(header.EVENT.TYP == 1);
index_255 = find(header.EVENT.TYP == 255);

for i=1:length(index_1)
    time(i) = header.EVENT.POS(index_255(i)) - header.EVENT.POS(index_1(i));
end

time = time * (1/header.SampleRate); 
time_easy = time(condition == 0);
time_hardnoassist = time(condition == 2);
time_hardassist = time(condition == 1);
mean_easy = mean(time_easy);
sd_easy = std(time_easy);
mean_hardassist = mean(time_hardassist);
sd_hardassist= std(time_hardassist);
mean_hardnoassist = mean(time_hardnoassist);
sd_hardnoassist = std(time_hardnoassist);

% Boxplot
figure(1)
boxplot([time_easy', time_hardassist', time_hardnoassist'],'Labels',{'easy','hard + assist', 'hard'})
title('Time spent per trajectory for each condition')

% Notched plot
figure(2)
boxplot([time_easy', time_hardassist', time_hardnoassist'],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Time spent per trajectory for each condition')

% Part 2 : Compute the time between each waypoint
for i=1:length(index_1)
    index_waypoint = index_1(i) - 1 + find(header.EVENT.TYP(index_1(i):index_255(i)) == 16 | header.EVENT.TYP(index_1(i):index_255(i)) == 48);
    %index_waypoint = [index_1(i) index_waypoint index_255(i)];
    index_waypoint = index_waypoint(2:end);
    time_waypoint(i,:) = (diff(header.EVENT.POS(index_waypoint))*(1/header.SampleRate))';
end
time_waypoint_easy = [];
time_waypoint_hardnoassist = [];
time_waypoint_hardassist = [];
for i=1:length(condition)
    if(condition(i) == 0)
        time_waypoint_easy = [time_waypoint_easy time_waypoint(i,:) ];
    elseif(condition(i) == 1)
        time_waypoint_hardnoassist = [time_waypoint_hardnoassist time_waypoint(i,:)];
    elseif(condition(i) == 2)
        time_waypoint_hardassist = [time_waypoint_hardassist time_waypoint(i,:)];
    end
end

mean_waypoint_easy = mean(time_waypoint_easy);
sd_waypoint_easy = std(time_waypoint_easy);
mean_waypoint_hardassist = mean(time_waypoint_hardassist);
sd_waypoint_hardassist= std(time_waypoint_hardassist);
mean_waypoint_hardnoassist = mean(time_waypoint_hardnoassist);
sd_waypoint_hardnoassist = std(time_waypoint_hardnoassist);

% Boxplot
figure(3)
boxplot([time_waypoint_easy', time_waypoint_hardassist', time_waypoint_hardnoassist'],'Labels',{'easy','hard + assist', 'hard'})
title('Time spent per trajectory for each condition')

% Notched plot
figure(4)
boxplot([time_waypoint_easy', time_waypoint_hardassist', time_waypoint_hardnoassist'],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Time spent per trajectory for each condition')   
        




end

