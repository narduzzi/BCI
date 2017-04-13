function [easy, hard_assist, hard_noassist] = partitioning(header, signal_filtered)
%This function takes a filtered signal and partitionnates the signal by 
%conditions easy, hard with assist and hard without assist for every
%electrodes, each condition class are stored in a different vector and
%each conditions in each vector are seperated by a high signal value (1e3)

trajectories_diff = text2matrix('Trials/data_omar/unity/ad6_10032017_ses_1_condition.txt')';

pos_trigger_begin = ceil(header.EVENT.POS(4)/8);
begin = ceil(header.EVENT.POS(find(header.EVENT.TYP == 1))/8)';
begin(1) = [];
pos_trigger_begin = [pos_trigger_begin begin];
pos_trigger_end = ceil(header.EVENT.POS(1108)/8);
term = ceil(header.EVENT.POS(find(header.EVENT.TYP == 255))/8)';
term(end) = [];
pos_trigger_end = [term pos_trigger_end];


easy = [];
hard_assist = [];
hard_noassist = [];

seperation = ones(size(signal_filtered,1),1) * 1e3;

for i = 1:length(trajectories_diff)
    if trajectories_diff(i) == 0 
            easy = [easy signal_filtered(:,pos_trigger_begin(i):pos_trigger_end(i)) seperation];
    elseif trajectories_diff(i) == 1
            hard_assist = [hard_assist signal_filtered(:,pos_trigger_begin(i):pos_trigger_end(i)) seperation];
    elseif trajectories_diff(i) == 2
            hard_noassist = [hard_noassist signal_filtered(:,pos_trigger_begin(i):pos_trigger_end(i)) seperation];
    end
end


