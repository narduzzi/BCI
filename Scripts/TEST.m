addpath(genpath('..\Recordings'));
path='Recordings/ad3_08032017/biosemi/ad3_08032017.bdf';
text='Recordings/ad3_08032017/unity/ad3_08032017_ses_1_condition.txt';

%[easy,hard_assist,hard_noassist,features_extracted] = main_eeg(path,8,1,40,4,text);

rawsignal = path;
downfactor = 8;
low=1;
hig=40;
order=4;

%%Main part
%Test
disp('Loading data...')
[signal,header] = sload(rawsignal);
signal = signal';
%channel selection
signal = signal(1:64,:);
disp('Applying car...')
signal = car(signal);

downfactor = 8;
disp(fprintf('Downsampling : Factor %0.5f',downfactor))
[header_down,signal_down] = downsampling(header,signal,downfactor);
low = 1;
high = 40;
order= 5;
disp('Bandpass filtering...')
Fs = header.SampleRate/downfactor;
signal_filtered = band_filter(low,high,order,Fs,signal_down);

disp('Partitioning filtering...')
[easy,hard_assist,hard_noassist] = partitioning(header_down,signal_filtered,text);

disp('Feature extraction...(FOR NOW INVALID)')
window_size = 50;
step_size = 2;
features_extracted = features_extraction(easy,hard_noassist,hard_assist,header,window_size,step_size);

%}

%%%%%%%%%%%%%%%
shuffledArray = features_extracted(randperm(size(features_extracted,1)),:);
save('shuffled_features_extracted_2241fft_60000.mat','shuffledArray');

easy_t = easy';
S = size(easy_t);
N = S(1);
easy_t = [easy_t zeros(N,1)];

hard_assist_t = hard_assist';
S = size(hard_assist_t);
N = S(1);
hard_assist_t = [hard_assist_t ones(N,1)];

hard_noassist_t = hard_noassist';
S = size(hard_noassist_t);
N = S(1);
hard_noassist_t = [hard_noassist_t ones(N,1)*2];

data = [easy_t',hard_assist_t',hard_noassist_t']';