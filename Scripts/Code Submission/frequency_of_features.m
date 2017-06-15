function frequency = frequency_of_features(features)
    
    N = length(features);
    frequency = zeros(1,N);
    for i=1:N
        number = features(i);
        features_names(1,:) = mod((0:1983),31)+5;
        features_names(2,:) = floor((0:1983)/31)+1;
        frequency(i) = features_names(1,features(i));
    end