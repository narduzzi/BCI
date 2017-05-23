function [ classifier, cv_error ] = discriminant_analysis(data,nclasses)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

labels = data(:,1);
dataset = data(:,2:end);


nsamples = length(data(:,1));
cp = cvpartition(nsamples, 'kfold', 10);

for i=1:5
    train_set = dataset(find(training(cp,i)),:);
    labels_train_set = labels(find(training(cp,i)),:);
    test_set = dataset(find(test(cp,i)),:);
    labels_test_set= labels(find(test(cp,i)),:);
    
    classifier_lda = fitcdiscr(train_set, labels_train_set, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
    yhat_lda = predict(classifier_lda, train_set); 
    training_error_lda(i) = classerror(labels_train_set, yhat_lda);
    yhat_lda = predict(classifier_lda, test_set);
    testing_error_lda(i) = classerror(labels_test_set, yhat_lda); 
    
    classifier_dlda = fitcdiscr(train_set, labels_train_set, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
    yhat_dlda = predict(classifier_dlda, train_set); 
    training_error_dlda(i) = classerror(labels_train_set, yhat_dlda);
    yhat_dlda = predict(classifier_dlda, test_set);
    testing_error_dlda(i) = classerror(labels_test_set, yhat_dlda); 
    
%     classifier_qda = fitcdiscr(train_set, labels_train_set, 'DiscrimTyp', 'Quadratic', 'Prior', 'uniform');
%     yhat_qda = predict(classifier_qda, train_set); 
%     training_error_qda(i) = classerror(labels_train_set, yhat_qda);
%     yhat_qda = predict(classifier_qda, test_set);
%     testing_error_qda(i) = classerror(labels_test_set, yhat_qda); 
     
    classifier_dqda = fitcdiscr(train_set, labels_train_set, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
    yhat_dqda = predict(classifier_dqda, train_set); 
    training_error_dqda(i) = classerror(labels_train_set, yhat_dqda);
    yhat_dqda = predict(classifier_dqda, test_set);
    testing_error_dqda(i) = classerror(labels_test_set, yhat_dqda); 
    

end

cv_error_lda = mean(testing_error_lda);
cv_error_dlda = mean(testing_error_dlda);
cv_error_dqda = mean(testing_error_dqda);
errors = [cv_error_lda cv_error_dlda cv_error_dqda]
cv_error = min(errors);
classifier = [];
if ( find(cv_error == errors) == 1)
    classifier = 'linear';
elseif ( find(cv_error == errors) == 2)
    classifier = 'diaglinear';
elseif (find(cv_error == errors) == 3)
    classifier = 'diagquadratic';
end


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


% data = [1 10 3 45 67 9 ; 0 1 1 1 40 40 ; 0 6 1 10 50 20 ; 0 6 1 19 50 200 ; 0 1 13 10 4 20 ; 1 10 3 45 67 9 ; 1 13 5 79 45 15 ; 1 5 4 7 34 4] 
