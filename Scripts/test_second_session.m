clc;
clear all; 
close all;

load('data_ricardo2.mat')
features_extracted = process_session2(signal_down, header_down);

test_features = features_extracted(:,3:end);
test_labels = features_extracted(:,1);

load('classifier_ricardo_relieff.mat');
nb_features = model_ricardo.nb_features;
indices = model_ricardo.indices;
classifier = model_ricardo.classifier;

% mean_t = model_omar.mean;
% coeff = model_omar.coeff;
% mean_test = [];
% for i=1:size(test_features,1)
%     mean_test(i,:) = mean_t;
% end
% test_features_centered = [];
% test_features_centered = test_features - mean_test;
% test_PCA = [];
% test_PCA = test_features_centered * coeff;
% test_features = test_PCA;

[yhat, score, autre] = predict(classifier, test_features(:,1:nb_features)); 
[test_err] = classerror(test_labels, yhat); 
fprintf('Test Error : %0.3f\n ',test_err);
C = confusionmat(test_labels, yhat)
[X,Y,T,AUC] = perfcurve(test_labels, score(:,2), 1);
figure(1)
plot(X,Y)

caca = 1;
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



