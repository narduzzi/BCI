function features_list = features_extraction(easy,hard,hard_assistance,header,window_size,step_size)
    
    splitted_easy = split(easy,window_size,step_size);
    splitted_hard = split(hard,window_size,step_size);
    splitted_hard_assist = split(hard_assistance,window_size,step_size);
    disp('Extracting features for difficulty : easy');
    FeatEasy = extract_feature_of_matrix(splitted_easy,window_size,0);
    disp('Extracting features for difficulty : hard');
    FeatHard = extract_feature_of_matrix(splitted_hard,window_size,1);
    
    if(hard_assistance~=-1)
        disp('Extracting features for difficulty : hard with assistance');
        FeatHardAssist = extract_feature_of_matrix(splitted_hard_assist,window_size,2);
        features_list = vertcat(FeatEasy,FeatHard,FeatHardAssist);
    else
         features_list = vertcat(FeatEasy,FeatHard);
    end
    