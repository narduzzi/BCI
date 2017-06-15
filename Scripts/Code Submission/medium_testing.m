function [ percentage_medium_in_easy, percentage_medium_in_hard ] = medium_testing( labels_predicted, test_labels )
%Function that counts how many medium samples are predicted as "easy" or
%"hard". The number in ouput is the % of medium samples predicted as easy
%(0 label). 

medium_labels = find(test_labels == 2); 
percentage_medium_in_easy = sum(labels_predicted(medium_labels) == 0)/length(medium_labels);
percentage_medium_in_hard = sum(labels_predicted(medium_labels) == 1)/length(medium_labels);


end

