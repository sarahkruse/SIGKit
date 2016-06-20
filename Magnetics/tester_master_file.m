% test_main.m
%
% script to try transformations on field data

% 0. read and display magnetic field data;
% 
%Can combine any number of datasets;
% Inputs:
%       N = number of datasets 
%       name = dataset file name;


 clc; clear all; close all; format compact;
 X=[]; Y=[]; Fr=[]; Dr=[]; hr=[];
for N = (1:input('Number of datasets?   '))
    name = input('Enter individual filenames for each seperate file...    ','s')
    [hour,Fraw,Diff,W,Z]=tester_GEM_read_g(name);
    %combine datasets;
    X= vertcat(X,W);
    Y= vertcat(Y,Z);
    Fr= vertcat(Fr,([Fraw]/1000));
    Dr= vertcat(Dr,Diff);
    hr= vertcat(hr,[hour]);
end 
%sample_data/01.txt
%
% save dum.mat X Y Fr Dr hr
% load dum.mat 

 figure
 scatter(X,Y,30,Fr,'filled'); 
 axis image; colorbar;
clear hour1 hour2 Fraw1 Fraw2 Diff1 Diff2 X1 X2 Y1 Y2
 pause

 % 1. grid data
 %  Provides options pertaining to gridding data
 Q= input('Grid data? [Y/N]...  ','s');
if isempty(Q)
    Q= 'Y';
    gridinfo= [' X max:',num2str(max(X)),' X min:',num2str(min(X)),' Y max:',num2str(max(Y)),' Y min:',num2str(min(Y))];
    disp(gridinfo)
    x= input('Define x axis as (start:interval:end)...   ');
    y= input('Define y axis as (start:interval:end)...   ');
 %grid options can be as follows or user input as above:
 %      x=0.5:.5:13.5; y=0.5:.5:7;
 %x= linespace(X(max):X(min):20); y= linespace (Y(max):Y(min):20)
 %      *a pull down list of calculated suggestions and user input option*
 f=griddata(X,Y,Fr,x,y');
 figure; contourf(x,y,f,16); axis image; colorbar; title(['gridded data']);
 hold on; plot(X,Y,'k.');
 return
elseif Q== 'Y'
    gridinfo= [' X max:',num2str(max(X)),' X min:',num2str(min(X)),' Y max:',num2str(max(Y)),' Y min:',num2str(min(Y))];
    disp(gridinfo)
    x= input('Define x axis as (start:interval:end)...   ');
    y= input('Define y axis as (start:interval:end)...   ');
 f=griddata(X,Y,Fr,x,y');
 figure; contourf(x,y,f,16); axis image; colorbar; title(['gridded data']);
 hold on; plot(X,Y,'k.');
end
pause

% 2. rotate map 
 [xr,yr,Xr,Yr,frot] = rotatemap(x,y,f,20,.3);
 figure; contourf(xr,yr,frot,16); axis image; colorbar; title(['rotated data']);
 hold on; plot(Xr,Yr,'k.');
 pause

% 3. upward continutation 
%  [fuc] = upcont(x,y,f,0.95);
%  figure; contourf(x,y,fuc,16); axis image; colorbar; title(['upward continued']);
%  pause
%  
% 4. reduction-to-the-pole 
%  [fr2p] = r2p(x,y,f,60,5);
%  figure; contourf(x,y,fr2p,16); axis image; colorbar; title(['reduced to pole']);
%  pause
%  
% % 5. analytical signal
%  [A] = analytical_signal(x,y,f,fuc,.5);
%  figure; contourf(x,y,A,16); axis image; colorbar; title(['analytical signal']);
%  