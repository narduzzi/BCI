
clear all;
close all;
clc

%%

load('data_simon1.mat')
downfactor = 8;
low=1;
high=40;
order=5;
Fs = header_down.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%%
text = 'data_simon1_ses_1_condition.txt';
[easy,hard_assist,hard_noassist] = partitioning2(header_down,signal_filtered,text);

%%
%centered_electrodes = load('25_centered_electrodes.mat');
%[indices] = index_of_electrodes(centered_electrodes.label,header_down);
indices = 1:64;
%indices = [1, 19, 21, 23, 24, 27, 28, 29, 33, 35, 36, 49, 60, 63, 64, 18, 31, 32, 39, 40, 42, 43, 44, 47, 48, 50, 52, 55, 56, 57, 61 ];
%indices = [18, 27, 28, 29, 31, 32, 48, 49, 50, 56, 60, 61];
indices = sort(indices);

%%
window_size = 256;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),-1,header_down,window_size,step_size);

%%
discriminant_analysis(features_extracted,1000);
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
features_selected = [features_extracted(:,1:2) features_pca(:,1:100)];
%features_selected = features_pca(:,1:876);

 
% % Testing with 2nd session
% %
% clc
% clear all
% close all
% %
% 
% load('data_loic2.mat')
% downfactor = 8;
% low=1;
% high=40;
% order=4;
% Fs = header_down.SampleRate/downfactor;
% signal_filtered = band_filter(low,high,order,Fs,signal_down);
% 
% %
% [easy_test, medium_test, hard_test] = partitioning_testsession(header_down, signal_filtered);
% centered_electrodes = load('25_centered_electrodes.mat');
% [indices] = index_of_electrodes(centered_electrodes.label,header_down);
% indices = 1:64;
% indices = sort(indices);
% 
% %
% window_size = 200;
% step_size = window_size/2;
% features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
% features_extracted = features_extraction(easy_test(indices,:),hard_test(indices,:),-1,header_down,window_size,step_size);
% % Test without PCA
% load('classifier1.mat');
% 
% test_features = features_extracted(:,3:end);
% test_labels = features_extracted(:,1);
% yhat_lda = predict(classifier_lda, test_features);
% [test_err] = classerror(test_labels, yhat_lda); 
% 
% fprintf('Test Error : %0.3f\n ',test_err);
% C = confusionmat(test_labels, yhat_lda)
% 
% %% Test with PCA
% load('classifier_test.mat');
% 
% test_features = features_extracted(:,3:end);
% test_labels = features_extracted(:,1);
% [coeff, features_pca, variance] = pca(test_features);
% test_features = features_pca(:,1:100);
% yhat_lda = predict(classifier_lda, test_features);
% [test_err] = classerror(test_labels, yhat_lda); 
% 
% fprintf('Test Error : %0.3f\n ',test_err);
% C = confusionmat(test_labels, yhat_lda)

