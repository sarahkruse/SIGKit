function [fuc] = upcont(x,y,f,h);

% function [fuc] = upcont(x,y,f,h);
% performs upward continuation of magnetic/gravity data
% inputs:
%    x = x-ccordinates (must be a vector)
%    y = y-coordinates (must be a vector)
%    f = field values (matrix)
%    h = new observation height (distance to continue upward)
% output:
%    fuc = data at new height
% source: Blakely?
% (updated for rectangular grid)
% John Rotzien, Charly Bank, Feb 2007

% 1. pre-expand to get size in powers of 2
%    get number of lines and columns
 rowno = size(f,1);
 colno = size(f,2);
%    find next powers of 2
 row2 = ceil( log(rowno)/log(2) ); row2 = 2^row2;
 col2 = ceil( log(colno)/log(2) ); col2 = 2^col2;
%    add interpolated values to each row
 for ii=1:rowno;
     f(ii,colno+1:col2) = interp1([colno,col2+1],...
         [f(ii,colno),f(ii,1)],[colno+1:1:col2]);
 end
 
 %pause
 
% for all columns
 for ii=1:col2;
     f(rowno+1:row2,ii) = interp1([rowno,row2+1],...
         [f(rowno,ii),f(1,ii)],[rowno+1:1:row2]');
 end
 
% 2. fast Fourier transform
 xspacing = x(2)-x(1);
 yspacing = y(2)-y(1);
 [f_fft,u,v,k] = fft2d(f,xspacing,yspacing);
 
% 3. upward continuation in Fourier space
 [m,n] = size(k);
 for ii = 1:m;
     for jj = 1:n;
         filt(ii,jj) = exp( -1*k(ii,jj)*h );
     end
 end
 fuc_fft = f_fft.*filt;

% 4. inverse Fourier transform
 fuc = ifft2d(fuc_fft);
 
% 5. cut new data back to map area
 fuc = fuc(1:rowno, 1:colno);
