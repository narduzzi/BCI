function [TRAIN_ERROR,TEST_ERROR] = model_reliefF(features, max_nb_features,K)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for traj=0:4
    disp(['Cross validation fold number ' int2str(traj)])
    %Determine the test and train tests
    [train_labels,train_features,test_labels,test_features] = create_folds(features,traj);
    [orderedInd, orderedPower] = relieff(train_features, train_labels, K);
    j=0;
    for i=1:10:max_nb_features
        j=j+1;
        disp(['Feature: ' int2str(i)])
        classifier_lda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
        yhat_lda = predict(classifier_lda, train_features(:,orderedInd(1:i))); 
        training_error_lda(traj+1,j) = classerror(train_labels, yhat_lda);
        yhat_lda = predict(classifier_lda, test_features(:,orderedInd(1:i)));
        testing_error_lda(traj+1,j) = classerror(test_labels, yhat_lda); 

        classifier_dlda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
        yhat_dlda = predict(classifier_dlda, train_features(:,orderedInd(1:i))); 
        training_error_dlda(traj+1,j) = classerror(train_labels, yhat_dlda);
        yhat_dlda = predict(classifier_dlda, test_features(:,orderedInd(1:i)));
        testing_error_dlda(traj+1,j) = classerror(test_labels, yhat_dlda); 

        classifier_dqda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
        yhat_dqda = predict(classifier_dqda, train_features(:,orderedInd(1:i))); 
        training_error_dqda(traj+1,j) = classerror(train_labels, yhat_dqda);
        yhat_dqda = predict(classifier_dqda, test_features(:,orderedInd(1:i)));
        testing_error_dqda(traj+1,j) = classerror(test_labels, yhat_dqda);
        
        SVMModel_linear = fitcsvm(train_features(:,orderedInd(1:i)),train_labels,'KernelFunction','linear');
        [predicted_train,score] = predict(SVMModel_linear,train_features(:,orderedInd(1:i)));
        training_error_SVM_linear(traj+1,j) = classerror(train_labels,predicted_train);
        [predicted_labels,score] = predict(SVMModel_linear,test_features(:,orderedInd(1:i)));
        test_error_SVM_linear(traj+1,j) = classerror(test_labels,predicted_labels);
        
        SVMModel_quadratic = fitcsvm(train_features(:,orderedInd(1:i)),train_labels,'KernelFunction','polynomial');
        [predicted_train,score] = predict(SVMModel_quadratic,train_features(:,orderedInd(1:i)));
        training_error_SVM_quadratic(traj+1,j) = classerror(train_labels,predicted_train);
        [predicted_labels,score] = predict(SVMModel_quadratic,test_features(:,orderedInd(1:i)));
        test_error_SVM_quadratic(traj+1,j) = classerror(test_labels,predicted_labels);
        
        SVMModel_rbf = fitcsvm(train_features(:,orderedInd(1:i)),train_labels,'KernelFunction','rbf');
        [predicted_train,score] = predict(SVMModel_rbf,train_features(:,orderedInd(1:i)));
        training_error_SVM_rbf(traj+1,j) = classerror(train_labels,predicted_train);
        [predicted_labels,score] = predict(SVMModel_rbf,test_features(:,orderedInd(1:i)));
        test_error_SVM_rbf(traj+1,j) = classerror(test_labels,predicted_labels);
    end
end

TRAIN_ERROR.training_error_lda = training_error_lda;
TRAIN_ERROR.training_error_dlda = training_error_dlda;
TRAIN_ERROR.training_error_dqda = training_error_dqda;
TRAIN_ERROR.training_error_SVM_linear = training_error_SVM_linear;
TRAIN_ERROR.training_error_SVM_quadratic = training_error_SVM_quadratic;
TRAIN_ERROR.training_error_SVM_rbf = training_error_SVM_rbf;

TEST_ERROR.testing_error_lda = testing_error_lda;
TEST_ERROR.testing_error_dlda = testing_error_dlda;
TEST_ERROR.testing_error_dqda = testing_error_dqda;
TEST_ERROR.test_error_SVM_linear = test_error_SVM_linear;
TEST_ERROR.test_error_SVM_quadratic = test_error_SVM_quadratic;
TEST_ERROR.test_error_SVM_rbf = test_error_SVM_rbf;

testing_error_lda = NCA_TEST_ERROR.testing_error_lda;
testing_error_dlda = NCA_TEST_ERROR.testing_error_dlda;
testing_error_dqda = NCA_TEST_ERROR.testing_error_dqda;
test_error_SVM_linear = NCA_TEST_ERROR.test_error_SVM_linear;
test_error_SVM_quadratic = NCA_TEST_ERROR.test_error_SVM_quadratic ;
test_error_SVM_rbf = NCA_TEST_ERROR.test_error_SVM_rbf;

