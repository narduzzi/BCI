%Loic Pipeline
addpath(genpath('..\Recordings'));
session_train = 'af6_15032017';
session_test = 'af6_12042017';
user = 'loic';

path=strcat('Recordings/',session_train,'_',user,'1','/biosemi/data_',user,'1.bdf');
text=strcat('Recordings/',session_train,'_',user,'1','/unity/',session_train,'_ses_1_condition.txt');


path2=strcat('Recordings/',session_test,'_',user,'2','/biosemi/data_',user,'2.bdf');
text2=strcat('Recordings/',session_test,'_',user,'2','/unity/',session_test,'_ses_2_condition.txt');


%% SESSION 1
rawsignal = path;
downfactor = 8;
sampling_freq = 2048;
low=1;
high=40;
order=5;

%Main part
disp('Loading data...')
[signal,header] = sload(rawsignal);
signal = signal';
%channel selection
signal = signal(1:64,:);

disp(fprintf('Downsampling : Factor %0.0f \n',downfactor))
[header_down,signal_down] = downsampling(header, signal,downfactor);

disp('Applying car...');
%signal_filtered = car(signal_filtered);
signal_down = car(signal_down);
disp('CAR done.');
%%
features_extracted_train = process_session1(signal_down,header_down,text);



%% SESSION 2

%Main part
rawsignal = path2;
disp('Loading data session 2...')
[signal2,header2] = sload(rawsignal);
signal2 = signal2';
signal2 = signal2(1:64,:);

%channel selection
%%
disp(fprintf('Downsampling : Factor %0.0f \n',downfactor))
[header_down2,signal_down2] = downsampling(header2,signal2,downfactor);

disp('Applying car session2...');
signal_down2 = car(signal_down2);
disp('CAR done.');
%%
features_extracted_test = process_session2(signal_down2,header_down2);


%% TRAINING and TESTING
[train_labels,train_features,null1,null2] = create_folds(features_extracted_train,-1);
[test_labels,test_features,null1,null2] = create_folds(features_extracted_test,-1);
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

[X,Y,T,AUC_SVM] = perfcurve(test_labels, score(:,2), 1);

disp(fprintf('Train error on session 1 : %0.4f \n',training_error_dlda));
disp(fprintf('Test error on session 2 : %0.4f \n',testing_error_dlda));
disp(fprintf('AUC : %0.4f \n',AUC_SVM));

%%
%Fisher
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
