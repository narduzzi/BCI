function electrodes = electrodes_containing_features(features)
    
    N = length(features);
    electrodes = zeros(1,N);
    for i=1:N
        number = features(i);
        features_names(1,:) = mod((0:1983),31)+5;
        features_names(2,:) = floor((0:1983)/31)+1;
        electrodes(i) = features_names(2,features(i));
    end