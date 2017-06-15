function extracted = extract_feature_of_matrix(matrix,windows_size,difficulty)
    shape = size(matrix);
    N = shape(2);
    
    features_matrix = [];
    
    str_f = sprintf('Features for difficulty %0.5f',difficulty);
    sizeidx = round(N/windows_size)+1;
    
    %Foreach window, extract feature
    for i=0:sizeidx
        startidx = i*windows_size+1;
        endidx = startidx+windows_size-1;
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
        min_freq = 5;
        max_freq = 35;
        min_freq = 5;
        L = length(signal);
        n = 2^nextpow2(L);
        Y = fft(signal);
        P = abs(Y/n);
        frequency_coeff = P(:,min_freq:max_freq);
        
        s = size(frequency_coeff);
        new_size = [1,s(1)*s(2)];

        frequency_coeff = reshape(frequency_coeff,new_size);          
    

        features = [difficulty trajectory_num frequency_coeff];

        features_matrix = vertcat(features_matrix,features);
    end
    extracted = features_matrix;
end

        