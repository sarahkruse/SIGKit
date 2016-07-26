function [ easting,northing ] = LL2UTM( Lat,Lon )
%LL2UTM converts a one or more pair of coordinates from latlong to UTM
%   zone specification is not necessary because the code will find the
%   appropriate utm zone

%find the appropriate utmzone and map projection for the coordinates
z1 = utmzone(Lat,Lon);
[ellipsoid,estr] = utmgeoid(z1);

utmstruct = defaultm('utm'); 
utmstruct.zone = z1; 
utmstruct.geoid = ellipsoid; 
utmstruct = defaultm(utmstruct);

[easting,northing] =mfwdtran(utmstruct,Lat,Lon);

end

