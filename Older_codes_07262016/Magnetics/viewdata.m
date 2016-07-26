% viewdata.m
 clear all; close all; format compact;

% . walkmag with GPS
  [hr10,E10,N10,F10]=GEM_read_WMutm('sample_data/10ob_utm.wm');
 
% . read grid data 
  [hour,Fraw,Diff,X,Y]=GEM_read_g('sample_data/01.txt');
 
% . G856 data
  [day,hour,field]=G856_read('sample_data/G856.txt');

% . intermagnet observatory data 
  [Tvic,Fvic]=intermag_show('sample_data/vic20090720vmin.min');

 
 