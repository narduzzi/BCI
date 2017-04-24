function [easy, hard_assist, hard_noassist] = partitioning(header, signal_filtered,text)
    %This function takes a filtered signal and partitionnates the signal by 
    %conditions easy, hard with assist and hard without assist using the text file for conditions
    %for every electrodes, each condition class are stored in a different vector and
    %each conditions in each vector are seperated by a high signal value (1e4)

    trajectories_diff = text2matrix(text);

    pos_trigger_begin = ceil(header.EVENT.POS(4));
    begin = ceil(header.EVENT.POS(find(header.EVENT.TYP == 1)))';
    begin(1) = [];
    pos_trigger_begin = [pos_trigger_begin begin];
    pos_trigger_end = ceil(header.EVENT.POS(1108));
    term = ceil(header.EVENT.POS(find(header.EVENT.TYP == 255)))';
    term(end) = [];
    pos_trigger_end = [term pos_trigger_end];


    easy = [];
    hard_assist = [];
    hard_noassist = [];

    seperation = ones(size(signal_filtered,1),1) * 1e4;
    easy = [];
    hard_assist = [];
    hard_noassist = [];
    for i = 1:(length(trajectories_diff)-1) 
        value = trajectories_diff(i);
        if(~(value~=2 && value~=1 && value ~=0))
            b = pos_trigger_begin(i);
            e = pos_trigger_end(i);
            if value == 0 
                    easy = [easy signal_filtered(:,b:e) seperation];
            elseif value == 1
                    hard_assist = [hard_assist signal_filtered(:,b:e) seperation];
            elseif value == 2
                    hard_noassist = [hard_noassist signal_filtered(:,b:e) seperation];
            end
        end
    end
end