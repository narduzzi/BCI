function features_extracted = process_recording(bdf_path,condition_path)

    path=bdf_path;
    text=condition_path
    %% SESSION 1
    rawsignal = path;
    downfactor = 8;
    sampling_freq = 2048;
    low=1;
    high=40;
    order=5;

    %Main part
    disp('Loading data...')
    [signal,header] = sload(rawsignal);
    signal = signal';
    %channel selection
    signal = signal(1:64,:);

    disp(fprintf('Downsampling : Factor %0.0f \n',downfactor))
    [header_down,signal_down] = downsampling(header, signal,downfactor);

    disp('Applying car...');
    %signal_filtered = car(signal_filtered);
    signal_down = car(signal_down);
    disp('CAR done.');
    %%
    features_extracted = process_session1(signal_down,header_down,text);
end