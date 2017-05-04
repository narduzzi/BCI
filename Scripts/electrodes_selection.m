function data=electrodes_selection(signal,header,label)

idx=index_of_electrodes(label,header);

data=signal(idx,:);

end