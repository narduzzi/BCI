function [signal_filtered] = band_filter(low,high,order,Fs,signal_down)
%This function takes the downsampled signal and filter it between low and
%high frequencies using a desired order and sampling frequency Fs


[b,a] = butter(order, [low high] / (Fs / 2), 'bandpass');

for i=[1:64]
    signal_filtered(i,:) = filtfilt(b, a, signal_down(i,:));
end

end