training_error_lda = NCA_TRAIN_ERROR.training_error_lda;
training_error_dlda = NCA_TRAIN_ERROR.training_error_dlda ;
training_error_dqda = NCA_TRAIN_ERROR.training_error_dqda;
training_error_SVM_linear = NCA_TRAIN_ERROR.training_error_SVM_linear;
training_error_SVM_quadratic = NCA_TRAIN_ERROR.training_error_SVM_quadratic;
training_error_SVM_rbf = NCA_TRAIN_ERROR.training_error_SVM_rbf;
nb_features = 1000;

%% 
cv_test_error_lda = mean(testing_error_lda);
cv_test_error_dlda = mean(testing_error_dlda);
cv_test_error_dqda = mean(testing_error_dqda);
cv_test_error_SVM_linear = mean(test_error_SVM_linear);
cv_test_error_SVM_quadratic = mean(test_error_SVM_quadratic);
cv_test_error_SVM_rbf = mean(test_error_SVM_rbf);

cv_train_error_lda = mean(training_error_lda);
cv_train_error_dlda = mean(training_error_dlda);
cv_train_error_dqda = mean(training_error_dqda);
cv_train_error_SVM_linear = mean(training_error_SVM_linear);
cv_train_error_SVM_quadratic = mean(training_error_SVM_quadratic);
cv_train_error_SVM_rbf = mean(training_error_SVM_rbf);

%%
std_test_error_lda = std(testing_error_lda);
std_test_error_dlda = std(testing_error_dlda);
std_test_error_dqda = std(testing_error_dqda);
std_test_error_SVM_linear = std(test_error_SVM_linear);
std_test_error_SVM_quadratic = std(test_error_SVM_quadratic);
std_test_error_SVM_rbf = std(test_error_SVM_rbf);

std_train_error_lda = std(training_error_lda);
std_train_error_dlda = std(training_error_dlda);
std_train_error_dqda = std(training_error_dqda);
std_train_error_SVM_linear = std(training_error_SVM_linear);
std_train_error_SVM_quadratic = std(training_error_SVM_quadratic);
std_train_error_SVM_rbf = std(training_error_SVM_rbf);

figure(1)
plot(1:10:nb_features, cv_test_error_lda);
hold on; 
plot(1:10:nb_features, cv_test_error_dlda);
hold on; 
plot(1:10:nb_features, cv_test_error_dqda);
hold on;
plot(1:10:nb_features, cv_test_error_SVM_linear);
hold on; 
plot(1:10:nb_features, cv_test_error_SVM_quadratic);
hold on; 
plot(1:10:nb_features, cv_test_error_SVM_rbf);
hold on;
plot(1:10:nb_features, cv_train_error_lda);
hold on; 
plot(1:10:nb_features, cv_train_error_dlda);
hold on; 
plot(1:10:nb_features, cv_train_error_dqda);
hold on
plot(1:10:nb_features, cv_train_error_SVM_linear);
hold on
plot(1:10:nb_features, cv_train_error_SVM_quadratic);
hold on
plot(1:10:nb_features, cv_train_error_SVM_rbf);
legend('test lda', 'test dlda', 'test dqda','test SVM_l','test SVM_q','test SVM_rbf', 'train lda', 'train dlda', 'train dqda','train SVM_l','train SVM_q','train SVM_q');

%%
close all;
figure(2)
plot(1:10:nb_features, std_test_error_lda+cv_test_error_lda, '--', 'Color', 'r', 'LineWidth', 0.3)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_lda+cv_test_error_lda, '--', 'Color', 'r')
hold on;
plot(1:10:nb_features, cv_test_error_lda, 'Color', 'r', 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, std_test_error_dlda+cv_test_error_dlda, '--', 'Color', 'b')
hold on;
plot(1:10:nb_features, (-1)*std_test_error_dlda+cv_test_error_dlda, '--', 'Color', 'b')
hold on;
plot(1:10:nb_features, cv_test_error_dlda, 'Color', 'b', 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, std_test_error_dqda+cv_test_error_dqda, '--', 'Color', 'g')
hold on;
plot(1:10:nb_features, (-1)*std_test_error_dqda+cv_test_error_dqda, '--', 'Color', 'g')
hold on;
plot(1:10:nb_features, cv_test_error_dqda, 'Color', 'g', 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, std_train_error_lda+cv_train_error_lda, '--', 'Color', 'k')
hold on;
plot(1:10:nb_features, (-1)*std_train_error_lda+cv_train_error_lda, '--', 'Color', 'k')
hold on;
plot(1:10:nb_features, cv_train_error_lda, 'Color', 'k', 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, std_train_error_dlda+cv_train_error_dlda, '--', 'Color', 'm')
hold on;
plot(1:10:nb_features, (-1)*std_train_error_dlda+cv_train_error_dlda, '--', 'Color', 'm')
hold on;
plot(1:10:nb_features, cv_train_error_dlda, 'Color', 'm', 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, std_train_error_dqda+cv_train_error_dqda, '--', 'Color', 'y')
hold on;
plot(1:10:nb_features, (-1)*std_train_error_dqda+cv_train_error_dqda, '--', 'Color', 'y')
hold on;
plot(1:10:nb_features, cv_train_error_dqda, 'Color', 'y', 'LineWidth', 2);
hold on; 


