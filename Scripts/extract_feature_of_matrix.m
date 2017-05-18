function extracted = extract_feature_of_matrix(matrix,windows_size,difficulty)
    shape = size(matrix);
    N = shape(2);
    
    features_matrix = [];
    
    str_f = sprintf('Features for difficulty %0.5f',difficulty);

    sizeidx = round(N/windows_size)+1;
    
    %Foreach window, extract feature
    for i=0:sizeidx
        startidx = (i*windows_size+1);
        endidx = startidx+windows_size;
        if(endidx>N)
            break;
        end
        
        index_of_trajectory = shape(1);
        last_electrode_indice = shape(1)-1;
        
        signal = matrix(1:last_electrode_indice,startidx:endidx);
        trajectory_num = matrix(index_of_trajectory,startidx:startidx);
        
        SS = size(signal);
        if((SS(1)==SS(2)) && (SS(1)==1))
            break;
        end
        
        features = [];
        %Extract feature for this window
        %-----------------------------------
        
        %extract frequency coefficients
        max_freq = 35;
        L = length(signal);
        n = 2^nextpow2(L);
        Y = fft(signal);
        P = abs(Y/n);
        frequency_coeff = P(:,1:max_freq);
        
        s = size(frequency_coeff);
        new_size = [1,s(1)*s(2)];
        frequency_coeff = reshape(frequency_coeff,new_size);
        
        %{
        %extract energy
        energy = periodogram(signal);
        s = size(energy);
        new_size = [1, s(1)*s(2)];
        energy = reshape(energy,new_size);
        %}
        
        %extract statistics
        statistics = [];
        smin = min(signal);
        smean = mean(signal);
        smedian = median(signal);
        smax = max(signal);
        svar = var(signal);
        smost_frequent = mode(signal);
        sdev = std(signal);
        
        statistics(1,:) = smin;
        statistics(2,:) = smean;
        statistics(3,:) = smedian;
       	statistics(4,:) = smax;
        statistics(5,:) = svar;
        statistics(6,:) = smost_frequent;
        statistics(7,:) = sdev;
        
        labels_stat = {'min','mean','median','max','var','most frequent value','dev'};
        
        s = size(statistics);
        new_size = [1, s(1)*s(2)];
        statistics = reshape(statistics,new_size);

        features = [difficulty trajectory_num frequency_coeff ];

        
        features_matrix = vertcat(features_matrix,features);
    end
    extracted = features_matrix;
end

        