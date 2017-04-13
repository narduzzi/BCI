function plotFreq( signal, Fs )
% Function that takes a signal as input (only 1 electrode/line),
% and represents it in the frequency domain. 
%  Fs = sampling frequency of the signal


signaldft = (1/length(signal))*fft(signal);
freq = -(Fs/2):(Fs/length(signal)):(Fs/2)-(Fs/length(signal));
figure(1)
plot(freq,abs(fftshift(signaldft)));



end

