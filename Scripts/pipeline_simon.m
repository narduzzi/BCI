%Simon Pipeline
ddpath(genpath('..\Recordings'));
session_train = 'ah2_10032017';
session_test = 'ah2_12042017';
user = 'simon';

path=strcat('Recordings/',session_train,'_',user,'_1','/biosemi/data',user,'_1','.bdf');
text=strcat('Recordings/',session_train,'_',user,'_1','/unity/',session_train,'_ses_1_condition.txt');


path2=strcat('Recordings/',session_test,'_',user,'_2','/biosemi/data',user,'_2','.bdf');
text2=strcat('Recordings/',session_test,'_',user,'_2','/unity/',session_train,'_ses_2_condition.txt');


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

disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down,signal_down] = downsampling(header,signal,downfactor);

disp('Applying car...');
%signal_filtered = car(signal_filtered);
signal_down = car(signal_down);
disp('CAR done.');

features_extracted_train = process_session1(signal_down1,header_down1);



%% SESSION 2

%Main part
disp('Loading data session 2...')
[signal2,header2] = sload(rawsignal);
signal2 = signal2';
%channel selection

disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down2,signal_down2] = downsampling(header2,signal2,downfactor);

disp('Applying car session2...');
signal_down2 = car(signal_down2);
disp('CAR done.');

features_extracted_test = process_session2(signal_down2,header_down2);


%% TRAINING and TESTING
[train_labels,train_features,null1,null2] = create_folds(features_extracted_train,-1);
[test_labels,test_features,null1,null2] = create_folds(features_extracted_test,-1);

%Fisher
nb_features_fisher = 610;
[orderedInd, orderedPower] = rankfeat(train_features, train_labels, 'fisher');
SVMModel_rbf = fitcsvm(train_features(:,orderedInd(1:nb_features_fisher)),train_labels,'KernelFunction','rbf');
[predicted_train,score] = predict(SVMModel_rbf,train_features(:,orderedInd(1:nb_features_fisher)));
training_error_SVM_rbf = classerror(train_labels,predicted_train);
[predicted_labels,score] = predict(SVMModel_rbf,test_features(:,orderedInd(1:nb_features_fisher)));
test_error_SVM_rbf = classerror(test_labels,predicted_labels);

%Relief
nb_features_relieff = 251;
K = 400;
[orderedInd, orderedPower] = relieff(train_features, train_labels, K);
classifier_dlda = fitcdiscr(train_features(:,orderedInd(1:nb_features_relieff)), train_labels, 'DiscrimTyp', 'DiagLinear', 'Prior', 'uniform');
yhat_dlda = predict(classifier_dlda, train_features(:,orderedInd(1:nb_features_relieff))); 
training_error_dlda = classerror(train_labels, yhat_dlda);
yhat_dlda = predict(classifier_dlda, test_features(:,orderedInd(1:nb_features_relieff)));
testing_error_dlda = classerror(test_labels, yhat_dlda); 