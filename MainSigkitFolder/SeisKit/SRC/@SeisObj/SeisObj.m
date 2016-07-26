classdef SeisObj
    %SeisObj a class definition for storing seismic refraction data.
    %
    % Data fields are W (measured amplitude for each trace), RecXProf-
    % relative geophone locations, NumSamples - the number of data samples
    % in each trace
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
    % Example plot(theSeisObj,'filtered',50);
    %
    % plot(S,'picks') or S.plot('picks') plots the first arrival pick times
    % and locations.
    %
    %
    
    properties
        W
        RecXProf
        NumSamples
        SamplingInt
        Acquistion_date
        Rec_unit
        Channels
        ShotXProf
        ShotZ
        RecZ
        Gain
        FileNumber
        
    end
    
%     properties(SetAccess=private, GetAccess=public)
%         Pick_times
%         Pick_loc
%     end
    
    properties(Dependent,GetAccess=public)
        RecXMap
        RecYMap
        ShotXMap
        ShotYMap
        RecTime
    end
    
    methods
        function newSeisObj = SeisObj(varargin)
            Number_sources = varargin{1};
			
            %find the current working directory  
            fs = filesep;
            filepath = pwd;
            
            Datapath = strcat([filepath fs 'Seismics' fs 'Data']);
            
            
            %add the Data folder to the Matlab search path so that only the
            %filename needs to be specified.
            path(path,Datapath);
            
            if nargin==2 && Number_sources==1;
                filename1 = varargin{2};
                [Amps,FileHeader] = seg2load(filename1);
                
                %convert the shot date to a Matlab serial date number
                RecDate = FileHeader.rec.date_rec;
                Rec_Time = FileHeader.rec.time_rec;
                Date = datenum(horzcat(RecDate,' ', Rec_Time));
                newSeisObj.W = Amps;
                newSeisObj.RecXProf = FileHeader.tr.receiver;
                newSeisObj.NumSamples = size(Amps,1);
                newSeisObj.SamplingInt = FileHeader.tr.sampling;
                newSeisObj.Acquistion_date = Date;
                newSeisObj.Rec_unit = FileHeader.rec.units_rec;
                newSeisObj.Channels =FileHeader.tr.channel;
                newSeisObj.ShotXProf = unique(FileHeader.tr.source);
                newSeisObj.Gain = FileHeader.tr.gain;
                newSeisObj.FileNumber = str2double(regexprep(filename1,'.dat',''));
                
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
                newSeisObj.RecXProf = [FileHeader1.tr.receiver, ...
                    FileHeader2.tr.receiver];
                newSeisObj.NumSamples = size(Amps1,1);
                newSeisObj.SamplingInt = FileHeader1.tr.sampling;
