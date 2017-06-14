function [MODEL] = model_FFS(features)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

opt = statset('Display','iter','MaxIter', 100);

for traj=1:5
    j = traj-1;
    disp(['Cross validation fold number ' int2str(j)])
    %Determine the test and train tests
    disp('Evaluating Linear FFS...')
    [train_labels,train_features,test_labels,test_features] = create_folds(features,j);
    fun = @(xT,yT) (classerror(yT,predict(fitcdiscr(xT,yT,'discrimtype', 'Linear', 'Prior', 'uniform'), xT)));    
    [selected_lda,hst_lda(traj)] = sequentialfs(fun,train_features,train_labels,'cv','none','options',opt);
    valid_error_lda(traj) = hst_lda(traj).Crit(end);
    classifier_lda = fitcdiscr(train_features(:, selected_lda), train_labels, 'DiscrimTyp', 'Linear', 'Prior', 'uniform');
    yhat_lda = predict(classifier_lda, test_features(:,selected_lda));
    testing_error_lda(traj) = classerror(test_labels, yhat_lda);
    MODEL.SELECTED.lda{traj} = selected_lda;
    
    disp('Evaluating DiagLinear FFS...')
%     fun = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype', 'DiagLinear', 'Prior', 'uniform'), xt)));
    fun = @(xT,yT) (classerror(yT,predict(fitcdiscr(xT,yT,'discrimtype', 'DiagLinear', 'Prior', 'uniform'), xT)));
    [selected_dlda,hst_dlda(traj)] = sequentialfs(fun,train_features,train_labels,'cv','none','options',opt);
    valid_error_dlda(traj) = hst_dlda(traj).Crit(end);
    classifier_dlda = fitcdiscr(train_features(:, selected_dlda), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
    yhat_dlda = predict(classifier_dlda, test_features(:,selected_dlda));
    testing_error_dlda(traj) = classerror(test_labels, yhat_dlda);
    MODEL.SELECTED.dlda{traj} = selected_dlda;
    
    disp('Evaluating Diagquadratic FFS...')
%     fun = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype', 'DiagQuadratic', 'Prior', 'uniform'), xt)));
    fun = @(xT,yT) (classerror(yT,predict(fitcdiscr(xT,yT,'discrimtype', 'DiagQuadratic', 'Prior', 'uniform'), xT)));
    [selected_dqda,hst_dqda(traj)] = sequentialfs(fun,train_features,train_labels,'cv','none','options',opt);
    valid_error_dqda(traj) = hst_dqda(traj).Crit(end);
    classifier_dqda = fitcdiscr(train_features(:, selected_dqda), train_labels, 'DiscrimTyp', 'DiagQuadratic', 'Prior', 'uniform');
    yhat_dqda = predict(classifier_dqda, test_features(:,selected_dqda));
    testing_error_dqda(traj) = classerror(test_labels, yhat_dqda);
    MODEL.SELECTED.dqda{traj} = selected_dqda;
    
    disp('Evaluating SVM linear FFS...')
    fun = @(xT,yT) (classerror(yT,predict(fitcsvm(xT,yT,'KernelFunction','linear'), xT)));    
    [selected_svml ,hst_svml(traj)] = sequentialfs(fun,train_features,train_labels,'cv','none','options',opt);
    valid_error_svml(traj) = hst_svml(traj).Crit(end);
    classifier_svml = fitcsvm(train_features(:, selected_svml), train_labels, 'KernelFunction','linear');
    yhat_svml = predict(classifier_svml, test_features(:,selected_svml));
    testing_error_svml(traj) = classerror(test_labels, yhat_svml);
    MODEL.SELECTED.svml{traj} = selected_svml;
    
    %{
    disp('Evaluating SVM quadratic FFS...')
    fun = @(xT,yT) (classerror(yT,predict(fitcsvm(xT,yT,'KernelFunction','polynomial'), xT)));    
    [selected_svmq,hst_svmq(traj)] = sequentialfs(fun,train_features,train_labels,'cv','none','options',opt);
    valid_error_svmq(traj) = hst_svmq(traj).Crit(end);
    classifier_svmq = fitcsvm(train_features(:, selected_svmq), train_labels, 'KernelFunction','polynomial');
    yhat_svmq = predict(classifier_svmq, test_features(:,selected_svmq));
    testing_error_svmq(traj) = classerror(test_labels, yhat_svmq);    
    MODEL.SELECTED.svmq{traj} = selected_svmq;
    
    disp('Evaluating SVM guaussian FFS...')
    fun = @(xT,yT) (classerror(yT,predict(fitcsvm(xT,yT,'KernelFunction','rbf'), xT)));    
    [selected_svmrbf,hst_svmrbf(traj)] = sequentialfs(fun,train_features,train_labels,'cv','none','options',opt);
    valid_error_svmrbf(traj) = hst_svmrbf(traj).Crit(end);
    classifier_svmrbf = fitcsvm(train_features(:, selected_svmrbf), train_labels, 'KernelFunction','rbf');
    yhat_svmrbf = predict(classifier_svmrbf, test_features(:,selected_svmrbf));
    testing_error_svmrbf(traj) = classerror(test_labels, yhat_svmrbf);
    MODEL.SELECTED.svmrbf{traj} = selected_svmrbf;
    %}
end



save('model_FFS');

MODEL.TRAIN_ERROR.training_error_lda = valid_error_lda;
MODEL.TRAIN_ERROR.training_error_dlda = valid_error_dlda;
MODEL.TRAIN_ERROR.training_error_dqda = valid_error_dqda;
MODEL.TRAIN_ERROR.training_error_SVM_linear = valid_error_svml;
%MODEL.TRAIN_ERROR.training_error_SVM_quadratic = valid_error_SVM_quadratic;
%MODEL.TRAIN_ERROR.training_error_SVM_rbf = valid_error_SVM_rbf;

MODEL.TEST_ERROR.testing_error_lda = testing_error_lda;
MODEL.TEST_ERROR.testing_error_dlda = testing_error_dlda;
MODEL.TEST_ERROR.testing_error_dqda = testing_error_dqda;
MODEL.TEST_ERROR.test_error_SVM_linear = testing_error_svml;
%MODEL.TEST_ERROR.test_error_SVM_quadratic = testing_error_SVM_quadratic;
%MODEL.TEST_ERROR.test_error_SVM_rbf = testing_error_SVM_rbf;


save('model_FFS');
% cv_test_error_lda = mean(testing_error_lda);
% cv_test_error_dlda = mean(testing_error_dlda);
% cv_test_error_dqda = mean(testing_error_dqda);
% cv_test_error_SVM_linear = mean(test_error_SVM_linear);
% cv_test_error_SVM_quadratic = mean(test_error_SVM_quadratic);
% cv_test_error_SVM_rbf = mean(test_error_SVM_rbf);
% 
% cv_train_error_lda = mean(training_error_lda);
% cv_train_error_dlda = mean(training_error_dlda);
% cv_train_error_dqda = mean(training_error_dqda);
% cv_train_error_SVM_linear = mean(training_error_SVM_linear);
% cv_train_error_SVM_quadratic = mean(training_error_SVM_quadratic);
% cv_train_error_SVM_rbf = mean(training_error_SVM_rbf);
%%
% figure(1)
% plot(1:nb_features, cv_test_error_lda);
% hold on; 
% plot(1:nb_features, cv_test_error_dlda);
% hold on; 
% plot(1:nb_features, cv_test_error_dqda);
% hold on;
% plot(1:nb_features, cv_test_error_SVM_linear);
% hold on; 
% plot(1:nb_features, cv_test_error_SVM_quadratic);
% hold on; 
% plot(1:nb_features, cv_test_error_SVM_rbf);
% hold on;
% plot(1:nb_features, cv_train_error_lda);
% hold on; 
% plot(1:nb_features, cv_train_error_dlda);
% hold on; 
% plot(1:nb_features, cv_train_error_dqda);
% hold on
% plot(1:nb_features, cv_train_error_SVM_linear);
% hold on
% plot(1:nb_features, cv_train_error_SVM_quadratic);
% hold on
% plot(1:nb_features, cv_train_error_SVM_rbf);
% legend('test lda', 'test dlda', 'test dqda','test SVM_l','test SVM_q','test SVM_rbf', 'train lda', 'train dlda', 'train dqda','train SVM_l','train SVM_q','train SVM_q');
 
end

