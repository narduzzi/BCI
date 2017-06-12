function ndf_online_tid(include)
% Include any required toolboxes
if nargin < 1
    include = true;
end
if include
    ndf_include();
end

%!!!MODIFY THIS PART!!!%
load_ah2_parameter; 
%!!!MODIFY THIS PART!!!%

% !!! MODIFY IF YOU KNOW WHAT YOU ARE DOING
baseline = zeros(size(user.pSpec.freqBand, 2) , sum(user.chSel));

msg = [];
cnt = zeros(1, 3);
newTrajFlag = false;
endTrajFlag = false;

% Prepare and enter main loop
try 
	% Initialize loop structure
	cl = cl_new();

	% Connect to the CnbiTk loop
	if(cl_connect(cl) == false)
		disp('[ndf_example_IC] Cannot connect to CNBI Loop, killing matlab');
		exit;
	end	

	% Prepare NDF srtructure
	ndf.conf  = {};
	ndf.size  = 0;
    ndf.samples = ndfsamples; % read how many samples from ndf
	ndf.frame = ndf_frame();
	ndf.sink  = ndf_sink('/tmp/cl.pipe.ndf.0'); % Connect to /pipe0
    % Create a single ID client for sending and receiving events to/from a feedback
    % (or other loop modules). The possibility for separate ID clients for
    % receiving/sendind exists
    
    ID = tid_new(); % Create ID client
    idm = idmessage_new(); % Create ID message for both sening/receiving
    ids = idserializerrapid_new(idm); % Create ID message serializer
    % Configure ID message
    idmessage_setdescription(idm, 'io');
    idmessage_setfamilytype(idm, idmessage_familytype('biosig'));
    idmessage_dumpmessage(idm);
    ida = '\bus'; % Alias of iD bus
    
	% Pipe opening and NDF configuration
	% - Here the pipe is opened
	% - ... and the NDF ACK frame is received
	disp('[ndf_example_IC] Receiving ACK...');
	[ndf.conf, ndf.size] = ndf_ack(ndf.sink);
    ndf.timePerLoop = (ndf.conf.samples/ndf.conf.sf);
    timeTol = ndf.timePerLoop * 0.05; % time tolerance
    % for saving time when a quick modification is needed
    terminate = onCleanup(@() closeLoop(ndf, ids, idm, ID));
        
    % Create the data buffer with a single channel, 1 second long buffer
    buffer.eeg = ndf_ringbuffer(ndf.conf.sf, nBuffCh, buffLength);    

    % Buffer for trigger channel
    buffer.tri = ndf_ringbuffer(ndf.conf.sf, ndf.conf.tri_channels, buffLength);
    
    
    user.filterSpec = fdesign.bandpass('N,F3dB1,F3dB2', 6, 1, 40, 2048);
    user.Filter = design(user.filterSpec, 'butter', 'systemobject', true);
    
    
    
    
    
    % Initialize the final output
    output = 0;
	    
    disp('[ndf_example_IC] Receiving NDF frames...');
    
    a = tic;
    while(true)
        computing_time = toc(a);
        [ndf.frame, ndf.size] = ndf_read(ndf.sink, ndf.conf, ndf.frame);
        oneloop_time = toc(a);
        a = tic;
        % Acquisition is down, exit
        if(ndf.size == 0)
            disp('[ndf_example_IC] Broken pipe');
            break;
        end
		
		% !!! DOWNSAMPLE AROUND HERE IF YOU WANT
		
        % spectral filtering
        eegFilt = step(user.Filter, ndf.frame.eeg(:, 1:nBuffCh)); % ndf.frame.eeg only has 'totally new' data
        % Pick new data and update buffer (observation (sliding) window for the feature vector)
        buffer.eeg = ndf_add2buffer(buffer.eeg, eegFilt); % buffer.eeg usually contain also some 'old' data
        buffer.tri = ndf_add2buffer(buffer.tri, ndf.frame.tri);

        trig = ndf.frame.tri + 7798784; % -7798784 for biosemi
        newTraj = find(trig==1, 1);
        endTraj = find(trig==255, 1);
        if ~isempty(endTraj) && ~endTrajFlag % end of traj
            endTrajFlag = true;
            fprintf('\n');
            fprintf('\nTraj Ends\n');
        end
        if ~isempty(newTraj) && ~newTrajFlag % reset
            baseline = zeros(size(user.pSpec.freqBand, 2), 1, sum(user.chSel));
            cnt = zeros(1, 3);
            newTrajFlag = true;
            endTrajFlag = false;
            fprintf('\nNew Traj\n');
            [baseline(:, 1, :)] = fun_getBaseline(user, buffer.eeg);
        elseif ~isempty(msg)
            if isempty(newTraj) % reset trigger goes down
                newTrajFlag = false;
				%% !!! IMPLEMENT THIS FUNCTION. If you don't have any baseline, initialize baseline as whatever as long as the loop runs correctly.
                baseline = computeBaseline(baseline); 
            else % still in the time counting period, collect more baseline
                cnt = zeros(1, 3);
				%% !!! Baseline IS COLLECTED AS ?-by-nSample-by-? tensor. Change this if you want to collect baseline in a different way
                [baseline(:, end+1, :)] = fun_getBaseline(user, buffer.eeg);
            end
