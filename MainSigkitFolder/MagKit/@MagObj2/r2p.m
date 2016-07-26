function [fr2p] = r2p(magobj);
% function [fr2p] = r2p(x,y,f,Hincla,azim);
% performs reduction-to-the-pole of magnetic data
% inputs: x = x-coordinates (must be vector)
%         y = y-coordinates (must be vector)
%         f = field values (matrix)
%         Hincla = inclination of Earth field (in degrees)
%         azim = declination of Earth field   (in degrees)
% output: fr2p = magnetic data reduced to the pole
% source: Blakely?
% John Rotzien, Charly Bank, Feb 2007

X = magobj.Easting;
Y = magobj.Northing;
Fr = magobj.Fraw;
% get extra info
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
 incl = input('Enter inclanation of the Earth field: ')
 decl = input('Enter declination of the Earth field: ')

% 1. pre-expand to get size in powers of 2
%    get number of lines and columns

 rowno = size(f,1);
 colno = size(f,2);
%    find next powers of 2
 row2 = ceil( log(rowno)/log(2) ); row2 = 2^row2;
 col2 = ceil( log(colno)/log(2) ); col2 = 2^col2;
%    add interpolated values to each row
 for ii=1:rowno
     f(ii,colno+1:col2) = interp1([colno,col2+1],...
         [f(ii,colno),f(ii,1)],[colno+1:1:col2]);
 end
% for all columns
 for ii=1:col2
     f(rowno+1:row2,ii) = interp1([rowno,row2+1],...
         [f(rowno,ii),f(1,ii)],[rowno+1:1:row2]');
 end
 
% 2. fast Fourier transform
 xspacing = x(2)-x(1);
 yspacing = y(2)-y(1);
 [f_fft,u,v,k] = fft2d(f,xspacing,yspacing);
 
% 3. reduce to the pole in Fourier space
%    get magnetization directions
 [f] = dircos(incl,0,decl);  % direction of Earth field
 m = f;                        % not considering remanent magnetization
 
 k = sqrt( u.^2 + v.^2 );
 
 a1 =  m(3)*f(3) - m(1)*f(1);
 a2 =  m(3)*f(3) - m(2)*f(2);
 a3 = -m(2)*f(1) - m(1)*f(2);
 
 b1 =  m(1)*f(3) + m(3)*f(1);
 b2 =  m(2)*f(3) + m(3)*f(2);
 
 [i1,j1] = size(k);
 for ii=1:i1;
     for jj=1:j1;
         div = ( a1*u(ii,jj)^2 + a2*v(ii,jj)^2 + a3*u(ii,jj)*v(ii,jj) +...
             i*k(ii,jj)*( b1*u(ii,jj) + b2*v(ii,jj) ) );
         if div == 0
             div = .1 + i*.1;
         end
         T(ii,jj) = k(ii,jj)^2/div;
     end
 end
 
 fr2p_fft = f_fft.*T;
 
% 4. inverse Fourier transform
 fr2p = ifft2d(fr2p_fft);
 
% 5. cut new data back to map area
 fr2p = real(fr2p(1:rowno,1:colno));
 
 figure; contourf(x,y,fr2p,16); axis image; colorbar; title(['reduced to pole']);    
 