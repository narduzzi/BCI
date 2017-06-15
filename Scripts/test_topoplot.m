close all
clear all
clc

%load electrodes position
load('chanlocs.mat');
loc_mat=chanlocs;

%low and high limit for topoplot (to get homogenous results)
lo=-1.5*10^-4;
hi=1.5*10^-4;

%load data for each subjects and get mean for each conditions
load('topoplot_loic3');
mean_loic1=mean_easy;
mean_loic2=mean_hard_assist;
mean_loic3=mean_hard_noassist;
load('topoplot_omar3');
mean_omar1=mean_easy;
mean_omar2=mean_hard_assist;
mean_omar3=mean_hard_noassist;
load('topoplot_ricardo3');
mean_ricardo1=mean_easy;
mean_ricardo2=mean_hard_assist;
mean_ricardo3=mean_hard_noassist;
load('topoplot_simon3');
mean_simon1=mean_easy;
mean_simon2=mean_hard_assist;
mean_simon3=mean_hard_noassist;

%compute mean over all subjects for each conditions
mean1=[mean_loic1;mean_ricardo1;mean_omar1;mean_simon1];
mean2=[mean_loic2;mean_ricardo2;mean_omar2;mean_simon2];
mean3=[mean_loic3;mean_ricardo3;mean_omar3;mean_simon3];

grand_mean1=mean(mean1);
grand_mean2=mean(mean2);
grand_mean3=mean(mean3);

%get topoplot for each conditions (grand average)
figure();
topoplot(grand_mean1,loc_mat,'conv','on','maplimits',[lo hi]);
title('1');

figure();
topoplot(grand_mean2,loc_mat,'conv','on','maplimits',[lo hi]);
title('2');

figure();
topoplot(grand_mean3,loc_mat,'conv','on','maplimits',[lo hi]);
title('3');