%             fprintf(repmat('\b', 1, numel(sprintf(msg))));
            fprintf('\r');
        end
        
        
        % Feature extraction
		%% !!! IMPLEMENT THIS FUNCTION
%         [feature, artifact] = fun_extract(user, buffer.eeg, baseline(:, 1, :));
        [feature, artifact] = fun_extract(user, buffer.eeg, []);
        
        
		%% !!! IMPLEMENT THIS FUNCTION% Classification
        [class, proab] = fun_classify(user, feature);
        
        % Final output (must be an integer)
		%% !!! IMPLEMENT THIS FUNCTION
        output = fun_integration(class, proab, output, artifact);
        cnt(output+1) =cnt(output+1)  + 1;
        msg = [];
        % Handle async TOBI iD communication
        if(tid_isattached(ID) == true)
            if ~isempty(output )
                % Send iD event 1 if output >= 1
                idmessage_setevent(idm, output); % Send integer output
                tid_setmessage(ID, ids, ndf.frame.index);
                msg = ['ID msg: ', num2str(output), '!'];                
            end
            
            % Here read any incoming messages from the feedback, or
            % elsewhere
            while(tid_getmessage(ID, ids) == true)
                event = idmessage_getevent(idm);                
                if(event == 10)
                    % Reset output to 0
                    disp('Resetting!');
                    output = 0;
                end
            end
        else
            tid_attach(ID);
        end
        
        msg = [msg, sprintf(' #sp: %5d, pdf:  %.2f  %.2f  %.2f,', sum(cnt), cnt./sum(cnt))];
        msg = [msg, sprintf(' time: %.2f  %.2f  ', computing_time*1000, oneloop_time*1000)];
        timeDiff = oneloop_time - ndf.timePerLoop;
        
        if abs(timeDiff) < timeTol
            msg = [msg, '\033[32;1m OK \033[0m'];
        elseif timeDiff > timeTol && timeDiff > 0
            msg = [msg, '\033[41;37;1m TOO SLOW \033[0m\n'];
        else
            msg = [msg, '\033[41;37;1m TOO FAST \033[0m\n'];
        end
        msg = [msg, '  ']; % extra spaces to erase previous texts
        fprintf(msg);
        
    end
    
catch exception
	ndf_printexception(exception);
    
    % Tear down loop structure
    tid_detach(ID);
    ndf_close(ndf.sink); 
    idserializerrapid_delete(ids);
    idmessage_delete(idm); 
	tid_delete(ID);
    fclose('all');
	disp('[ndf_example_IC] Going down');
end
end

