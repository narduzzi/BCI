function [ signal ] = car( signal)
% This function takes the raw EEG signal and performs a re-referencement by
% the method CAR. 
% ATTENTION: This function assumes that the raw EEG signal has 64
% electrodes channels in the 64 first lines of the variable "signal". 


col = length(signal(1,:));

for i=1:col
    mean_signal = mean(signal(1:64,i));
    for j=1:64
        signal(j,i) = signal(j,i)-mean_signal;
    end
end

end

