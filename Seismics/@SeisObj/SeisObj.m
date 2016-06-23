classdef SeisObj
    %SeisObj a class definition for storing seismic refraction data.
    %
    % Data fields are W (measured amplitude for each trace), RecLoc- relative
    % geophone locations, NumSamples - the number of data samples in each trace
    %
    %
    % In this first draft, the object is constructed from a single shot
    % file but the capability to include multiple files for a single shot
    % location could potentially be added on later.
    %
    % Example for generating a seismic object from a single file
    % S = SeisObj(1,'12.dat');
    %
    % if only the filename is given, the code will assume that there is
    % only a single file associated with the shot
    %
    % There are two data plotting options currently under development:
    %
    % plot(S,'filtered') or S.plot('simple') will create a normalized plot
    % of the seismic wavefoms with time on the y axis and shot
    % offset/geophone number on the x axis. The 'simple' plotting option
    % normalizes all the traces to the maximum waveform amplitude within
    % the dataset which may result in overfiltering.
    %
    % The 'filtered' plotting option runs a 4-pole low pass butterworth
    % filter on each waveform trace with a default cutoff frequency of 100
    % unless the user specifies an alternate value. 
    % Example plot(ST2,'filtered',50);
    %
    % plot(S,'picks') or S.plot('picks') plots the first arrival pick times
    % and locations.
    %
    %
    
    properties
        W
        RecLoc
        NumSamples
        SamplingFreq
        Acquistion_date
        Rec_unit
        Channels
        ShotPosition
        Gain
        LineNumber
    end
    
    properties(SetAccess=private, GetAccess=public)
        Pick_times
        Pick_loc
    end
    
    properties(Dependent)
        RecXMap_loc
        RecYMap_loc
        ShotXMap_loc
        ShotYMap_loc
        RecTime
    end
    
    methods
        function newSeisObj = SeisObj(varargin)
            Number_sources = varargin{1};
            
            %add the Data folder to the Matlab search path so that only the data filename needs to be given 
            filepath = pwd;
            
            %check the Operating System that the code is running on
             if isunix
            	a = '/';
            elseif ismac
                a = '/';
            elseif ispc
                a = '\';
            end
            Datapath = strcat(filepath,a , 'Data');
           
            
            
            path(path,Datapath);
            
            if nargin==2 && Number_sources==1;
                filename1 = varargin{2};
                [Amps,FileHeader] = seg2load(filename1);
                
                %convert the shot date to a Matlab serial date number
                RecDate = FileHeader.rec.date_rec;
                Rec_Time = FileHeader.rec.time_rec;
                Date = datenum(horzcat(RecDate,' ', Rec_Time));
                newSeisObj.W = Amps;
                newSeisObj.RecLoc = FileHeader.tr.receiver;
                newSeisObj.NumSamples = size(Amps,1);
                newSeisObj.SamplingFreq = FileHeader.tr.sampling;
                newSeisObj.Acquistion_date = Date;
                newSeisObj.Rec_unit = FileHeader.rec.units_rec;
                newSeisObj.Channels =FileHeader.tr.channel;
                newSeisObj.ShotPosition = unique(FileHeader.tr.source);
                newSeisObj.Gain = FileHeader.tr.gain;
                newSeisObj.LineNumber = str2double(regexprep(filename1,'.dat',''));
                
                %set up for the case where there are 2 files per shot
                %location
            elseif nargin==3 && Number_sources==2;
                filename1 = varargin{2};
                filename2 = varargin{3};
                
                % read in both seg files
                [Amps1,FileHeader1] = seg2load(filename1);
                [Amps2,FileHeader2] = seg2load(filename2);
