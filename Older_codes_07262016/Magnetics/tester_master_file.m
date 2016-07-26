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
    [hour,Fraw,Diff,W,Z]=GEM_read_g(name);
    %combine datasets;
    X= vertcat(X,W);
    Y= vertcat(Y,Z);
    Fr= vertcat(Fr,([Fraw]/1000));
    Dr= vertcat(Dr,Diff);
    hr= vertcat(hr,[hour]);
end 
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
elseif Q == 'N'
end

% 2. rotate map

 
 % 2. rotate
 R= input('rotate map to Cardinal or Geomagnetic north? [Y/N]   ','s');
 if R == 'Y'
     ang = input('Enter the angle of rotation counterclockwise: ');
%should input for ang:
%   latitude; longitude; date?; elevation?
%   suggest common field site declanations with date
%   ang is the angle of rotation to Cnorth or GMnorth
%   provide common options includes fieldcamp's site
%
%DeepRiver, ON: 46.165714° N, 77.621793° W; 2016-06-23; 6.10° E  ± 0.34°
%Sechlet, BC: 49.470940° N, 123.754053° W; 2016-06-23;16.66° E  ± 0.38°
%
     gd = input('Enter axis interval in meters: ');
 
    [xr,yr,Xr,Yr,frot] = rotatemap(x,y,f,ang,gd);
    figure; contourf(xr,yr,frot,16); axis image; colorbar; title(['rotated data']);
    hold on; plot(Xr,Yr,'k.');
  end
 pause

% 3. upward continutation 
 h = input('Enter the distance to continue upward  (km?): ')
 [fuc] = upcont(x,y,f,h);
 figure; contourf(x,y,fuc,16); axis image; colorbar; title(['upward continued']);
 pause
 
% 4. reduction-to-the-pole 
 Hincla = input('Please enter inclanation of the Earth field: ')
 azim = input('Please enter declination of the Earth field: ')
 [fr2p] = r2p(x,y,f,Hincla,azim);
 figure; contourf(x,y,fr2p,16); axis image; colorbar; title(['reduced to pole']);
 pause

% % 5. analytical signal
%  [A] = analytical_signal(x,y,f,fuc,.5);
%  figure; contourf(x,y,A,16); axis image; colorbar; title(['analytical signal']);
