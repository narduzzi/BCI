function self_assess( filename )
% Plot the boxplot of the difficulty perceived by the subject
%   filename contains the name of the subject folder

addpath('..\Recordings')

% Get the trajectory conditions
file_cond = strcat(filename, '_ses_1_condition.txt');
file_cond = strcat('data_', file_cond);
condition = text2matrix(file_cond);
matrix = [];
matrix(:,1) = condition';

% Get the perceived difficulty
file_questionnaire = strcat(filename, '_questionnaire.csv');
text_data=fileread(file_questionnaire);
data=textscan(text_data, '%f %f %f %f %f %f %f %f','Headerlines', 5, 'Delimiter',',') ;
for i=1:8
    matrix(:,i+1)=[data{i}];
end

%Plot the perceived difficulty

easy = matrix(find(matrix(:,1) == 0),3);
hard_ass = matrix(find(matrix(:,1) == 1),3);
hard = matrix(find(matrix(:,1) == 2),3);

figure(1)
boxplot([easy,hard_ass, hard],'Labels',{'easy','hard + assist', 'hard'})
title('Workload perceived by the subject')

% Notched plot
figure(2)
boxplot([easy,hard_ass, hard],'Notch', 'on','Labels',{'easy','hard + assist', 'hard'})
title('Workload perceived by the subject')

end
