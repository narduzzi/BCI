function [train_labels,train_features,test_labels,test_features] = create_folds(features_list,index_test)
%This function create folds for cross-validation. The trajectory == index_test is retained as
%test fold.

    shape = size(features_list);
    num_samples = shape(1);

    train_labels = [];
    train_features = [];
    test_labels = [];
    test_features = [];

    for i=1:num_samples
        sample = features_list(i,:);
        sample_label = sample(1);
        sample_features = sample(3:shape(2));

        if(sample(2)==index_test)
            test_labels = vertcat(test_labels,sample_label);
            test_features = vertcat(test_features,sample_features);
        else
            train_labels = vertcat(train_labels,sample_label);
            train_features = vertcat(train_features,sample_features);
        end
    end
end