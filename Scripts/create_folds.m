function [train,test] = create_folds(features_list,index_test)
%This function create folds. The trajectory == index_test is retained as
%test fold.
    shape = size(features_list);
    num_samples = shape(1);

    test = [];
    train = [];

    for i=1:num_samples
        sample = features_list(i,:);
        sample_label = sample(1);
        sample_features = sample(3:shape(2));
        new_sample = [sample_label sample_features];

        if(sample(2)==index_test)
            test = vertcat(test,new_sample);
        else
            train = vertcat(train,new_sample);
        end
    end
end