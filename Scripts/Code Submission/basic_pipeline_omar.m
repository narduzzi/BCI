%Basic model
clear all
close all
clc
%Pipeline : Processing (CAR,Downsampling) and feature extraction
features_session1 = process_recording('Recordings/af6_15032017_omar1/biosemi/data_omar1.bdf',...
    'Recordings/af6_15032017_omar1/unity/af6_15032017_ses_1_condition.txt',1);
features_session2 = process_recording('Recordings/af6_12042017_omar2/biosemi/data_omar2.bdf',...
    'Recordings/af6_12042017_omar2/unity/af6_12042017_ses_2_condition.txt',2);

%%
%Evaluating models
train_features = features_session1(:,3:end);
train_labels = features_session1(:,1);
%collecting test data with medium condition
test_features_medium = features_session2(:,3:end);

%remove medium condition
test_features= test_features_medium;
test_features(find(features_session2(:,1)==2),:) = [];

%defining test labels
test_labels_medium = features_session2(:,1);
test_labels = test_labels_medium;
%removing the medium labels
test_labels(find(test_labels==2)) = [];
%%
%Fisher model: 
disp('Evaluating models on second session...')
disp('Fisher method:')
opt_features = 220;
%Train
[orderedInd, orderedPower] = rankfeat(train_features,train_labels, 'fisher');
classifier = fitcdiscr(train_features(:,orderedInd(1:opt_features)), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
yhat = predict(classifier, train_features(:,orderedInd(1:opt_features))); 
training_error_fisher = classerror(train_labels, yhat);

%Test
[yhat, score_fisher] = predict(classifier, test_features(:,orderedInd(1:opt_features)));
testing_error_fisher = classerror(test_labels, yhat);
[X,Y,T,AUC_fisher] = perfcurve(test_labels, score_fisher(:,2), 1);
disp(['AUC of ' num2str(AUC_fisher) ' for fisher.']);
disp(['test error of ' num2str(testing_error_fisher) ' for fisher.']);

[yhat, score_fisher] = predict(classifier, test_features_medium(:,orderedInd(1:opt_features)));
[ percentage_medium_in_easy_fisher, percentage_medium_in_hard_fisher ] = medium_testing( yhat, test_labels_medium);
%Plot ROC curve
figure(1)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for classification using Fisher')
%%
%ReliefF : 
disp('Relieff method:')
%Train
opt_features = 621;
[RANKED,WEIGHT] = relieff(train_features,train_labels,400);
classifier = fitcdiscr(train_features(:, RANKED(1:opt_features)), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
yhat = predict(classifier, train_features(:,RANKED(1:opt_features))); 
training_error_relief = classerror(train_labels, yhat);

%Test
[yhat, score_relief] = predict(classifier, test_features(:,RANKED(1:opt_features)));
testing_error_relief = classerror(test_labels, yhat);
[X,Y,T,AUC_relieff] = perfcurve(test_labels, score_relief(:,2), 1);
disp(['AUC of ' num2str(AUC_relieff) ' for relieff.']);
disp(['test error of ' num2str(testing_error_relief) ' for reliefF.']);

%Evaluate medium
[yhat, score_relief] = predict(classifier, test_features_medium(:,RANKED(1:opt_features)));
[ percentage_medium_in_easy_relief, percentage_medium_in_hard_relief ] = medium_testing( yhat, test_labels_medium);
%Plot ROC curve
figure(2)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for classification using ReliefF')
%%
%PCA : 
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
[yhat, score_PCA] = predict(classifier, test_PCA(:,1:opt_PCs));
testing_error_PCA = classerror(test_labels, yhat);
[X,Y,T,AUC_PCA] = perfcurve(test_labels, score_PCA(:,2), 1);
disp(['AUC of ' num2str(AUC_PCA) ' for PCA.']);
disp(['test error of ' num2str(testing_error_PCA) ' for PCA.']);
figure(3)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for classification using PCA')


%Evaluate medium
for i=1:size(test_features_medium,1)
    mean_test(i,:) = mean_t;
end
test_features_centered = test_features_medium - mean_test;
test_PCA_medium = test_features_centered * coeff;
[yhat, score_PCA] = predict(classifier, test_PCA_medium(:,1:opt_PCs));
[percentage_medium_in_easy_PCA, percentage_medium_in_hard_PCA ] = medium_testing( yhat, test_labels_medium);