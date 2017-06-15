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

        %     classifier_qda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'Quadratic', 'Prior', 'uniform');
        %     yhat_qda = predict(classifier_qda, train_features(:,orderedInd(1:i))); 
        %     training_error_qda(traj,i) = classerror(train_labels, yhat_qda);
        %     yhat_qda = predict(classifier_qda, test_features(:,orderedInd(1:i)));
        %     testing_error_qda(traj,i) = classerror(test_labels, yhat_qda); 

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

end