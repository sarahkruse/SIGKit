function [av] = dircos(incl,decl,azim);

% function [av] = dircos(incl,decl,azim);
% calculates directional cosine
% input: incl = inclination in degrees positive below horizontal
%        decl = declination in degrees positive east of true north
%        azim = azimuth of x-axis in degrees positive east of north
% source: Blakely?
% John Rotzien, Charly Bank, Feb 2007

 a = cosd(incl)*cosd(decl-azim);
 b = cosd(incl)*sind(decl-azim);
 c = sind(incl);
 
 av = [a,b,c];
