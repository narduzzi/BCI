function [header_down, signal_down] = downsampling(header,signal, downfactor)

%First low pass filtering and then downsampling (for example if the
%sampling frequency is 2kHz a downsampling of factor 8 will reduce the
%frequency to 256Hz)

for i = 1:length(signal(:,1))
    signal_down(i,:) = decimate(signal(i,:),downfactor);
end

header.EVENT.POS = ceil(header.EVENT.POS/downfactor);
header_down=header;
end