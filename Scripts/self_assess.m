function self_assess( filename )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\Ricardo\Documents\EPFL\Master\Master II\Brain-Computer Interaction\BCI\Recordings\ag7_24032017_ricardo1')
%addpath('C:\Users\Ricardo\Documents\EPFL\Master\Master II\Brain-Computer Interaction\BCI\Recordings\ag7_24032017_ricardo1')

% Get the trajectory conditions
file_cond = strcat(filename, '_ses_1_condition.txt');
condition = text2matrix(file_cond);
matrix = [];
matrix(:,1) = condition';

% Get the perceived difficulty
file_questionnaire = strcat(filename, '_questionnaire.csv');
text_data=fileread(file_questionnnaire);
data=textscan(text_data, '%f %f %f %f %f %f %f %f','Headerlines', 5, 'Delimiter',',') ;
for i=1:8
    matrix(:,i+1)=[data{i}];
end

end
