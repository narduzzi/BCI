%Load all features

features_loic = process_recording('Recordings/af6_15032017_loic1/biosemi/data_loic1.bdf',...
    'Recordings/af6_15032017_loic1/unity/af6_15032017_ses_1_condition.txt');
%{
    Useless
features_ricardo = process_recording('Recordings/ag7_24032017_ricardo1/biosemi/data_ricardo1.bdf',...
    'Recordings/ag7_24032017_ricardo1/unity/ag7_24032017_ses_1_condition.txt');
%}

features_subj1 = process_recording('Recordings/subj1.bdf','Recordings/subj1_ses_1_condition.txt');
features_subj2 = process_recording('Recordings/subj2.bdf','Recordings/subj2_ses_1_condition.txt');
features_subj3 = process_recording('Recordings/subj3.bdf','Recordings/subj3_ses_1_condition.txt');

% create folds
[train_labels_loic,train_features_loic,x,y] = create_folds(features_loic,-1);
%[train_labels_ricardo,train_features_ricardo,x,y] = create_folds(features_ricardo,-1);
[test_labels_1,test_features_1,x,y] = create_folds(features_subj1,-1);
[test_labels_2,test_features_2,x,y] = create_folds(features_subj2,-1);
[test_labels_3,test_features_3,x,y] = create_folds(features_subj3,-1);

%Use leave-one-out-trajectory validation??

%Three best classifiers

%AF6 DLDA 460 Fisher
disp('Training first classifier : Fisher 460 DLDA');
nb_features_1 = 460;
[orderedInd_1, orderedPower] = rankfeat(train_features_loic, train_labels_loic, 'fisher');
classifier_dlda = fitcdiscr(train_features_loic(:,orderedInd_1(1:nb_features_1)), train_labels_loic, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');

%AF6 SVMLin 801 ReliefF
disp('Training second classifier : ReliefF 801 SVMLin');
nb_features_2= 801;
K=400;
[orderedInd_2, orderedPower] = relieff(train_features_loic, train_labels_loic, K);
classifier_svml = fitcsvm(train_features_loic(:,orderedInd_2(1:nb_features_2)),train_labels_loic,'KernelFunction','linear');

%AF6 DQDA 330 PCA
disp('Training third classifier : PCA 330 DQDA');
%TODO

%One bad classifier
%AH2 DQDA 280 PCA
disp('Training fourth classifier : PCA 280 DQDA');
%TODO

%%
%TESTING
disp('Testing classifier 1:');
%classifier 1 - subj1,2,3
[predicted_test_1,dlda_score1] = predict(classifier_dlda, test_features_1(:,orderedInd_1(1:nb_features_1)));
[predicted_test_2,dlda_score2] = predict(classifier_dlda, test_features_2(:,orderedInd_1(1:nb_features_1)));
[predicted_test_3,dlda_score3] = predict(classifier_dlda, test_features_3(:,orderedInd_1(1:nb_features_1)));

[X11,Y11,T11,AUC_dlda1] = perfcurve(test_labels_1, dlda_score1(:,2), 1);
[X12,Y12,T12,AUC_dlda2] = perfcurve(test_labels_2, dlda_score2(:,2), 1);
[X13,Y13,T13,AUC_dlda3] = perfcurve(test_labels_3, dlda_score3(:,2), 1);

s1 = sprintf('AUC classifier1 , subj1 = %0.4f',AUC_dlda1);
s2 = sprintf('AUC classifier1 , subj2 = %0.4f',AUC_dlda2);
s3 = sprintf('AUC classifier1 , subj3 = %0.4f',AUC_dlda3);
disp(s1);
disp(s2);
disp(s3);

figure;
plot(X11,Y11);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Subject1 : DLDA using Fisher (460 features)');
savefig('class1_sub1.fig');

figure;
plot(X12,Y12);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Subject2 : DLDA using Fisher (460 features)');
savefig('class1_sub2.fig');

figure;
plot(X13,Y13);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Subject3 : DLDA using Fisher (460 features)');
savefig('class1_sub3.fig');

%classifier 2 - sub1,2,3

[predicted_test_1,svml_score1] = predict(classifier_svml, test_features_1(:,orderedInd_2(1:nb_features_2)));
[predicted_test_2,svml_score2] = predict(classifier_svml, test_features_2(:,orderedInd_2(1:nb_features_2)));
[predicted_test_3,svml_score3] = predict(classifier_svml, test_features_3(:,orderedInd_2(1:nb_features_2)));

[X21,Y21,T11,AUC_svml1] = perfcurve(test_labels_1, svml_score1(:,2), 1);
[X22,Y22,T12,AUC_svml2] = perfcurve(test_labels_2, svml_score2(:,2), 1);
[X23,Y23,T13,AUC_svml3] = perfcurve(test_labels_3, svml_score3(:,2), 1);

s1 = sprintf('AUC classifier2 , subj1 = %0.4f',AUC_svml1);
s2 = sprintf('AUC classifier2 , subj2 = %0.4f',AUC_svml2);
s3 = sprintf('AUC classifier2 , subj3 = %0.4f',AUC_svml3);
disp(s1);
disp(s2);
disp(s3);

figure;
plot(X21,Y21);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Subject1 : SVMLin using ReliefF (801 features)');
savefig('class2_sub1.fig');

figure;
plot(X22,Y22);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Subject2 : SVMLin using ReliefF (801 features)');
savefig('class2_sub2.fig');

figure;
plot(X23,Y23);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Subject3 : SVMLin using ReliefF (801 features)');
savefig('class2_sub3.fig');
