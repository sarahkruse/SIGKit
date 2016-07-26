function [MagObs, Time ] = readmag858( magfile )
%readmag858 reads a space delimited mag 858 data file
%   Detailed explanation goes here

%read the mag datafile into matlab and extract only the lines that start
%with 0
Datacell = fileread(magfile);
newfile = regexp(Datacell, '^[0]\s.*$', 'match', 'lineanchors', 'dotexceptnewline');

outfile = 'new_Magfile.stn';
fid = fopen(outfile,'wt');
fprintf(fid,'%s\n',newfile{:});
fclose(fid);

%read in the new abbreviated datafile
fid = fopen(outfile);

% Datacell = textscan(fid,'%d %f %d %s %s %d','CommentStyle','6');
Datacell = textscan(fid,'%d %f %d %s %s %d');

%extract the date cells and magnetic data from the full matrix
DMY = Datacell{5};
time = Datacell{4};
MagObs = Datacell{2};

%split the date strings into individual columns to make converting to
%Matlab serial number easier.
% Days = mat2cell(zeros(length(DMY),1));
% HMS = mat2cell(zeros(length(DMY),1));

for i = 1:numel(DMY)
    Days(i,:) = strsplit(DMY{i},'/');
    HMS(i,:) = strsplit(time{i},':');
end

%fix the year data so that Matlab properly interpretes the data.
Year = zeros(length(Days),1);

for i=1:length(Days)
    Year(i) = 2000 + str2double(Days{i,3});
end

Time = zeros(length(Year),1);

for i = 1:length(Year)
    Time(i) = datenum(Year(i),str2double(Days{i,1}),str2double(Days{i,2}), ...
        str2double(HMS{i,1}),str2double(HMS{i,2}),round(str2double(HMS{i,3})));
end

%reverse the sort order of the magtimes so that the earliest times is at
%the top
[Time,I] = sort(Time);
MagObs = MagObs(I);
end

