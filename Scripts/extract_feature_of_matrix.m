function extracted = extract_feature_of_matrix(matrix,windows_size,difficulty)
    shape = size(matrix)
    N = shape(2)
    sizeidx = round(N/windows_size)+1;
    
    %Foreach window, extract feature
    for i=0:sizeidx
        endidx = (i*4+windows_size);
        if(endidx>N)
            endidx = N;
        end
        window = matrix(:,(i*4+1):endidx)
        
        %Extract feature for this window
        %-----------------------------------
        %extract frequency coefficients
        
        %extract energy
        
        %extract statistics
        
        %extract eigenvalues
        
        
    end
    
end

        