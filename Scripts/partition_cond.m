function  [easy, hard_assist, hard_noassist] = partition_cond(header, signal_filtered,text)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


index_1 = find(header.EVENT.TYP == 1);
index_255 = find(header.EVENT.TYP == 255);

condition = text2matrix(text);


easy = [];
hard_noassist = [];
hard_assist = [];

for i=1:length(index_1)
    i
    if condition(i) == 0
        easy =  [easy filt_signal(:,header.EVENT.POS(index_1(i)):header.EVENT.POS(index_255(i)))];
    elseif condition(i) == 1
        hard_assist = [hard_assist filt_signal(:,header.EVENT.POS(index_1(i)):header.EVENT.POS(index_255(i)))];
    else
        hard_noassist = [hard_noassist filt_signal(:,header.EVENT.POS(index_1(i)):header.EVENT.POS(index_255(i)))];
    end
end

end

