close all;
clear all;
clc;

addpath(genpath('..\Recordings'));
recording_session = 'af6_15032017';
user = '_loic1';

path=strcat('Recordings/',recording_session,user,'/biosemi/data',user,'.bdf');
text=strcat('Recordings/',recording_session,user,'/unity/',recording_session,'_ses_1_condition.txt');

%[easy,hard_assist,hard_noassist,features_extracted] = main_eeg(path,8,1,40,4,text);

rawsignal = path;
downfactor = 8;
low=1;
high=40;
order=4;

%%
%%Main part
%Test
disp('Loading data...')
[signal,header] = sload(rawsignal);
signal = signal';
%channel selection
signal = signal(1:64,:);

%%
downfactor = 4;
disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down,signal_down] = downsampling(header,signal,downfactor);

%%
disp('Applying car...');
%signal_filtered = car(signal_filtered);
signal_down = car(signal_down);
disp('CAR done.');

%%
low = 5;
high = 40;
order= 5;
disp('Bandpass filtering...')
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%%
disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

%%
disp('Selecting electodes...')
centered_electrodes = load('25_centered_electrodes.mat');
[indices] = index_of_electrodes(centered_electrodes.label,header_down);
indices %should be 5,4,38

%%
disp('Feature extraction...')
window_size = 512;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header,window_size,step_size);
%%

disp('Evaluating performances : ');
train_errors = [];
test_errors = [];
for traj = 0:4
    [train_labels,train_features,test_labels,test_features] = create_folds(features_extracted,traj);
    SVMModel = fitcsvm(train_features,train_labels,'KernelFunction','linear');
    
    [predicted_train,score] = predict(SVMModel,train_features);
    [predicted_labels,score] = predict(SVMModel,test_features);
    
    [train_err] = classerror(train_labels,predicted_train);
    [test_err] = classerror(test_labels,predicted_labels);
    fprintf('Train Error : %0.3f\t',train_err);
    fprintf('Test Error : %0.3f\n ',test_err);
    
    train_errors = horzcat(train_errors,train_err);
    test_errors = horzcat(test_errors,test_err);
end
disp('====Evaluation finished====');
fprintf('Mean Train Error : %0.3f\t',mean(train_errors));
fprintf('Mean Test Error : %0.3f\n',mean(test_errors));
    



%%
%}
save('features_extracted_25_100_50_EH','features_extracted')
%%%%%%%%%%%%%%%
shuffledArray = features_extracted(randperm(size(features_extracted,1)),:);
%save('shuffled_features_extracted_25_electrodes.mat','shuffledArray');

easy_t = easy';
S = size(easy_t);
N = S(1);
easy_t = [easy_t zeros(N,1)];

hard_assist_t = hard_assist';
S = size(hard_assist_t);
N = S(1);
hard_assist_t = [hard_assist_t ones(N,1)];

hard_noassist_t = hard_noassist';
S = size(hard_noassist_t);
N = S(1);
hard_noassist_t = [hard_noassist_t ones(N,1)*2];

data = [easy_t',hard_assist_t',hard_noassist_t']';