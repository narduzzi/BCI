function plotSuccessRate( filename, event )
% The function also displays a figure with the success rate plotted. 
%   

addpath('..\Recordings')

% Get the trajectory conditions
file_cond = strcat(filename, '_ses_1_condition.txt');
file_cond = strcat('data_', file_cond);
condition = text2matrix(file_cond);

% Get success rate
[matrix_success, rate_success] = user_performance(event);

easy = rate_success(condition == 0);
hard_ass = rate_success(condition == 1);
hard = rate_success(condition == 2);

figure(1)
boxplot([easy', hard_ass', hard'],'Labels',{'easy','hard + assist', 'hard'})
title('User performance')

% Notched plot
figure(2)
boxplot([easy', hard_ass', hard'],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('User performance')


end

