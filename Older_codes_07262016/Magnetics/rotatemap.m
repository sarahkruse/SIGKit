function [xr,yr,Xr,Yr,Fr] = rotatemap(x,y,F,ang,gd);

% function [Xr,Yr,Fr] = rotatemap(x,y,F,ang,gd);
% rotates gridded dataset into geomagnetic coordinates or cardinal 
% magnetic directions for reduction-to-the-pole
% input:
%    x,y = locations identifying E and N of grid (vectors)
%    F   = gridded map data - eg, suitable for pcolor(x,y,F)
%    ang = angle to rotate (counterclockwise in degrees)
%    gd  = new grid dimension (in m, same in E and N)
% output:
%    xr, yr = new grid locations (row vectors)
%    Xr, Yr = are original data locations in new grid
%    Fr     = map data in rotated coordinates
% note: code will add median values into new corners
%       otherwise cannot use output for fast Fourier transformation
%       (eg, to do upward continuation or reduction to the pole)
% John Rotzien, Charly Bank, Feb 2007

% 1.  set up rotation matrix
 c = cosd(ang);
 s = sind(ang);
 A = [ c -s
       s  c ];
   
%   and rotate points
 [X,Y] = meshgrid(x,y);
 for ii=1:size(X,1)
     for jj=1:size(X,2)
         r = A*[ X(ii,jj); Y(ii,jj) ];
         Xr(ii,jj) = r(1);
         Yr(ii,jj) = r(2);
     end
 end
 
% 2. now regrid rotated datapoints
%   first define new grid
 xr = min(min(Xr)):gd:max(max(Xr));
 yr = min(min(Yr)):gd:max(max(Yr));
%  then produce row vectors of rotated locations and values
 x1 = [];
 y1 = [];
 f1 = [];
 for ind = 1:size(F,1);
     x1 = [ x1, Xr(ind,:) ];
     y1 = [ y1, Yr(ind,:) ];
     f1 = [ f1,  F(ind,:) ];
 end
%   here add median values into new corners (see "note" in preamble)
 x1 = [x1, min(min(Xr)), min(min(Xr)), max(max(Xr)), max(max(Xr)) ];
 y1 = [y1, min(min(Yr)), max(max(Yr)), min(min(Yr)), max(max(Yr)) ];
 fM = median(median(F));
 f1 = [f1, fM          , fM          , fM          , fM           ];
%   finally interpolate values in new grid
 Fr = griddata(x1,y1,f1,xr,yr');


