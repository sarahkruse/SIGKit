function [fftout,kx,ky,wavenum] = fft2d(indat,dx,dy);

% function [fftout,kx,ky,wavenum] = fft2d(indat,dx,dy);
% fast Fourier transform
% input:
%    indat = matrix of data values (REAL)
%    dx = spatial sampling interval in the x-direction (m)
%    dy = spatial sampling interval in the y-direction (m)
% output:
%    fftout = output matrix of unwrapped FT of indat (COMPLEX)
%    kx = matrix of x-wavenumber values
%    ky = matrix of y-wavenumber values
%    wavenum = matrix of wavenumber magnitude values
% source: Blakely?
% John Rotzien, Charly Bank, Feb 2007

 a = fft2(indat);
 fftout = fftshift(a);
 [m,n] = size(a);
 
 dkx = 2*pi/(m*dx);
 dky = 2*pi/(n*dy);
 mmid = m/2 + 1;
 nmid = n/2 + 1;
 
 for ii = 1:m;
     for jj = 1:n;
         kx(ii,jj) = (ii - mmid)*dkx ;
         ky(ii,jj) = (jj - nmid)*dky ;
         wavenum(ii,jj) = sqrt( kx(ii,jj)^2 + ky(ii,jj)^2 );
     end
 end
 