%                 RecDate = [FileHeader1.rec.date_rec, FileHeader2.rec.date_rec];
%                 Rec_Time = [FileHeader1.rec.time_rec,FileHeader2.rec.time_rec];
%                 
%                 for i = 1:Number_sources
%                 Date(i) = datenum(horzcat(RecDate(i),' ', Rec_Time(i)));
%                 end
                
                %build the Seismic Object using the data contained within
                %the 2 seg files
                
                newSeisObj.W = [Amps1,Amps2];
                newSeisObj.RecLoc = [FileHeader1.tr.receiver, ...
                    FileHeader2.tr.receiver];
                newSeisObj.NumSamples = size(Amps1,1);
                newSeisObj.SamplingFreq = FileHeader1.tr.sampling;
%                 newSeisObj.Acquistion_date = Date;
                newSeisObj.Rec_unit = FileHeader1.rec.units_rec;
                newSeisObj.Channels =[FileHeader1.tr.channel, ...
                    FileHeader2.tr.channel];
                newSeisObj.ShotPosition = unique(FileHeader1.tr.source);
                newSeisObj.Gain = FileHeader1.tr.gain;
                newSeisObj.LineNumber = [str2double(regexprep(filename1,'.dat','')),...
                    str2double(regexprep(filename2,'.dat',''))];
                
                
                %set up for one input file not specifing number of files
                %just in case
            elseif nargin==1
                filename = varargin{1};
                [Amps,FileHeader] = seg2load(filename);
                
                %convert the shot date to a Matlab serial date number
                RecDate = FileHeader.rec.date_rec;
                Rec_Time = FileHeader.rec.time_rec;
                Date = datenum(horzcat(RecDate,' ',Rec_Time));
                newSeisObj.W = Amps;
                newSeisObj.RecLoc = FileHeader.tr.receiver;
                newSeisObj.NumSamples = size(Amps,1);
                newSeisObj.SamplingFreq = FileHeader.tr.sampling;
                newSeisObj.Acquistion_date = Date;
                newSeisObj.Rec_unit = FileHeader.rec.units_rec;
                newSeisObj.Channels =FileHeader.tr.channel;
                newSeisObj.ShotPosition = unique(FileHeader.tr.source);
                newSeisObj.Gain = FileHeader.tr.gain;
                newSeisObj.LineNumber = str2double(regexprep(filename,'.dat',''));
            end
        end
            
                       
            function RecTime = get.RecTime(theSeisObj)
                dt = theSeisObj.SamplingFreq(1);
                RecTime = (0:dt:(theSeisObj.NumSamples-1)* ...
                    unique(theSeisObj.SamplingFreq))*1e3;
            end
            
            %plotting option for the magnetic wiggles
            function plot(theSeisObj,varargin)
                
                if strcmp(varargin{1},'filtered') 
                    %read the cutoff frequency from the user input or set
                    %to a default value of 100 if no filter value is given
                    if length(varargin)>=2;
                    F = varargin{2};
                    else
                        F = 100;
                    end
                    
                    dt =  theSeisObj.SamplingFreq(1);
                    t = theSeisObj.RecTime;
                    traces = theSeisObj.W;
                    Traces = traces(1:theSeisObj.NumSamples,:);
                    x = theSeisObj.RecLoc;
                    
                    %create a filtered version of the waveforms. 
                    [b,a] = butter(2,F/(1/dt));
                    
                    TRfilt = zeros(size(Traces));
                    TRnorm = zeros(size(Traces));
                    
                    for ind=1:size(Traces,2)
                        TRfilt(:,ind) = filtfilt(b,a,Traces(:,ind));
                        TRnorm(:,ind) = TRfilt(:,ind)/max(TRfilt(:,ind));
                    end
                    
                    figure
                    wiggle(t,x,TRnorm);
                    box on;
                    set(gca,'YGrid','on')