figure(3)
plot(1:10:nb_features, cv_test_error_lda, 'Color', 'r', 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_test_error_dlda, 'Color', [1 17 181] ./ 255, 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_test_error_dqda, 'Color', [3 155 82] ./ 255, 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_train_error_lda, 'Color', [250 110 150] ./ 255, 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_train_error_dlda, 'Color', [28 200 238] ./ 255, 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, cv_train_error_dqda, 'Color', [94 250 81] ./ 255, 'LineWidth', 2);
legend('Test LDA', 'Test DLDA', 'Test DQDA', 'Train LDA', 'Train DLDA', 'Train DQDA')
hold on;
plot(1:10:nb_features, std_test_error_lda+cv_test_error_lda, '--', 'Color', 'r', 'LineWidth', 0.3)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_lda+cv_test_error_lda, '--', 'Color', 'r')
hold on; 
plot(1:10:nb_features, std_test_error_dlda+cv_test_error_dlda, '--', 'Color', [1 17 181] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_dlda+cv_test_error_dlda, '--', 'Color', [1 17 181] ./ 255)
hold on;
plot(1:10:nb_features, std_test_error_dqda+cv_test_error_dqda, '--', 'Color', [3 155 82] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_dqda+cv_test_error_dqda, '--', 'Color', [3 155 82] ./ 255)
hold on;
plot(1:10:nb_features, std_train_error_lda+cv_train_error_lda, '--', 'Color', [250 110 150] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_train_error_lda+cv_train_error_lda, '--', 'Color', [250 110 150] ./ 255)
hold on;
plot(1:10:nb_features, std_train_error_dlda+cv_train_error_dlda, '--', 'Color', [28 200 238] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_train_error_dlda+cv_train_error_dlda, '--', 'Color', [28 200 238] ./ 255)
hold on;
plot(1:10:nb_features, std_train_error_dqda+cv_train_error_dqda, '--', 'Color', [94 250 81] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_train_error_dqda+cv_train_error_dqda, '--', 'Color', [94 250 81] ./ 255)
title('Fisher feature selection')
xlabel('Number of features')
ylabel('Class error');

figure(4)
plot(1:10:nb_features, cv_test_error_SVM_linear, 'Color', 'r', 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_test_error_SVM_quadratic, 'Color', [1 17 181] ./ 255, 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_test_error_SVM_rbf, 'Color', [3 155 82] ./ 255, 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_train_error_SVM_linear, 'Color', [250 110 150] ./ 255, 'LineWidth', 2);
hold on;
plot(1:10:nb_features, cv_train_error_SVM_quadratic, 'Color', [28 200 238] ./ 255, 'LineWidth', 2);
hold on; 
plot(1:10:nb_features, cv_train_error_SVM_rbf, 'Color', [94 250 81] ./ 255, 'LineWidth', 2);
legend('Test SVM Lin', 'Test SVM Qua', 'Test SVM RBF', 'Train SVM Lin', 'Train SVM Qua', 'Train SVM RBF')
hold on;
plot(1:10:nb_features, std_test_error_SVM_linear+cv_test_error_SVM_linear, '--', 'Color', 'r', 'LineWidth', 0.3)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_SVM_linear+cv_test_error_SVM_linear, '--', 'Color', 'r')
hold on; 
plot(1:10:nb_features, std_test_error_SVM_quadratic+cv_test_error_SVM_quadratic, '--', 'Color', [1 17 181] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_SVM_quadratic+cv_test_error_SVM_quadratic, '--', 'Color', [1 17 181] ./ 255)
hold on;
plot(1:10:nb_features, std_test_error_SVM_rbf+cv_test_error_SVM_rbf, '--', 'Color', [3 155 82] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_test_error_SVM_rbf+cv_test_error_SVM_rbf, '--', 'Color', [3 155 82] ./ 255)
hold on;
plot(1:10:nb_features, std_train_error_SVM_linear+cv_train_error_SVM_linear, '--', 'Color', [250 110 150] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_train_error_SVM_linear+cv_train_error_SVM_linear, '--', 'Color', [250 110 150] ./ 255)
hold on;
plot(1:10:nb_features, std_train_error_SVM_quadratic+cv_train_error_SVM_quadratic, '--', 'Color', [28 200 238] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_train_error_SVM_quadratic+cv_train_error_SVM_quadratic, '--', 'Color', [28 200 238] ./ 255)
hold on;
plot(1:10:nb_features, std_train_error_SVM_rbf+cv_train_error_SVM_rbf, '--', 'Color', [94 250 81] ./ 255)
hold on;
plot(1:10:nb_features, (-1)*std_train_error_SVM_rbf+cv_train_error_SVM_rbf, '--', 'Color', [94 250 81] ./ 255)
hold on;
title('Fisher feature selection')
xlabel('Number of features')
ylabel('Class error');

end