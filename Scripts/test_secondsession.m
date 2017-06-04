function [ output_args ] = test_secondsession( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Testing with 2nd session


load('data_ricardo2.mat')
downfactor = 8;
low=1;
high=40;
order=4;
Fs = header_down.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

%
[easy_test, medium_test, hard_test] = partitioning_testsession(header_down, signal_filtered);
indices = 1:64;
%indices = sort(indices);

%
window_size = 200;
step_size = window_size/2;
%features_extracted = features_extraction(easy(indices,:),hard_noassist(indices,:),hard_assist(indices,:),header,window_size,step_size);
features_extracted = features_extraction(easy_test(indices,:),hard_test(indices,:),-1,header_down,window_size,step_size);
% Test without PCA
load('classifier1.mat');

test_features = features_extracted(:,3:end);
test_labels = features_extracted(:,1);
[orderedInd, orderedPower] = rankfeat(test_features, test_labels, 'fisher');
yhat_lda = predict(classifier_dqda, test_features(:,orderedInd(1:120)));
[test_err] = classerror(test_labels, yhat_lda); 

fprintf('Test Error : %0.3f\n ',test_err);
C = confusionmat(test_labels, yhat_lda)

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



end

