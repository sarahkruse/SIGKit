function [Mfiltered ] = FilterMag( theMagObj,slope,igrf )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Anom = zeros(length(theMagObj.Magobs),1);
d = zeros(length(theMagObj.Magobs),1);
MagAn = theMagObj.Magobs - igrf;

Easting = theMagObj.Easting;
Northing = theMagObj.Northing;
MTime = theMagObj.Time;
eref = Easting(1);
nref = Northing(1);
magref = MagAn(1);

for i = 1:length(Easting)
    d(i) = sqrt(((Easting(i)-eref)^2)+((Northing(i)-nref)^2))+0.001;
    s = abs((MagAn(i) -magref)/d(i));
    if s <=slope
        Anom(i) = MagAn(i);
        eref = Easting(i);
        nref = Northing(i);
        magref = MagAn(i);
    else
        Anom(i) = 0;
    end
end

%extract the good data from the anomaly vector
f = find(Anom~=0);
Mfilt = Anom(f);
East = Easting(f);
North = Northing(f);
Time = MTime(f);

%create a magnetic object from the filtered data and return it to the user.
Mfiltered = Magobj('Manual',East,North,Mfilt,Time);

figure
colormap(jet);
scatter(East/1000,North/1000,20,Mfilt,'filled')
xlabel('Easting (km)');
ylabel('Northing (km)');
title(['Magnetic data for ',datestr(Time(1),1),' filtered with a slope of ', ...
    num2str(slope)])
h = colorbar;
ylabel(h,'Magnetic Anomaly (nT)')

msgbox([num2str(numel(Anom)-numel(f)),' lines removed'])

end

