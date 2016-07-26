function [fuc] = upcont(magobj)
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

% get extra info
X = magobj.Easting;
Y = magobj.Northing;
Fr = magobj.MagAn;

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
 noh = input('Enter the distance to continue upward  (m): ');


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
 [f_fft,~,~,k] = fft2d(f,xspacing,yspacing);
 
% 3. upward continuation in Fourier space
 [m,n] = size(k);
 for ii = 1:m;
     for jj = 1:n;
         filt(ii,jj) = exp( -1*k(ii,jj)*noh );
     end
 end
 fuc_fft = f_fft.*filt;

% 4. inverse Fourier transform
 fuc = ifft2d(fuc_fft);
 
% 5. cut new data back to map area
 fuc = fuc(1:rowno, 1:colno);
 
 figure; contourf(x,y,fuc,16); axis image; colorbar; title(['upward continued']);
