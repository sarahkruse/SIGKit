% test_main.m
%
% script to try transformations on field data

% 0. read and display magnetic field data;
% at Sechelt we ran a grid
% and included a smaller grid to focus on a strong anomaly
 clear; close all; format compact;

  [hour1,Fraw1,Diff1,X1,Y1]=GEM_read_g(input('please, input filename... e.g. sample_data/b07G.txt','s'));  % big grid
  [hour2,Fraw2,Diff2,X2,Y2]=GEM_read_g('sample_data/01.txt');    % small internal grid
 % close all;
 pause
% . combine datasets
  X=[X1/2;X2];
  Y=[Y1/2;Y2];
  Fr=[Fraw1;Fraw2]/1000;
  Dr=[Diff1;Diff2];
  hr=[hour1;hour2];
% save dum.mat X Y Fr Dr hr
% load dum.mat 

 figure
 scatter(X,Y,30,Fr,'filled'); 
 axis image; colorbar;
% clear hour1 hour2 Fraw1 Fraw2 Diff1 Diff2 X1 X2 Y1 Y2
 pause
 
% 1. grid data
 x=0.5:.5:13.5; y=0.5:.5:7;
 f=griddata(X,Y,Fr,x,y');
 figure; contourf(x,y,f,16); axis image; colorbar; title(['gridded data']);
% hold on; plot(X,Y,'k.');
pause
 
% 2. rotate map 
 [xr,yr,Xr,Yr,frot] = rotatemap(x,y,f,20,.3);
 figure; contourf(xr,yr,frot,16); axis image; colorbar; title(['rotated data']);
 hold on; plot(Xr,Yr,'k.');
 pause
 
% 3. upward continutation 
 [fuc] = upcont(x,y,f,0.95);
 figure; contourf(x,y,fuc,16); axis image; colorbar; title(['upward continued']);
 pause
 
% 4. reduction-to-the-pole 
 [fr2p] = r2p(x,y,f,60,5);
 figure; contourf(x,y,fr2p,16); axis image; colorbar; title(['reduced to pole']);
 pause
 
% 5. analytical signal
 [A] = analytical_signal(x,y,f,fuc,.5);
 figure; contourf(x,y,A,16); axis image; colorbar; title(['analytical signal']);
 