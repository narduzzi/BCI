function electrode_spectrum(easy,hard,Fs,header_down)
    n_electrodes = size(easy,1);
    
    max_pages = 4
    for index = 0:max_pages-1
        figure(index+1);
        for i = index*n_electrodes/max_pages+1 : (index+1)*n_electrodes/max_pages

            ax1 = subplot(4,4,mod(i-1,4*4)+1);

            label = header_down.Label(i);
            label = label{1};

            s_easy = easy(i,:);
            s_hard = hard(i,:);

            h = spectrum.welch; % creates the Welch spectrum estimator
            spectrum_easy=psd(h,s_easy,'Fs',Fs); % calculates and plot the one sided PSD
            spectrum_hard=psd(h,s_hard,'Fs',Fs);

            plot(spectrum_easy.Data,'b'); % Plot the one-sided PSD. 
            hold on;
            plot(spectrum_hard.Data,'r');
            axis([0 50 0 20])
            title(sprintf('%s',label));
            hold off;
        end
        pause;
    end
end
