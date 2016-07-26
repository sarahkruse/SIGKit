function [ Lon,Lat,Time,elev ] = readgpsDG100( gpsfile )
%readgpsDG100 reads the input from a DG100 gps file and formats it for
%Matlab
%   Detailed explanation goes here
fid = fopen(gpsfile);

GPS_data = textscan(fid, '%d %s %s %f %f %f %f', 'Headerlines',1);

%extract the needed data from the matrix of GPS data
Dlon = ceil(GPS_data{5}/100);
Dlat = floor(GPS_data{4}/100);
elev = GPS_data{7};
YMD = GPS_data{2};
time = GPS_data{3};

%Convert the longitude and latitude data to decimal degrees from the
%compound form that DG100 stores it in.
DlatM = GPS_data{4}-(Dlat*100);
DD = DlatM/60;
Lat = Dlat+DD;

DlonM = (Dlon*100)-GPS_data{5};
DD = DlonM/60;
Lon = Dlon-DD;

%split the date strings into individual columns to make converting to
%Matlab serial number easier.
% Days = mat2cell(zeros(length(YMD),1));
% HMS = mat2cell(zeros(length(YMD),1));

for i = 1:numel(YMD)
    Days(i,:) = strsplit(YMD{i},'-');
    HMS(i,:) = strsplit(time{i},':');
end

%fix the year data so that Matlab properly interpretes the data.
Time = zeros(length(YMD),1);

for i = 1:length(YMD)
    Time(i) = datenum(str2double(Days{i,1}),str2double(Days{i,2}), ...
       str2double(Days{i,3}), str2double(HMS{i,1}),str2double(HMS{i,2}) ...
        ,str2double(HMS{i,3}));
end

%reverse the sort order of the magtimes so that the earliest times is at
%the top
[Time,I] = sort(Time);
elev = elev(I);
Lon = Lon(I);
Lat = Lat(I);
end


