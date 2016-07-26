function [A] = analytical_signal(magobj, fuc) %why can't i add argument 'fuc'?
% Error using MagObj2/analytical_signal
% Too many input arguments.
% when I call analytical_signal(m2, f1)?

% function [A] = analytical_signal(E,N,F,G,h);
% calculates amplitude of analytical signal for
% magnetic data provided on regular grid given by x and y
% input:
%    x = x-coordinates (must be a vector)
%    y = y-coordinates (must be a vector)
%    F = total field value (matrix)
%    G = total field at 2nd elevation
%        either from gradiometer data, or from upward continuation
%    h = height difference between fields F and G
% output: A = amplitude of analytical signal
% source: Roest, Verhoef, Pilkington, 1992. Magnetic interpretation 
%    using the 3D analytical signal. Geophysics, vol 37(1), pg 116-125
% equation 5 defines the 3D amplitude function 
% of potential field anomaly M as
%       A(x,y) = sqrt( (dM/dx)^2 + (dM/dy)^2 + (dM/dz)^2 )
% Charly Bank and John Rotzien, Feb 2007

X = magobj.Easting;
Y = magobj.Northing;
Fr = magobj.Fraw;

gridinfo= [' X max:',num2str(max(X)),' X min:',num2str(min(X)),' Y max:',num2str(max(Y)),' Y min:',num2str(min(Y))];
    disp(gridinfo)
    % possibly modify to automatically detect max/min: refer to Ofilia's
    % code
    x= input('Define x axis as (start:interval:end)...   ');
    y= input('Define y axis as (start:interval:end)...   ');
 %grid options can be as follows or user input as above:
 %      x=0.5:.5:13.5; y=0.5:.5:7;
 %x= linespace(X(max):X(min):20); y= linespace (Y(max):Y(min):20)
 %      *a pull down list of calculated suggestions and user input option*
 f=griddata(X,Y,Fr,x,y');
 hdiff = input('Enter the height difference between the two gradiometers (m): ')
% G = total field at 2nd elevation
%        either from gradiometer data, or from upward continuation
 second = input('Total field from the second elevation from gradiometer? [Y/N] ', 's')
 if second == 'Y'
     X2=[]; Y2=[]; Fr2=[]; Dr2=[]; hr2=[];
     for N = (1:input('Number of datasets?   '))
         name = input('Enter individual filenames for each seperate file...    ','s')
         [hour,Fraw,Diff,W,Z]=GEM_read_g(name);
         X2= vertcat(X2,W);
         Y2= vertcat(Y2,Z);
         Fr2= vertcat(Fr2,([Fraw]/1000));
         Dr2= vertcat(Dr2,Diff);
         hr2= vertcat(hr2,[hour]);
     end
     g = griddata(X2,Y2,Fr2,x,y');
 elseif second == 'N'
%      if nargin > 1
%        g = fuc; %?
%      else
       g = upcont(magobj);
%      end
 end

% number of field values and grid size
 [n,m] = size(f);
 dx = x(2) - x(1);
 dy = y(2) - y(1);
 
% derivatives in x-direction
 dM_dx = zeros(size(f));
 dM_dx(1,:) = ( f(2,:) - f(1,:) )/dx;
 for ii=2:n-1
     dM_dx(ii,:) = ( f(ii+1,:) - f(ii-1,:) )/2/dx;
 end
 dM_dx(n,:) = ( f(n,:) - f(n-1,:) )/dx;
 
% derivatives in y-direction
 dM_dy = zeros(size(f));
 dM_dy(:,1) = ( f(:,2) - f(:,1) )/dy;
 for ii=2:m-1
     dM_dy(:,ii) = ( f(:,ii+1) - f(:,ii-1) )/2/dy;
 end
 dM_dy(:,m) = ( f(:,m) - f(:,m-1) )/dy;


% derivatives in z-direction
 dM_dz = (g-f)/hdiff;


 
% amplitude function is
 A = sqrt( dM_dx.^2 + dM_dy.^2 + dM_dz.^2 );
 
figure; contourf(x,y,A,16); axis image; colorbar; title(['analytical signal']);
