%Basic model

%Pipeline : Processing (CAR,Downsampling) and feature extraction
features_session1 = process_recording('BDF_path','Conditon_Path',1);
features_session2 = process_recording('BDF_path2','Conditon_Path2',2);

%Create folds