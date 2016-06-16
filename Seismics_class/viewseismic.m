% viewseismic.m
% combine two layouts for same shotpoint
 % clear all; close all; format compact;
 
%  date='2015-05-20/'; 
%   file1='7.dat';   file2='213a.dat';  D='00'; % files for shot at D m
%   file1='6.dat';   file2='211a.dat';  D='10';
%   file1='5.dat';   file2='209a.dat';  D='20';
%   file1='4.dat';   file2='208a.dat';  D='30'; 
%   file1='3.dat';   file2='207.dat';   D='40';
%   file1='1.dat';   file2='206a.dat';  D='50';
%   file1='8.dat';   file2='205.dat';   D='60'; 
%   file1='9.dat';   file2='204a.dat';  D='70'; 
%   file1='10.dat';  file2='203a.dat';  D='80'; 
%   file1='11.dat';  file2='202a.dat';  D='90'; 
%   file1='12.dat';  file2='201.dat';  D='96';  
%  
%  x1=[0:2:46]; x2=[50:2:96];  % two layouts

% load data 
  [trace_data1,header1] = seg2load ([file1]);
  [trace_data2,header2] = seg2load ([file2]);

% combine separate files
% traces=[trace_data1,fliplr(trace_data2)];  % shot 2 flipped
 traces=[trace_data1,trace_data2];           % unflipped
 x=[x1,x2];                                  % distances
 dt=header1.tr.sampling(1);
% nsam=2000;  % number of samples to show
 t=[0:dt:(nsam-1)*dt]; 
% filter and normalize each trace individually 
 TRACES=traces(1:nsam,:);
 for ind=1:size(TRACES,2)
     TRfilt(:,ind) = butterlow(dt,TRACES(:,ind),100,2);
     TRnorm(:,ind) = TRfilt(:,ind)/max(TRfilt(:,ind));
 end
% show data 
 figure
 wiggle(t*1000,x,'2')
%  wiggle(t*1000,x,TRnorm,'2')
 xlabel('distance [m]'); ylabel('time [ms]'); title(['shot at ',D,' m']);
% eval(['print -djpeg shot',D,'.jpg'])
 