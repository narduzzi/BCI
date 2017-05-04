function [data, new_header]=electrodes_selection(signal,header,label)
%select electrodes of interest
%INPUT : signal, header, label
%OUTPUT : data is the signal for each electrodes selected

idx=index_of_electrodes(label,header);

data=signal(idx,:);
new_header=header(idx,:);
end