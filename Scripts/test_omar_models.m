clc
clear all 
close all

%%
% !! CHANGE IF YOUR DATA IS LOCATED ELSEWHERE !!
subject = 'omar';
disp(['Loading data first session of ' subject '...'])
load(['rawdata down/data_' subject '1.mat']);
condition_text = ['conditions tables/data_' subject '1_ses_1_condition.txt'];
disp(['Loading data second session of ' subject '...'])
load(['rawdata down/data_' subject '2.mat']);
[features_extracted1] = process_session1(signal_down1,header_down1,condition_text);
[ features_extracted2 ] = process_session2(signal_down2,header_down2);
%%
%Evaluating models
disp('Evaluating models on second session...')
disp('Fisher method:')
train_features = features_extracted1(:,3:end);
train_labels = features_extracted1(:,1);
test_features = features_extracted2(:,3:end);
test_labels = features_extracted2(:,1);
%Fisher model:  DQDA 220 features - 0.4211
opt_features = 220;
%Train
[orderedInd, orderedPower] = rankfeat(train_features,train_labels, 'fisher');
classifier = fitcdiscr(train_features(:,orderedInd(1:opt_features)), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
yhat = predict(classifier, train_features(:,orderedInd(1:opt_features))); 
training_error_fisher = classerror(train_labels, yhat);

%Test
[yhat, dqda_score_fisher] = predict(classifier, test_features(:,orderedInd(1:opt_features)));
testing_error_fisher = classerror(test_labels, yhat);
[X,Y,T,AUC_fisher] = perfcurve(test_labels, dqda_score_fisher(:,2), 1);
disp(['AUC of ' num2str(AUC_fisher) ' for fisher.']);%Plot ROC curve
figure(1)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for classification using Fisher')
%%
%ReliefF : DLDA 621 features -0.369
disp('Relieff method:')
%Train
opt_features = 621;
[RANKED,WEIGHT] = relieff(train_features,train_labels,400);
classifier = fitcdiscr(train_features(:,RANKED(1:opt_features)), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
% classifier = fitcsvm(train_features(:, RANKED(1:opt_features)), train_labels, 'KernelFunction','linear');
yhat = predict(classifier, train_features(:,RANKED(1:opt_features))); 
training_error_relief = classerror(train_labels, yhat);

%Test
[yhat, dlda_score_relief] = predict(classifier, test_features(:,RANKED(1:opt_features)));
testing_error_relief = classerror(test_labels, yhat);
[X,Y,T,AUC_relieff] = perfcurve(test_labels, dlda_score_relief(:,2), 1);
disp(['AUC of ' num2str(AUC_relieff) ' for relieff.']);
%Plot ROC curve
figure(2)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for classification using ReliefF')
%%
%PCA : LDA 1 features - 0.4182
disp('PCA:')
opt_PCs = 1;
[coeff, train_PCA, variance] = pca(train_features);
% Attention: We have to center the testing data also
mean_t = mean(train_features,1);
for i=1:size(test_features,1)
    mean_test(i,:) = mean_t;
end
test_features_centered = test_features - mean_test;
test_PCA = test_features_centered * coeff;

classifier = fitcdiscr(train_PCA(:,1:opt_PCs), train_labels, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
yhat = predict(classifier, train_PCA(:,1:opt_PCs)); 
training_error_PCA = classerror(train_labels, yhat);

%Test
[yhat, lda_score_PCA] = predict(classifier, test_PCA(:,1:opt_PCs));
testing_error_PCA = classerror(test_labels, yhat);
[X,Y,T,AUC_PCA] = perfcurve(test_labels, lda_score_PCA(:,2), 1);
disp(['AUC of ' num2str(AUC_PCA) ' for PCA.']);
figure(3)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for classification using PCA')
