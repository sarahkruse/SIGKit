% show_picksandwiggles.m
% shows short portions of the waveform starting just shortly before picked time
% CGB, DR 25 July 2015
 clear all; close all; format compact; clc;
 
% provide parameters
 wstart=-5; wlength=20;   % start before pick, and length [msec]


% read data into a matrix
% 24 June E to W line
 x1=[2:2:48]; x2=[50:2:96];  % two layouts
 datadir='data/';
 file1='data/1.dat';   file2='data/22.dat';  D='00'; % two files for one shot
 picksfile='timepicks/picks00';
 nsam=1000;   % number of samples to show
 
 viewseismic
 hold on
 eval(['load ',picksfile]);
 plot(x,T,'r+')

% create matrix with NaN, and place segments of traces into it
 TTT=ones(size(TRACES))*NaN;
 for tracenum=1:size(TRACES,2)
     nstart=round( (T(tracenum)+wstart)/1000/dt); nstart=max(nstart,1);
     nend  =round( (T(tracenum)+wstart+wlength)/1000/dt);
     TTT(nstart:nend,tracenum)= TRACES(nstart:nend,tracenum)/max(TRACES(nstart:nend,tracenum));
 end 
 
% plot data
 figure
 wiggle(t*nsam,x,TTT,'1')
 xlabel('distance [m]'); ylabel('time [ms]'); title(['picks for shot at ',D,' m']);
 hold on;
 plot(x,T,'r+')
 ylim([0 max(T+wlength)])

