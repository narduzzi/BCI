function [ MODEL ] = model_PCA(features, nb_PCs)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


for traj=0:4
    disp(['Cross validation fold number ' int2str(traj+1)])
    %Determine the test and train tests
    disp('Evaluating PCA...')
    [train_labels,train_features,test_labels,test_features] = create_folds2(features,traj);
    [coeff train_PCA variance] = pca(train_features);
    % Attention: We have to center the testing data also
    mean_t = mean(train_features,1);
    mean_test = [];
    for i=1:size(test_features,1)
        mean_test(i,:) = mean_t;
    end
    test_features_centered = [];
    test_features_centered = test_features - mean_test;
    test_PCA = [];
    test_PCA = test_features_centered * coeff;
    j=0;
    for i=1:10:nb_PCs
        j=j+1;
        disp(['PC: ' int2str(i)])
        classifier_lda = fitcdiscr(train_PCA(:,1:i), train_labels, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
        yhat_lda = predict(classifier_lda, train_PCA(:,1:i)); 
        training_error_lda(traj+1,j) = classerror(train_labels, yhat_lda);
        yhat_lda = predict(classifier_lda, test_PCA(:,1:i));
        testing_error_lda(traj+1,j) = classerror(test_labels, yhat_lda); 

        classifier_dlda = fitcdiscr(train_PCA(:,1:i), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
        yhat_dlda = predict(classifier_dlda, train_PCA(:,1:i)); 
        training_error_dlda(traj+1,j) = classerror(train_labels, yhat_dlda);
        yhat_dlda = predict(classifier_dlda, test_PCA(:,1:i));
        testing_error_dlda(traj+1,j) = classerror(test_labels, yhat_dlda); 

        classifier_dqda = fitcdiscr(train_PCA(:,1:i), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
        yhat_dqda = predict(classifier_dqda, train_PCA(:,1:i)); 
        training_error_dqda(traj+1,j) = classerror(train_labels, yhat_dqda);
        yhat_dqda = predict(classifier_dqda, test_PCA(:,1:i));
        testing_error_dqda(traj+1,j) = classerror(test_labels, yhat_dqda);
        
        SVMModel_linear = fitcsvm(train_PCA(:,1:i),train_labels,'KernelFunction','linear');
        [predicted_train,score] = predict(SVMModel_linear,train_PCA(:,1:i));
        training_error_SVM_linear(traj+1,j) = classerror(train_labels,predicted_train);
        [predicted_labels,score] = predict(SVMModel_linear,test_PCA(:,1:i));
        test_error_SVM_linear(traj+1,j) = classerror(test_labels,predicted_labels);
        
        SVMModel_quadratic = fitcsvm(train_PCA(:,1:i),train_labels,'KernelFunction','polynomial');
        [predicted_train,score] = predict(SVMModel_quadratic,train_PCA(:,1:i));
        training_error_SVM_quadratic(traj+1,j) = classerror(train_labels,predicted_train);
        [predicted_labels,score] = predict(SVMModel_quadratic,test_PCA(:,1:i));
        test_error_SVM_quadratic(traj+1,j) = classerror(test_labels,predicted_labels);
        
        SVMModel_rbf = fitcsvm(train_PCA(:,1:i),train_labels,'KernelFunction','rbf');
        [predicted_train,score] = predict(SVMModel_rbf,train_PCA(:,1:i));
        training_error_SVM_rbf(traj+1,j) = classerror(train_labels,predicted_train);
        [predicted_labels,score] = predict(SVMModel_rbf,test_PCA(:,1:i));
        test_error_SVM_rbf(traj+1,j) = classerror(test_labels,predicted_labels);
    end
end


MODEL.TRAIN_ERROR.training_error_lda = training_error_lda;
MODEL.TRAIN_ERROR.training_error_dlda = training_error_dlda;
MODEL.TRAIN_ERROR.training_error_dqda = training_error_dqda;
MODEL.TRAIN_ERROR.training_error_SVM_linear = training_error_SVM_linear;
MODEL.TRAIN_ERROR.training_error_SVM_quadratic = training_error_SVM_quadratic;
MODEL.TRAIN_ERROR.training_error_SVM_rbf = training_error_SVM_rbf;

MODEL.TEST_ERROR.testing_error_lda = testing_error_lda;
MODEL.TEST_ERROR.testing_error_dlda = testing_error_dlda;
MODEL.TEST_ERROR.testing_error_dqda = testing_error_dqda;
MODEL.TEST_ERROR.test_error_SVM_linear = test_error_SVM_linear;
MODEL.TEST_ERROR.test_error_SVM_quadratic = test_error_SVM_quadratic;
MODEL.TEST_ERROR.test_error_SVM_rbf = test_error_SVM_rbf;
MODEL.PCsNb = nb_PCs;
MODEL.vectorNbPCs = 1:10:nb_PCs;

end