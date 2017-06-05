%% THIS SCRIPT INITIALIZES YOUR PARAMETERS

%% DON"T TOUCH
fs = 2048; % sampling rate
ndfsamples = round(fs * 0.01); % this defines how many samples will be read

%% MODIFY/ADD BELOW
nBuffCh = 64; % # of buffer channel. YOU CAN MODIFY IF YOU KNOW HOW TO CHANGE IN ndf_online_tid.m (You need to select channels properly!!)
file = './??.mat'; % IF YOU HAVE A FILE TO READ
%Loading for classifier lda of Ricardo
%load('Simon_Model_LDA_classifier.mat');
%Loading for classifier dqda of Ricardo
%load('Simon_Model_DQDA_classifier.mat');
buffLength = 1.0; % buffer length (1.0 = 1-second) for both eeg and trigger. THIS IS THE OBSERVATION WINDOW FOR GENERATING A FEATURE VECTOR

%% ADD ANYTHING YOU WILL NEED TO INITIALIZES
%	e.g. spectral filter, feature extraction model, classification model.

%	THE MODEL IS PREFERRED TO INITIALIZE AS A STRUCT VARIABLE NAMED AS user. Details please refer to ndf_online_tid.m

    % Prepare your spectral filter, if you need. 
	%	The filter must be able to support step function OR you change the corresponding code in ndf_online_tid.m
	%	Be aware of MATLAB VERSION. It is R2016b.
    
user.pSepc.freqBand = [1,40];
user.chSel = 64
%SVM
SVM_model_file = load('Models/Simon_Model_287_Classifier.mat');
SVM_struct_file = load('Models/Simon_Model_287_struct.mat');
%Saving to user
user.SVM_model = SVM_model_file.SVMModel_Simon_287;
user.selected_features_SVM = SVM_struct_file.selected_features;
user.windows_size = SVM_struct_file.window_size;

%COMPLETE FOR RICARDO