function closeLoop(ndf, ids, idm, ID)
    fprintf('\nClosing loop\n');
    % Tear down loop structure
    tid_detach(ID);
    ndf_close(ndf.sink); 
    idserializerrapid_delete(ids);
    idmessage_delete(idm); 
	tid_delete(ID);
    fclose('all');
	disp('[ndf_example_IC] Going down');
end

% !!! use artifact if you want
function [baseline, artifact] = fun_getBaseline(user, eeg)
    baseline = [];
    artifact = [];
end
% !!! you can use artifact as another input
function baseline = computeBaseline(baseline)
    baseline = [];

end

% !!! generate your feature vector, and also output whether there is artifact if you want
function [feature, artifact] = fun_extract(user, eeg, baseline)
    eeg = eeg';
    
    col = length(eeg(1,:));
    for i =1:col
        means = mean(eeg(:,1));
        eeg(:,i) = eeg(:,i) - means;
    end
    
    %CAR
    
    %
    window_size = user.window_size;
%     N = length(eeg);
% %     eeg = eeg(:,N-window_size:user.downsampling:N);
%     eeg = eeg(:,1:N);
    
    min_freq = 5;
    max_freq = 35;
    L = length(eeg);
    n = 2^nextpow2(L);
    Y = fft(eeg);
    P = abs(Y/n);
    frequency_coeff = P(:,min_freq:max_freq);

    s = size(frequency_coeff);
    new_size = [1,s(1)*s(2)];

    feature = reshape(frequency_coeff,new_size);
    artifact = 0;
end

% !!! It is suggested to output proability
function [class, proab] = fun_classify(user, feature)
    SVMClassifier = user.SVM_model;
    LDAClassifier = user.LDA_model;
    DQDAClassifier = user.DQDA_model;

    featuresSVM = feature(user.SVM_selected_features);
    featuresLDA = feature(user.LDA_selected_features);
    featuresDQDA = feature(user.DQDA_selected_features);

  %  [svm_y,svm_score] = predict(SVMClassifier,featuresSVM);
 %  [lda_y,lda_score,lda_cost] = predict(LDAClassifier,featuresLDA);
    [dqda_y,dqda_score] = predict(DQDAClassifier,featuresDQDA);
    
   % proab1 = (svm_score(1)+lda_score(1)+dqda(1))*0.33;
    %proab2 = (svm_score(2)+lda_score(2)+dqda(2))*0.33;
    proab1 =(dqda_score(1));
    proab2 = (dqda_score(2));
    if(proab1>proab2)
        class = 0;
    else
        class = 1;
    end
        proab = proab1;
%     %Classifier lda of Simon
%     class = predict(classifier_lda, feature(:,Simon_Model_LDA.selected_features)); 
%     proab = 0.6;
%     
%     %Classifier dqda of Simon
%     class = predict(classifier_dqda, feature(:,Simon_Model_DQDA.selected_features)); 
%     proab = 0.6;
    
end

% !!!
% This function does further post-processing on the result, e.g., smoothing or create the space of a pseudo class (levels in between easy and hard)
% Below is just a simple sample code.
% OUTPUT = 
%	0: waypoint becomes smaller
%	1: waypoint does not change
%	2: waypoint becomes larger
function output = fun_integration(class, proab, output, artifact)

% !!! IT IS STRONGLY RECOMMENDED TO SAVE YOUR THRESHOLD VALUE AS A FILE
%	By doing so, we can save time when tuning the threshold during experiment.
%	In other words, we don't need to stop the loop for just changing a threshold.
%	Don't make the number of threshold too many, as file reading is time consuming.
% Below is a very simple way to implement, you can see that input also has output. 
% Therefore, it is possible to do something like IIR or nonlinear processing on the final output.
th = load('./threshold_integration');
%For LDA % DQDA, Uncomment next line:
%th [0.5 0.5];
proab
if proab >  th(1) 
    output = 2;
elseif proab < th(2)
    output = 0;
else
    output = 1;
end
end
