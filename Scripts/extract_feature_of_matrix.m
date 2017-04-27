function extracted = extract_feature_of_matrix(matrix,windows_size,difficulty)
    shape = size(matrix);
    N = shape(2);
    sizeidx = round(N/windows_size)+1;
    plotting = false;
    num_electrodes = shape(1);
    
    features_matrix = [];
    
    str_f = sprintf('Features for difficulty %0.5f',difficulty);

    %Foreach window, extract feature
    for i=0:sizeidx
        endidx = (i*4+windows_size);
        if(endidx>N)
            endidx = N;
        end
        
        startidx = (i*4+1);
        if(startidx>endidx-1)
            break;
        end
        
        if(i>20000)
            break;
        end
        
        signal = matrix(:,startidx:endidx);
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

        %extract eigenvalues
        %eigenvalues = eig(signal);
        %s = size(eigenvalues);
        %new_size = [1,s(1)*s(2)];
        %eigenvalues = reshape(eigenvalues,new_size);
        
        %{
        %extract eigenvectors
        fs = 100;
        eigenvectors = peig(signal,2,512,fs,'half');
        s = size(eigenvectors);
        new_size = [1,s(1)*s(2)];
        eigenvectors = reshape(eigenvectors,new_size);
        %}
        
        %extract covariance
        %covariance = pcov(signal);
        %s = size(covariance);
        % new_size = [1,s(1)*s(2)];
        %covariance = reshape(covariance,new_size);
     
        % conc
        %features = [difficulty statistics energy frequency_coeff eigenvalues eigenvectors covariance];
      
        %features = [difficulty statistics frequency_coeff ];
        features = [difficulty frequency_coeff ];

        %{
        if(plotting==true)
            figure;
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
        %}
        
        features_matrix = vertcat(features_matrix,features);
    end
    extracted = features_matrix;
end

        