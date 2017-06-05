function discriminant_analysis(features, nb_features)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



for traj=1:4
    traj
    %Determine the test and train tests
    [train_labels,train_features,test_labels,test_features] = create_folds(features,traj);
    [orderedInd, orderedPower] = rankfeat(train_features, train_labels, 'fisher');
    for i=1:nb_features
        i
        classifier_lda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
        yhat_lda = predict(classifier_lda, train_features(:,orderedInd(1:i))); 
        training_error_lda(traj,i) = classerror(train_labels, yhat_lda);
        yhat_lda = predict(classifier_lda, test_features(:,orderedInd(1:i)));
        testing_error_lda(traj,i) = classerror(test_labels, yhat_lda); 

        classifier_dlda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
        yhat_dlda = predict(classifier_dlda, train_features(:,orderedInd(1:i))); 
        training_error_dlda(traj,i) = classerror(train_labels, yhat_dlda);
        yhat_dlda = predict(classifier_dlda, test_features(:,orderedInd(1:i)));
        testing_error_dlda(traj,i) = classerror(test_labels, yhat_dlda); 

        %     classifier_qda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'Quadratic', 'Prior', 'uniform');
        %     yhat_qda = predict(classifier_qda, train_features(:,orderedInd(1:i))); 
        %     training_error_qda(traj,i) = classerror(train_labels, yhat_qda);
        %     yhat_qda = predict(classifier_qda, test_features(:,orderedInd(1:i)));
        %     testing_error_qda(traj,i) = classerror(test_labels, yhat_qda); 

        classifier_dqda = fitcdiscr(train_features(:,orderedInd(1:i)), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
        yhat_dqda = predict(classifier_dqda, train_features(:,orderedInd(1:i))); 
        training_error_dqda(traj,i) = classerror(train_labels, yhat_dqda);
        yhat_dqda = predict(classifier_dqda, test_features(:,orderedInd(1:i)));
        testing_error_dqda(traj,i) = classerror(test_labels, yhat_dqda); 
    end
    

end

cv_test_error_lda = mean(testing_error_lda);
cv_test_error_dlda = mean(testing_error_dlda);
cv_test_error_dqda = mean(testing_error_dqda);
cv_train_error_lda = mean(training_error_lda);
cv_train_error_dlda = mean(training_error_dlda);
cv_train_error_dqda = mean(training_error_dqda);


figure(1)
plot(1:nb_features, cv_test_error_lda);
hold on; 
plot(1:nb_features, cv_test_error_dlda);
hold on; 
plot(1:nb_features, cv_test_error_dqda);
hold on; 
plot(1:nb_features, cv_train_error_lda);
hold on; 
plot(1:nb_features, cv_train_error_dlda);
hold on; 
plot(1:nb_features, cv_train_error_dqda);
legend('test lda', 'test dlda', 'test dqda', 'train lda', 'train dlda', 'train dqda');
 
caca = 2;

%train_features = features(:,3:end);
%train_labels = features(:,1);


% Uncomment if quadratic is ok
% cv_error_lda = mean(testing_error_lda);
% cv_error_dlda = mean(testing_error_dlda);
% cv_error_qda = mean(testing_error_qda);
% cv_error_dqda = mean(testing_error_dqda);
% errors = [cv_error_lda cv_error_dlda cv_error_qda cv_error_dqda]
% cv_error = min(errors);
% classifier = [];
% if ( find(cv_error == errors) == 1)
%     classifier = 'linear';
% elseif ( find(cv_error == errors) == 2)
%     classifier = 'diaglinear';
% elseif ( find(cv_error == errors) == 3)
%     classifier = 'quadratic';
% elseif (find(cv_error == errors) == 4)
%     classifier = 'diagquadratic';
% end

