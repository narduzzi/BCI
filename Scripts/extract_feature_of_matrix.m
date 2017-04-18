function extracted = extract_feature_of_matrix(matrix,windows_size,difficulty)
    shape = size(matrix)
    N = shape(2)
    sizeidx = round(N/windows_size)+1;
    
    num_electrodes = shape(1);
    
    features_matrix = [];
    
    figure;
    str_f = sprintf('Features for difficulty %0.5f',difficulty);
    title(str_f);
    %Foreach window, extract feature
    for i=0:sizeidx
        endidx = (i*4+windows_size);
        if(endidx>N)
            endidx = N;
        end
        signal = matrix(:,(i*4+1):endidx)
        
        features = [];
        %Extract feature for this window
        %-----------------------------------
        %extract frequency coefficients
        frequency_coeff = [];
        
        %extract energy
        energy = periodogram(signal);
        
        %extract statistics
        statistics = []
        min = min(signal);
        mean = mean(signal);
        median = median(signal);
        max = max(signal);
        var = var(signal);
        most_frequent = mode(signal);
        dev = std(signal);
        
        statistics(1) = min;
        statistics(2) = mean;
        statistics(3) = median;
       	statistics(4) = max;
        statistics(5) = var;
        statistics(6) = most_frequent;
        statistics(7) = dev;
        
        labels_stat = {'min','mean','median','max','var','most frequent value','dev'}

        %extract eigenvalues
        eigenvector = peig(signal);
        
        %extract covariance
        covariance = pcov(signal);
      
        %-------Plotting----------
        ax1 = subplot(3,2,1);
        plot(ax1,signal);
        title(ax1,'Original signal');
        
        ax2 = subplot(3,2,2);
        plot(ax2,energy);
        title(ax2,'Energy');
        
        ax3 = subplot(3,2,3);
        plot(ax3,covariance);
        title(ax3,'Covariance');
        
        ax4 = subplot(3,2,4);
        plot(ax4,eigenvector);
        title(ax4,'Eigenvector');
        
        ax5 = subplot(3,2,5);
        plot(ax5,statistics);
        title(ax5,'Statistics');
        xticklabels(labels_stat);
       
        ax6 = subplot(3,2,6);
        plot(ax6,frequency_coeff );
        title(ax6,'Frequency Coefficients');
        
        %for analysis
        pause;
        
        
        
    end
    extracted = features_matrix;
end

        