%                 newSeisObj.Acquistion_date = Date;
                newSeisObj.Rec_unit = FileHeader1.rec.units_rec;
                newSeisObj.Channels =[FileHeader1.tr.channel, ...
                    FileHeader2.tr.channel];
                newSeisObj.ShotXProf = unique(FileHeader1.tr.source);
                newSeisObj.Gain = FileHeader1.tr.gain;
                newSeisObj.FileNumber = [str2double(regexprep(filename1,'.dat','')),...
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
                newSeisObj.RecXProf = FileHeader.tr.receiver;
                newSeisObj.NumSamples = size(Amps,1);
                newSeisObj.SamplingInt = FileHeader.tr.sampling;
                newSeisObj.Acquistion_date = Date;
                newSeisObj.Rec_unit = FileHeader.rec.units_rec;
                newSeisObj.Channels =FileHeader.tr.channel;
                newSeisObj.ShotXProf = unique(FileHeader.tr.source);
                newSeisObj.Gain = FileHeader.tr.gain;
                newSeisObj.FileNumber = str2double(regexprep(filename,'.dat',''));
            end
        end
            
                       
            function RecTime = get.RecTime(theSeisObj)
                dt = theSeisObj.SamplingInt(1);
                RecTime = (0:dt:(theSeisObj.NumSamples-1)* ...
                    unique(theSeisObj.SamplingInt))*1e3;
            end
            
            %plotting option for the seismi wiggles
            function plot(theSeisObj,varargin)
                %overloaded plotting function for creating several plots
                %from the seismic object data
                %
                %plot(S,'filtered') or S.plot('simple') will create a
                %normalized plot of the seismic wavefoms with time on the y
                %axis and shot offset/geophone number on the x axis. The
                %'simple' plotting option normalizes all the traces to the
                %maximum waveform amplitude within the dataset which may
                %result in overfiltering.
                %
                %The 'filtered' plotting option runs a 4-pole low pass
                %butterworth filter on each waveform trace with a default
                %cutoff frequency of 100 unless the user specifies an
                %alternate value. Example plot(theSeisObj,'filtered',50);
                
                if strcmp(varargin{1},'filtered') 
                    %read the cutoff frequency from the user input or set
                    %to a default value of 100 if no filter value is given
                    if length(varargin)>=2;
                    F = varargin{2};
                    else
                        F = 100;
                    end
                    
                    dt =  theSeisObj.SamplingInt(1);
                    t = theSeisObj.RecTime;
                    traces = theSeisObj.W;
                    Traces = traces(1:theSeisObj.NumSamples,:);
                    x = theSeisObj.RecXProf;
                    
                    %create a filtered version of the waveforms. 
                    [b,a] = butter(2,F/(1/dt));
                    
                    TRfilt = zeros(size(Traces));
                    TRnorm = zeros(size(Traces));
                    
                    for ind=1:size(Traces,2)
                        TRfilt(:,ind) = filtfilt(b,a,Traces(:,ind));
                        TRnorm(:,ind) = TRfilt(:,ind)/max(TRfilt(:,ind));
                    end
                    
                    figure
                    %flipping the polarity on the waveforms to make the
                    %first motions positive;
                    TRnorm = TRnorm*-1;
                    
                    wiggle(t,x,TRnorm);
                    box on;
                    set(gca,'YGrid','on')
%                     tick_locs = get(gca,'YTick');
%                     set(gca,'YTickLabel',tick_locs* ...
%                         unique(theSeisObj.SamplingInt)*1e3);
                    xlabel('Geophone Location');
                    ylabel('Time (ms)');
                    
                    title({['File #', num2str(theSeisObj.FileNumber),'; ' ...
                        'Source Location =', num2str(theSeisObj.ShotXProf)]; ...
                        ['']}, 'FontWeight','bold');
                    
                                                        
                elseif strcmp(varargin{1},'clipped')
                                
                  if length(varargin)>=2;
                    gain = varargin{2};
                    
                    if varargin{2}>1;
                        NG =inputdlg('Please enter a gain value between 0 and 1','Error',1);
                        gain = NG{1}; 
                    end
                    else
                        gain = 0.2;
                  end       
                  
                    t = theSeisObj.RecTime;
                    x = theSeisObj.RecXProf;
                    traces = theSeisObj.W;
                    Traces = traces(1:theSeisObj.NumSamples,:);
                    TRclipped = zeros(size(Traces));
                    TRnorm = zeros(size(Traces));
                    
                                       
                    for ind=1:size(Traces,2)
                        TRnorm(:,ind) = Traces(:,ind)/max(abs(Traces(:,ind)));
                        TRclipped(:,ind) = TRnorm(:,ind);
                        for i = 1:theSeisObj.NumSamples
                            if abs(TRclipped(i,ind))> gain*max(abs(TRclipped(:,ind)));
                                if TRclipped(i,ind) >0
                                   TRclipped(i,ind)=gain*max(abs(TRclipped(:,ind)));
                                else
                                    TRclipped(i,ind) = -1*gain*max(abs(TRclipped(:,ind)));
                                end
                            end
                        end
                    end
                    figure;
                    
                    %flipping the polarity on the waveforms to make the
                    %first motion positive;
                    TRclipped = TRclipped*-1;
                    
                    wiggle(t,x,TRclipped);
                    box on;
                    set(gca,'YGrid','on')
                 
                    xlabel('Receiver Location');
                    ylabel('Time (ms)');
                    title({['File #', num2str(theSeisObj.FileNumber),'; ' ...
                        'Source Location =', num2str(theSeisObj.ShotXProf)]; ...
                        ['']}, 'FontWeight','bold');
                    
                     for i =1:4:size(theSeisObj.W,2);
                        text(i,-80, num2str(theSeisObj.RecXProf(i)- ...
                            theSeisObj.ShotXProf));
                    end
                    text(-3,-75,'Offset (m)', 'FontWeight','bold');
                    if max(t) >300
                        ylim([0 300])
                    end
                    
                elseif strcmp(varargin,'simple');
                    figure;
                    t = theSeisObj.RecTime;
                    x = theSeisObj.RecXProf;
                    
                    wiggle(t,x,theSeisObj.W);
                    box on;
                    set(gca,'YGrid','on')

                    xlabel('Receiver Location');
                    ylabel('Time (ms)');
                    title({['File #', num2str(theSeisObj.FileNumber),'; ' ...
                        'Source Location =', num2str(theSeisObj.ShotXProf)]; ...
                        ['']}, 'FontWeight','bold');
                    
                     for i =1:4:size(theSeisObj.W,2);
                        text(i,-80, num2str(theSeisObj.RecXProf(i)- ...
                            theSeisObj.ShotXProf));
                    end
                    text(-3,-75,'Offset (m)', 'FontWeight','bold');
                    
                else strcmp(varargin,'picks')
                    figure;
                    plot(theSeisObj.Pick_loc,theSeisObj.Pick_time,'bo')
                    xlabel('Geophone location')
                    ylabel('Pick times (ms)')
                    title(['First Arrival Picks for Record #', ...
                        num2str(theSeisObj.FileNumber)], 'FontWeight','bold');
                    
                end
                
            end
    end
               
        %Define some plotting routines for the data
        
        methods 
         varargout = picktimes(theSeisObj);
            
        end
        
end

