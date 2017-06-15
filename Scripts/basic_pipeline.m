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
[train_label,train_features,val_label,val_features] = create_folds(features_session1,trajectory_out_train);
[test_label,test_features,n1,n2] = create_folds(features_session2,-1);
[medium_label,medium_features,n1,n2] = create_folds(features_mediums_session2,-1);

%%Train models here

%Test models here

%Test medium classification here

