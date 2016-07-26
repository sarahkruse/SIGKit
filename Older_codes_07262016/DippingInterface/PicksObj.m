classdef PicksObj
    %PicksObj a class definition for storing seismic refraction 
    %first arrival picks.
    %
    % assume first input parameter is input file name
 
    
    properties
        ShotXProf  %position in survey tape coordinate system
        ShotZ
        ShotXMap
        ShotYMap
        RecXProf  %position in survey tape coordinate system
        RecZ
        RecXMap
        RecYMap
        PickTime  %assumed ms??
    end
    
    methods 
        
        %********** CONSTRUCT *********************************************
        % this first draft constructor function assumes all z values are zero and map
        % coodinates are not known, and that the picks file contains the
        % arrays x and t
        %first input parameter = file name containing picks arrays in x, t
        %format
        %second input parameter = shot location
        function Picks = PicksObj(varargin)
            filein = varargin{1};
            load(filein,'x','t'); % replace these lines to accomodate Ophelia's pick file format
            Picks.RecXProf = x;   % replace these lines to accomodate Ophelia's pick file format
            Picks.PickTime = t;   % replace these lines to accomodate Ophelia's pick file format
            Picks.ShotXProf = varargin{2};
        end
        
        
        %************ SIMPLE PLOT WITH SHOT *******************************
        function ps = PlotPicksWithShot(P,plot_title)
            ps = plot(P.RecXProf, P.PickTime,'.k'); hold on
            plot(P.ShotXProf,0,'xr');
            xlabel('distance (m)');
            ylabel('time (ms)');
            title(plot_title);
        end
    end
end
