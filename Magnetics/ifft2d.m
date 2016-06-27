function ifftout = ifft2d(indat);

% function ifftout = ifft2d(indat);
% inverse fast Fourier transform

 a = fftshift(indat);
 ifftout = real( ifft2(a) );
 