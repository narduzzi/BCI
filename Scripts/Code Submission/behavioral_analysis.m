function behavioral_analysis()
% Function that performs all the behavioral analysis without distinction of
% the subjects in order to achieve statistical signifiance. 

%% 1: Determine the self-assessement for all subjects mixed
easy = [];
hard = [];
hard_ass = [];

% !! CHANGE THE NAME OF THE SUBJECTS AND THE NAME OF FOLDERS HERE AND IN
% FUNCTION self_assess IF NEEDED !!

subjectNames = {'omar1','loic1','ricardo1','simon1'};

for i=1:4
    [easy_sub, hard_sub, hard_ass_sub] = self_assess(subjectNames{i});
    easy = vertcat(easy, easy_sub);
    hard = vertcat(hard, hard_sub);
    hard_ass = vertcat(hard_ass, hard_ass_sub);
end
close all;
figure(1)
boxplot([easy,hard_ass, hard],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Workload perceived by the subjects')
ylabel('Scale of difficulty [0-100]');

%% 2 Determine the user performance for all subjects

easy = [];
hard = [];
hard_ass = [];
for i=1:4
    file_data = strcat('data_', subjectNames{i});
    file_cond = strcat(file_data, '_ses_1_condition.txt');
    condition = text2matrix(file_cond);
    load(strcat(file_data, '.mat'));
    [matrix_success, rate_success] = user_performance(header_down.EVENT.TYP);

    easy = [easy rate_success(condition == 0)];
    hard_ass = [hard_ass rate_success(condition == 1)];
    hard = [hard rate_success(condition == 2)];
end

figure(2)
boxplot([easy', hard_ass', hard'],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Users performance')
ylabel('Rate of success');

 

%% 3 Determine the time spent per trajectory and per waypoint depending on the condition

t_easy = [];
t_hard_ass = [];
t_hard = [];
tw_easy = [];
tw_hard_ass = [];
tw_hard = [];
for i=1:4
    file_data = strcat('data_', subjectNames{i});
    file_cond = strcat(file_data, '_ses_1_condition.txt');
    condition = text2matrix(file_cond);
    load(strcat(file_data, '.mat'));
    [time_easy, time_hardassist, time_hardnoassist, time_waypoint_easy, time_waypoint_hardassist, time_waypoint_hardnoassist] = trajectory_time( header_down, subjectNames{i});

    t_easy = [t_easy time_easy];
    t_hard_ass = [t_hard_ass time_hardassist];
    t_hard = [t_hard time_hardnoassist];
    
    tw_easy = [tw_easy time_waypoint_easy];
    tw_hard_ass = [tw_hard_ass time_waypoint_hardassist];
    tw_hard = [tw_hard time_waypoint_hardnoassist];  
end

close all;
figure(3)
boxplot([time_easy', time_hardassist', time_hardnoassist'],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Time spent per trajectory for each condition')
ylabel('Time [s]');

figure(4)
boxplot([time_waypoint_easy', time_waypoint_hardassist', time_waypoint_hardnoassist'],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Time spent between two waypoints for each condition')   
ylabel('Time [s]');

end