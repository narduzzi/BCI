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
%%
features_names(1,:) = mod((0:1983),31)+5;
features_names(2,:) = round((0:1983)/62)+1;
%%
orderedFisher(1:20)
orderedReliefF(1:20)
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
features_selected = orderedReliefF(1:size);
features_name = get_name_of_features(features_selected);
gplotmatrix(train_features(:,features_selected),[],train_labels,'br','ox',[],'on','',...
    features_name,features_name);
title('Scatter matrix of the 5 first features ranked by PCA');
h = findobj('Tag','legend');
set(h, 'String', {'Easy', 'Hard'})

