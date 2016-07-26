function [hour,Fraw,Diff,X,Y]=GEM_read_g(filename);

% function [hour,Fraw,Diff,X,Y]=GEM_read_g(filename)
% 
% read and show mag data measured on grid
% input: file
% format
%---------------------------------------------------
% ... 5 lines
%/X Y nT nT/m sq cor-nT time 
% 0  0  55755.67  0019.79 99  000000.00 020838.0 
% 0  0  55755.47  0019.32 99  000000.00 020858.0 
% 1  0  55753.97  0017.10 99  000000.00 020938.0 
%---------------------------------------------------
% output:
%  time - time in decimal hours
%  Fraw - uncorrected total field
%  Diff - difference in total field between sensors
%  X, Y - positions set by instrument
%
% CGB, July 2009

 [X,Y,Fraw,Diff,qua,cor_nT,time]=...
     textread(filename,...
     '%f %f %f %f %n %f %f ','headerlines',7);
 
% . convert hr-min-sec to decimal hour
 hr  = floor(time/10000);
 min = floor( (time - hr*10000)/100 );
 sec = mod(time,100);
 hour= hr + min/60 + sec/3600;
 
 % show quality and data
 figure; 
 subplot(3,1,1)
 hold on
 quax=floor(qua/10); quay=mod(qua,10); 
 plot(hour,quay,'c'); plot(hour,quax,'b--');
 ylabel('quality')
 subplot(3,1,2)
 plot(hour,Fraw/1000)
 ylabel('total field [nT]')
 subplot(3,1,3)
 plot(hour,Diff)
 ylabel('difference [nT]')
 xlabel('UTC [hr]'); 
 
 figure; scatter(X,Y,50,Fraw/1000,'filled'); axis image; colorbar;
 title('raw total field [10^3 nT]');
 figure; scatter(X,Y,50,Diff,'filled'); axis image; colorbar;
 title('difference between sensors [nT]');
 