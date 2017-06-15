function matrix=text2matrix(text)
%This function transform a text file into a matrix. To be used with
%condition files
%INTPUT=text which must be a text file (.txt)
%OUTPUT=matrix


addpath(genpath('..\Recordings'));


text_data=fileread(text);
data=textscan(text_data, '%f %f','Headerlines',1) ;
matrix=[data{2}];
matrix = matrix';

end