function [easy, hard_assist, hard_noassist] = partitioning2(header, signal_filtered,text)
%This function takes a filtered signal and partitionnates the signal by 
%conditions easy, hard with assist and hard without assist using the text file for conditions
%for every electrodes, each condition class are stored in a different vector and
%each conditions in each vector are seperated by a high signal value (1e4)

trajectories_diff = text2matrix(text);

pos_trigger_begin = header.EVENT.POS(find(header.EVENT.TYP == 1)+2)';
pos_trigger_end = header.EVENT.POS(find(header.EVENT.TYP == 255)-2)';

easy = [];
hard_assist = [];
hard_noassist = [];

seperation = ones(size(signal_filtered,1),1) * 1e4;
easy = [];
hard_assist = [];
hard_noassist = [];
for i = 1:15
    if trajectories_diff(i) == 0 
            easy = [easy signal_filtered(:,pos_trigger_begin(i):pos_trigger_end(i)) seperation];
    elseif trajectories_diff(i) == 1
            hard_assist = [hard_assist signal_filtered(:,pos_trigger_begin(i):pos_trigger_end(i)) seperation];
    elseif trajectories_diff(i) == 2
            hard_noassist = [hard_noassist signal_filtered(:,pos_trigger_begin(i):pos_trigger_end(i)) seperation];
    end
end
end