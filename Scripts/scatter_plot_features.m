%% Pipeline
%Loic Pipeline
addpath(genpath('..\Recordings'));
session_train = 'af6_15032017';
session_test = 'af6_12042017';
user = 'loic';

path=strcat('Recordings/',session_train,'_',user,'1','/biosemi/data_',user,'1.bdf');
text=strcat('Recordings/',session_train,'_',user,'1','/unity/',session_train,'_ses_1_condition.txt');

rawsignal = path;
downfactor = 8;
sampling_freq = 2048;
low=1;
high=40;
order=5;
K = 400;

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

features_extracted_train = process_session1(signal_down,header_down,text);

%% Features ranking and analysis
[train_labels,train_features,null1,null2] = create_folds(features_extracted_train,-1);

[orderedFisher, orderedFisherPower] = rankfeat(train_features, train_labels, 'fisher');
[orderedReliefF, orderedReliefFPower] = relieff(train_features, train_labels, 400);
[coeff, train_PCA, variance] = pca(train_features);

%% Plot Fisher
size = 6;
figure;
features_selected = orderedFisher(1:size);
features_name = get_name_of_features(features_selected);
gplotmatrix(train_features(:,features_selected),[],train_labels,'br','ox',[],'on','',...
    features_name,features_name);
title('Scatter matrix of the 6 first features ranked by Fisher (AF6)');
h = findobj('Tag','legend');
set(h, 'String', {'Easy', 'Hard'})

%% Plot ReliefF
size = 6;
figure;
features_selected = orderedReliefF(1:size);
features_name = get_name_of_features(features_selected);
gplotmatrix(train_features(:,features_selected),[],train_labels,'br','ox',[],'on','',...
    features_name,features_name);
title('Scatter matrix of the 6 first features ranked by ReliefF (AF6)');
h = findobj('Tag','legend');
set(h, 'String', {'Easy', 'Hard'})

%% Plot PCA
size = 6;
figure;

%Get coeffs
[coeff_sort pca_indices] = sort(coeff,'descend');
features_selected = pca_indices(1:size);
features_selected

features_name = get_name_of_features(features_selected);
gplotmatrix(train_features(:,features_selected),[],train_labels,'br','ox',[],'on','',...
    features_name,features_name);
title('Scatter matrix of the 6 first features ranked by PCA');
h = findobj('Tag','legend');
set(h, 'String', {'Easy', 'Hard'})

%%
disp('Fisher 20 first features');
disp(orderedFisher(1:20)');

disp('ReliefF 20 first features');
disp(orderedReliefF(1:20)');

disp('PCA 20 first features');
disp(pca_indices(1:20));


%% Plotting distribution of electrodes for the first 200 features
N = 200;

figure;
electrodes_Fisher_200 = electrodes_containing_features(orderedFisher(1:N));
histogram(electrodes_Fisher_200,64);
axis([1 64 0 13])
xlabel('Electrode index');
ylabel('Features');
title('Features repartition in electrodes (first 200 ranked by Fisher)');

figure;
electrodes_ReliefF_200 = electrodes_containing_features(orderedReliefF(1:N));
histogram(electrodes_ReliefF_200,64);
axis([1 64 0 13])
xlabel('Electrode index');
ylabel('Features');
title('Features repartition in electrodes (first 200 ranked by ReliefF)');

figure;
features_PCA = pca_indices(1:N);
len = length(features_PCA);
electrodes_PCA_200 = electrodes_containing_features(features_PCA);
histogram(electrodes_PCA_200,64);
axis([1 64 0 13])
xlabel('Electrode index');
ylabel('Features');
title('Features repartition in electrodes (first 200 ranked by PCA)');

%% Plotting distribution of frequencies for the first 200 features
N = 100;

figure;
frequency_Fisher_200 = frequency_of_features(orderedFisher(1:N));
histogram(frequency_Fisher_200,31);
axis([5 35 0 20]);
xlabel('Frequency');
ylabel('Features');
title('Features repartition in frequency (first 200 ranked by Fisher)');
savefig('Graphs/Frequencies_Fisher_200.fig');

figure;
frequency_ReliefF_200 = frequency_of_features(orderedReliefF(1:N));
histogram(frequency_ReliefF_200,31);
axis([5 35 0 20]);
xlabel('Frequency');
ylabel('Features');
title('Features repartition in frequency (first 200 ranked by ReliefF)');
savefig('Graphs/Frequencies_ReliefF_200.fig');

figure;
features_PCA = pca_indices(1:N);
len = length(features_PCA);
frequency_PCA_200 = frequency_of_features(features_PCA);
histogram(frequency_PCA_200,31);
axis([5 35 0 20]);
xlabel('Frequency');
ylabel('Features');
title('Features repartition in frequency (first 200 ranked by PCA)');
savefig('Graphs/Frequencies_PCA_200.fig');