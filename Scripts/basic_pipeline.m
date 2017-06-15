%Basic model

%Pipeline : Processing (CAR,Downsampling) and feature extraction
features_session1 = process_recording('Recordings/af6_15032017_loic1/biosemi/data_loic1.bdf',...
    'Recordings/af6_15032017_loic1/unity/af6_15032017_ses_1_condition.txt',1)
features_session2 = process_recording('Recordings/af6_12042017_loic2/biosemi/data_loic2.bdf',...
    'Recordings/af6_12042017_loic2/unity/af6_12042017_ses_2_condition.txt',2)

%%
%Separation
features_mediums_session2 = features_session2(find(features_session2(:,1)==2),:);
features_session2(find(features_session2(:,1)==2),:) = [];


%Create folds
trajectory_out_train = -1;
[train_labels,train_features,val_label,val_features] = create_folds(features_session1,trajectory_out_train);
[test_labels,test_features,n1,n2] = create_folds(features_session2,-1);
[test_labels_medium,test_features_medium,n1,n2] = create_folds(features_mediums_session2,-1);

%%Models here
%%
%Fisher
%Training DLDA
nb_features = 460;
disp('Computing Fisher..');
[orderedInd, orderedPower] = rankfeat(train_features, train_labels, 'fisher');
disp('Training session 1');
classifier_dlda = fitcdiscr(train_features(:,orderedInd(1:nb_features)), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
%Testing
[predicted_train,score] = predict(classifier_dlda, train_features(:,orderedInd(1:nb_features))); 
training_error_dlda = classerror(train_labels, predicted_train);
disp('Testing on session 2');
[predicted_labels,score]= predict(classifier_dlda, test_features(:,orderedInd(1:nb_features)));
testing_error_dlda = classerror(test_labels, predicted_labels); 

[X,Y,T,AUC_dlda] = perfcurve(test_labels, score(:,2), 1);

disp(fprintf('Train error on session 1 : %0.4f \n',training_error_dlda));
disp(fprintf('Test error on session 2 : %0.4f \n',testing_error_dlda));
disp(fprintf('AUC : %0.4f \n',AUC_dlda));

%mediums
[medium_yhat,score] = predict(classifier_dlda, test_features_medium(:,orderedInd(1:nb_features)));
[medium_easy_Fisher, medium_hard_Fisher] = medium_testing( medium_yhat, test_labels_medium);
disp(fprintf('Percentage medium easy : %0.4f \n',medium_easy_Fisher));
disp(fprintf('Percentage medium hard : %0.4f \n',medium_hard_Fisher));


%%
%ReliefF
%Training SVM linear
disp('Computing ReliefF');
nb_features= 801;
K=400;
[orderedInd, orderedPower] = relieff(train_features, train_labels, K);
%Testing
classifier_svml = fitcsvm(train_features(:,orderedInd(1:nb_features)),train_labels,'KernelFunction','linear');
[predicted_train,score] = predict(classifier_svml, train_features(:,orderedInd(1:nb_features))); 
training_error_svml = classerror(train_labels, predicted_train);
[predicted_test,score] = predict(classifier_svml, test_features(:,orderedInd(1:nb_features)));
testing_error_svml = classerror(test_labels, predicted_test); 

[X,Y,T,AUC_SVM] = perfcurve(test_labels, score(:,2), 1);

disp(fprintf('Train error on session 1 : %0.4f \n',training_error_svml));
disp(fprintf('Test error on session 2 : %0.4f \n',testing_error_svml));
disp(fprintf('AUC : %0.4f \n',AUC_SVM));

%mediums
[medium_yhat,score] = predict(classifier_svml, test_features_medium(:,orderedInd(1:nb_features)));
[medium_easy_ReliefF, medium_hard_ReliefF ] = medium_testing( medium_yhat, test_labels_medium);
disp(fprintf('Percentage medium easy : %0.4f \n',medium_easy_ReliefF));
disp(fprintf('Percentage medium hard : %0.4f \n',medium_hard_ReliefF));

%%
%PCA
disp('PCA:')
opt_PCs = 330;
[coeff, train_PCA, variance] = pca(train_features);
% Attention: We have to center the testing data also
mean_t = mean(train_features,1);
for i=1:size(test_features,1)
    mean_test(i,:) = mean_t;
end
test_features_centered = test_features - mean_test;
test_PCA = test_features_centered * coeff;

classifier = fitcdiscr(train_PCA(:,1:opt_PCs), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
yhat = predict(classifier, train_PCA(:,1:opt_PCs)); 
training_error_PCA = classerror(train_labels, yhat);

%Test
[yhat, score_PCA] = predict(classifier, test_PCA(:,1:opt_PCs));
testing_error_PCA = classerror(test_labels, yhat);
[X,Y,T,AUC_PCA] = perfcurve(test_labels, score_PCA(:,2), 1);

disp(fprintf('Train error on session 1 : %0.4f \n',training_error_PCA));
disp(fprintf('Test error on session 2 : %0.4f \n',testing_error_PCA));
disp(fprintf('AUC : %0.4f \n',AUC_PCA));

%medium
for i=1:size(test_features_medium,1)
    mean_test(i,:) = mean_t;
end
test_features_centered = test_features_medium - mean_test;
test_PCA_medium = test_features_centered * coeff;
[yhat, score_PCA] = predict(classifier, test_PCA_medium(:,1:opt_PCs));
[percentage_medium_in_easy_PCA, percentage_medium_in_hard_PCA ] = medium_testing( yhat, test_labels_medium);