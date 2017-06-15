function [train_labels,train_features,test_labels,test_features] = create_folds2(features_list,index_test)
%Second version of create folds to create folds of trajectories for
%cross-validation


idx_test = find(features_list(:,2)==index_test);

test_features = features_list(idx_test,3:end);
test_labels = features_list(idx_test,1);

idx_train = find(features_list(:,2) ~=index_test);

train_features = features_list(idx_train,3:end);
train_labels = features_list(idx_train,1);

end