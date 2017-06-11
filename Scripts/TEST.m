close all;
clear all;
clc;

addpath(genpath('..\Recordings'));
recording_session = 'ah2_31032017';
user = '_simon1';

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
indices = [1:64] %should be 5,4,38

%%
disp('Feature extraction...')
window_size = 256;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header,window_size,step_size);
%%
features = features_extracted(:,3:size(features_extracted,2));
labels = features_extracted(:,1);
K = 200
%%
disp('Starting neighborhood component analysis');
[ranked,weight] = relieff(features,labels,K);
disp('Features ranked');
%%

features_train_error = [];
features_test_error= [];

for nbfeatures=283:1:286
    selected_features = ranked(1:nbfeatures);
    %%
    fprintf('Evaluating performances for %0.1f features: ',nbfeatures);
    train_errors = [];
    test_errors = [];
    for traj = 0:4
        [train_labels,train_features,test_labels,test_features] = create_folds(features_extracted,traj);
        SVMModel = fitcsvm(train_features(:,selected_features),train_labels,'KernelFunction','linear');

        [predicted_train,score] = predict(SVMModel,train_features(:,selected_features));
        [predicted_labels,score] = predict(SVMModel,test_features(:,selected_features));

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
    
    features_train_error = horzcat(features_train_error,mean(train_errors));
    features_test_error = horzcat(features_test_error,mean(test_errors));
end
%%
figure();

x = [1:50:2000];

title('Performance depending on number of features, ranked by NCA=200, 64 electrode, patient4');
hold on;
plot(features_train_error);
plot(features_test_error);
hold off;
legend('Train error','Test error');
%%
%}
%save('features_extracted_25_100_50_EH','features_extracted')

%% BEST MODEL %%
disp('Extracting folds...');
nbfeatures = 287;
selected_features = ranked(1:nbfeatures);
[train_labels,train_features,test_labels,test_features] = create_folds(features_extracted,6);
disp('Training final model...');
SVMModel_Simon_287 = fitcsvm(train_features(:,selected_features),train_labels,'KernelFunction','linear');
disp('Training finished!');
%%
disp('Saving model...');
%Simon_Model_287_struct.classifier = SVMModel_Simon_284;
Simon_Model_287_struct.ranked = ranked';
Simon_Model_287_struct.nbfeatures = 287;
Simon_Model_287_struct.selected_features = selected_features';
Simon_Model_287_struct.window_size = window_size;
Simon_Model_287_struct.downsampling_factor = 8;
disp('Model saved.');

%%
%Testing structure
Simon_model_test_struct = load('Models/Simon_Model_287_struct.mat');
%%
classifier = Simon_model_test.SVMModel_Simon_287;
[predicted_labels_2,score_2] = predict(classifier,train_features(:,selected_features));
