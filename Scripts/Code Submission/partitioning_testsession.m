function [ easy, medium, hard ] = partitioning_testsession( header, signal_filtered)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%pos_trigger_begin = header.EVENT.POS(find(header.EVENT.TYP == 1)+2)';
%pos_trigger_end = header.EVENT.POS(find(header.EVENT.TYP == 255)-2)';
pos_trigger_begin = (find(header.EVENT.TYP == 1)+2)';
pos_trigger_end = (find(header.EVENT.TYP == 255)-2)';

seperation = ones(size(signal_filtered,1),1) * 1e4;
easy = [];
hard = [];
medium = [];
difficulty = 0;

for i=1:length(pos_trigger_begin)

    for j=0:2:(pos_trigger_end(i)-pos_trigger_begin(i)-2)
        if(header.EVENT.TYP(pos_trigger_begin(i)+j) == 144 || header.EVENT.TYP(pos_trigger_begin(i)+j) == 176)
            difficulty = difficulty+1;
        end
        if difficulty == 0 
            easy = [easy signal_filtered(:,header.EVENT.POS(pos_trigger_begin(i)+j):header.EVENT.POS(pos_trigger_begin(i)+j+2))];
        elseif difficulty == 1
            medium = [medium signal_filtered(:,header.EVENT.POS(pos_trigger_begin(i)+j):header.EVENT.POS(pos_trigger_begin(i)+j+2))];
        elseif difficulty == 2
            hard = [hard signal_filtered(:,header.EVENT.POS(pos_trigger_begin(i)+j):header.EVENT.POS(pos_trigger_begin(i)+j+2))];
        end
    end
    difficulty = 0;
    easy = [easy seperation];
    medium = [medium seperation];
    hard = [hard seperation];
    
end

end

