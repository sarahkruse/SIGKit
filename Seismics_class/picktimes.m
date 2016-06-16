
%picktimes.m
%code to pick and define first arrivals of seismic data
%yukon 2015
% CGB, KSP, WJM  23/05/2015
% updated for DRSA, CGB, 21 July 2015

clear all; close all;

%read in data from SEG2 files
 file1='1.dat';   file2='22.dat';  D='00'; % two files for one shot
 %file1='data/3.dat';   file2='data/20.dat';  D='10'; 
 %file1='data/5.dat';   file2='data/18.dat';  D='20'; 
 %file1='data/7.dat';   file2='data/16.dat';  D='30'; 
 %file1='data/9.dat';   file2='data/14.dat';  D='40'; 
 %file1='data/11.dat';  file2='data/12.dat';  D='50'; 

% positions of geophones 
 x1=[1:24]; x2=[26:49];  % two layouts
 nsam=4000;  % number of samples to show
 viewseismic;
 
 clear tr* x1 x2 hea* fil* TRfilt 

% pick and overlay first breaks on seismogram section
disp('pick ALL first breaks now, press enter when done')
[X,T]=ginput;
eval(['save picks',D,' X T'])
hold on; 
plot (X,T,'b+');

% quality control of picks
% check that red line alligns with first break of each wiggle
disp('please repick first breaks')
scrsz = get(0,'ScreenSize');
for index=1:48
    figure('Position',[1 1 scrsz(3)*0.9 scrsz(4)*0.9]);
    plot(t*1000, TRnorm(:,index), 'b');
    hold on;
    plot(t*1000, TRACES(:,index)/max(TRACES(:,index)), 'k');
    plot([T(index) T(index)],[1 -1], 'r');
    title(['Shot at ',D,' m and geophone at ', num2str(x(index)),' m'])
   [T(index),A]=ginput(1);
   %plot([T(index) T(index)],[1 -1], 'c', 'linewidth',2);pause
   close
end

%show picks
figure(1); plot(x, T, 'r+')

%save results
eval(['save picks',D, ' x T ']);

% load picks00.mat; x=[1:24,26:49]; save picks00.mat x T
