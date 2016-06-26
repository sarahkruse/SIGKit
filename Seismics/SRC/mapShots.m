
%script to plot the shot and receiver locations for a single line. If
%multiple lines are going to be plotted, then the line start and stop shot
%position should be given for each line.


clear
% filepath = 'C:\Users\Ophelia\Documents\PhD_Material\Geophysics_programming_toolkit\Seismics_class\Data\Line300';

fid = fopen('datapaths.txt');
filepaths = textscan(fid,'%s');
fclose(fid);
filepaths = filepaths{1};

if isa(filepaths,'cell');
     figure
     hold
    for n = 1:numel(filepaths)
%         addpath(filepaths{n});
        files = dir(strcat(filepaths{n},'\*.dat'));
        
        %read in the seg2file for each of the files listed in the
        %directory/directories specified by the list/filepath above
        
        %plot the shot locations as red stars and the receiver locations as blue
        %dots.
       
        
        Y = str2double(regexprep(files(1).name,'.dat',''));
        for i=1:length(files)
            [amps,TH] = seg2load(strcat(filepaths{n},'\',files(i).name));
            plot(unique(TH.tr.source),Y, 'rp','MarkerFaceColor','r')
            text(unique(TH.tr.source)-0.2,Y-0.5,regexprep(files(i).name,'.dat',''))
            plot(TH.tr.receiver,ones(length(TH.tr.receiver),1)*Y,'ko','MarkerFaceColor','b')
        end
       
    end
else
    files = dir(strcat(filepaths,'\*.dat'));
    
    %read in the seg2file for each of the files listed in the
    %directory/directories specified by the list/filepath above
    
    %plot the shot locations as red stars and the receiver locations as blue
    %dots.
    figure
    hold
    Y = str2double(regexprep(files(1).name,'.dat',''));
    for i=1:length(files)
        [amps,TH] = seg2load(strcat(filepaths{n},'\',files(i).name));
        plot(unique(TH.tr.source),Y, 'rp','MarkerFaceColor','r')
        text(unique(TH.tr.source)-0.2,-0.05,regexprep(files(i).name,'.dat',''))
        plot(TH.tr.receiver,ones(length(TH.tr.receiver),1)*Y,'ko','MarkerFaceColor','b')
    end
end


% ylim([-0.5 0.5])
axis square
legend('Shot Locations','Receiver Locations')
xlabel('Receiver/Shot Positions (m)')
ylabel('Line Position')

print('-dpng','-r200','Line300Shot_map.png');