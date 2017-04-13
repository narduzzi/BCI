clc
clear all
close all

load('signal_down_omar.mat');
load('header_event.mat');
electrode13 = signal_down(13,:);

trajectories_diff = [0 0 1 2 2 1 0 1 2 1 2 0 2 1 0];
pos_trigger_begin = ceil(header.EVENT.POS(find(header.EVENT.TYP == 1))/4);
pos_trigger_end = ceil(header.EVENT.POS(find(header.EVENT.TYP == 255))/4);


for i = 1:15
    if trajectories_diff(i) == 0
        easy = [easy electrode13(pos_trigger_begin(i):pos_trigger_end(i))];
    elseif trajectories_diff(i) == 1
        hard_assist = [hard_assist electrode13(pos_trigger_begin(i):pos_trigger_end(i))];
    elseif trajectories_diff(i) == 2
        hard_noassist = [hard_noassist electrode13(pos_trigger_begin(i):pos_trigger_end(i))];
    end
end