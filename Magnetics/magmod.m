% magmod.m
% computes magnetic and gravity anomalies for
% infinitely long 2D body, uses code gm2d.m from
% Singh (2002). Simultaneous computation of gravity
%    and magnetic anomalies resulting from a 2-D object
%    Geophysics, 67(3), pg. 801-806
% cgs units used  :(
% Charly Bank, 09 Nov 2004
 clear all; %close all; format compact;
% addpath ../matlab

%% input parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% . . ambient magnetic field
  Hintn=46000; % intensity in gamma
  Decl=0;      % declination in degrees clockwise from N
  Hincl=90;   % inclination in degrees downward from horizontal
  pfang=0;   % azimuth + xaxis, in degrees clockwise from N
%% . . polygon body: (x,z) pairs in m
 Corner=[8 0.5; 12 0.5; 12 5; 8 5];  % corners clockwise [m]
%% . . since code does compute gravity anomaly...
 grho=.5;   % density contrast [g/cm^3]
%% . . magnetic body
 msus=.07; % susceptibility in cgs,
 mrem=0;    % strength of remnant magnetization [gamma]
 minc=0;    % its inclination and 
 mdec=0;    % declination [degree]
%% . . other input
 fht=0.25;       % height of observation plane
 X=[0:.1:20]';   % station locations (column vector!)
%% end input parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 Corner(:,2)=Corner(:,2)+fht;
 phyc(1,1:5)=[grho msus mrem minc mdec];
 
 [Fz,Dt,Hx,Hz]=gm2d(Hintn,Decl,Hincl,pfang,Corner,phyc,X);
% 

 figure; 
 subplot(3,1,3); fill(Corner(:,1),-Corner(:,2)+fht,'c'); 
    ylabel('depth [m]'); xlabel('profile distance [m]')
    xlim([min(X) max(X)]); ylim([-max(Corner(:,2))+fht 0]); 
    grid on; hold on
    % show direction of ambient field
    ua=cos(Hincl/180*pi); va=-sin(Hincl/180*pi);
    ua=[ua ua ua ua ua ua]; va=[va va va va va va];
    posx=(max(X)-min(X))/4;
    xx=[min(X)+posx min(X)+2*posx min(X)+3*posx]; xx=[xx,xx];
    yy=-max(Corner(:,2))+fht; yy=[0 0 0 yy yy yy];
    quiver(xx,yy,ua,va,'g')
    % show direction of magnetization of body
    if mrem>0
      xb=mean(Corner(:,1)); yb=mean(-Corner(:,2))+fht;
      ub=cos(minc/180*pi); vb=-sin(minc/180*pi);
      quiver(xb,yb,ub,vb,'r')
    end
 subplot(3,1,2); plot(X,Hz,'b-'); grid on; ylabel('vertical field')
 subplot(3,1,1); plot(X,Dt,'r-'); grid on; ylabel('total field')
      