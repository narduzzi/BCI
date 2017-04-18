function ica_signal=icasig(signal)
%The function uses the FastICA toolbox to perform ica to the signal
%INPUT=signal to perform ICA
%OUTPUT : 
%ica_signal with rows containing estimated independant components
%A is the mixing matrix
%W is the estimated separating matrix

addpath(genpath('..\FastICA_25'));

signal=signal(1:64,:);
ica_signal=fastica(signal);

end