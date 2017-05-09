centered_electrodes = load('25_centered_electrodes.mat');

[header_down,signal_down] = downsampling(header,signal,downfactor);
[indices] = index_of_electrodes(centered_electrodes.label,header_down);
indices