function x_labels = get_name_of_features(features)
    
    N = length(features);
    x_labels = cell(1,N);
    for i=1:N
        number = features(i);
        features_names(1,:) = mod((0:1983),31)+5;
        features_names(2,:) = floor((0:1983)/31)+1;
        s = strcat('Electrode',num2str(features_names(2,number)),'',' | ',num2str(features_names(1,number)),'Hz');
        x_labels{i} = s;
    end