%                     tick_locs = get(gca,'YTick');
%                     set(gca,'YTickLabel',tick_locs* ...
%                         unique(theSeisObj.SamplingFreq)*1e3);
                    xlabel('Geophone Location');
                    ylabel('Time (ms)');
                    
                    title({['Record #', num2str(theSeisObj.LineNumber),'; ' ...
                        'Source Location =', num2str(theSeisObj.ShotPosition)]; ...
                        ['']}, 'FontWeight','bold');
                    
                                                        
                elseif strcmp(varargin,'simple')
                    figure;
                    t = theSeisObj.RecTime;
                    x = theSeisObj.RecLoc;
                    
                    wiggle(t,x,theSeisObj.W);
                    box on;
                    set(gca,'YGrid','on')

                    xlabel('Receiver Location');
                    ylabel('Time (ms)');
                    title({['Record #', num2str(theSeisObj.LineNumber),'; ' ...
                        'Source Location =', num2str(theSeisObj.ShotPosition)]; ...
                        ['']}, 'FontWeight','bold');
                    
                     for i =1:4:size(theSeisObj.W,2);
                        text(i,-80, num2str(theSeisObj.RecLoc(i)- ...
                            theSeisObj.ShotPosition));
                    end
                    text(-3,-75,'Offset (m)', 'FontWeight','bold');
                    
                else strcmp(varargin,'picks')
                    figure;
                    plot(theSeisObj.Pick_loc,theSeisObj.Pick_time,'bo')
                    xlabel('Geophone location')
                    ylabel('Pick times (ms)')
                    title(['First Arrival Picks for Record #', ...
                        num2str(theSeisObj.LineNumber)], 'FontWeight','bold');
                    
                end
                
            end
        
               
        %Define some plotting routines for the data
        
        %use ginput to define the first arrival pick locations and times
        %for building the full seismic object
        function [X,T] = picktimes(theSeisObj)
            
            disp('pick ALL first breaks now, press enter when done')
            [X,T] = ginput;
            X = round(X);
            
            D = [X,T];
            hold on;
            plot (X,T,'b+');
            
            % quality control of picks
            % check that red line alligns with first break of each wiggle
%             T = T*theSeisObj.SamplingFreq(1)*1000;
                   
            %create a plot of the individual waveforms for reselecting
            %first motions
            disp('please repick first breaks')
            scrsz = get(0,'ScreenSize');
            t = theSeisObj.RecTime;
            traces = theSeisObj.W;
            Traces = traces(1:theSeisObj.NumSamples,:);
            
            %The filtered waveform is not being plotted at the moment
            %because I found that it is sometimes accidentally selected
            %instead of the actual waveform which results in an error.
            for index=1:numel(theSeisObj.Channels)
                figure('Position',[1 1 scrsz(3)*0.9 scrsz(4)*0.9]);
%                 plot(t, TRnorm(:,index), 'b');
                plot(t, Traces(:,index)/max(Traces(:,index)), 'k');
                hold on;
                plot([T(index) T(index)],[1 -1], 'r');
                title(['Shot at ',num2str(theSeisObj.ShotPosition),...
                    ' m and geophone at ',num2str(theSeisObj.RecLoc(index)),' m'])
                legend('Normalized Waveform','Original Pick')
                [T(index),A]=ginput(1);
                %plot([T(index) T(index)],[1 -1], 'c', 'linewidth',2);pause
                close
            end
            
            %show picks
            x = theSeisObj.RecLoc;
            dt = theSeisObj.SamplingFreq(1);
            
            %plot the new picks on the original waveform figure as red
            %pluses on the original figure
            figure(1);
            
%           provide 2 plotting options for simple and filtered wiggle plots

%           For simple wiggle plot
%             plot(theSeisObj.Channels, T/(dt*1000), 'r+')
% %           For filtered plot
            plot(x, T, 'r+')
            
            %save the picks to a .mat file name using the same line number
            %as the original file.
            if numel(theSeisObj.LineNumber)==1
            filename = [num2str(theSeisObj.LineNumber),'_picks.mat'];
                        
            else
                filename = [num2str(theSeisObj.LineNumber(1)),'_', ...
                    num2str(theSeisObj.LineNumber(2)), '_picks.mat'];
            end
            x = x';
            save(filename,'x','T')
        end
        
    end
    
end

