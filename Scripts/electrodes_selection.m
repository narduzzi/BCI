function [new_signal, new_header]=electrodes_selection(signal,header,label)
%select electrodes of interest
%INPUT : signal, header, label
%OUTPUT : new_signal and new_header

idx=index_of_electrodes(label,header);

new_signal=signal(idx,:);
new_header=header(idx,:);
end