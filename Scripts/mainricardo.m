
clear all;
close all;
clc

%%

load('data_simon2.mat')
downfactor = 8;
low=1;
high=40;
order=4;
Fs = header_down.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%%
text = 'data_simon1_ses_1_condition.txt';
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

%%
centered_electrodes = load('25_centered_electrodes.mat');
[indices] = index_of_electrodes(centered_electrodes.label,header_down);

%%
window_size = 200;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header_down,window_size,step_size);

%%
train_errors = [];
test_errors = [];
for traj = 0:4
    [train_labels,train_features,test_labels,test_features] = create_folds(features_extracted,traj);
    classifier_lda = fitcdiscr(train_features, train_labels, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
    
    yhat_lda = predict(classifier_lda, train_features); 
    [train_err] = classerror(train_labels, yhat_lda);
    yhat_lda = predict(classifier_lda, test_features);
    [test_err] = classerror(test_labels, yhat_lda); 
    
    fprintf('Train Error : %0.3f\t',train_err);
    fprintf('Test Error : %0.3f\n ',test_err);
    
    train_errors = horzcat(train_errors,train_err);
    test_errors = horzcat(test_errors,test_err);
end
disp('====Evaluation finished====');
fprintf('Mean Train Error : %0.3f\t',mean(train_errors));
fprintf('Mean Test Error : %0.3f\n',mean(test_errors));

%% 
[coeff, features_pca, variance] = pca(features_extracted(:,3:end));
features_selected = [features_extracted(:,1:2) features_pca(:,1:8)];
%features_selected = features_pca(:,1:876);


