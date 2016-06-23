classdef SeisObj_full < SeisObj
    %this is an inherited class of the basic seismic refraction object
    
     properties(SetAccess=private, GetAccess=public)
        Pick_times
        Pick_loc
     end
      
   
    
    methods
        function newSeisObj_full = SeisObj_full(varargin)
            
            if nargin==1 && isclass(varargin{1}, SeisObj)
                theSeisObj=varargin{1};
            Picks_file = [num2str(theSeisObj.LineNumber),'_picks.mat'];
                        
            [X,T] = load(Picks_file);
            
            newSeisObj_full.Pick_times = T;
            newSeisObj_full.Pick_loc = X;
            
            end
        end
        
        function plot(theSeisObj_full,varargin)
            if strcmp(varargin,'picks')
                figure;
                plot(theSeisObj_full.Pick_loc,theSeisObj_full.Pick_time,'bo')
                xlabel('Geophone location')
                ylabel('Pick times (ms)')
                title(['First Arrival Picks for Record #', ...
                    num2str(theSeisObj_full.LineNumber)], 'FontWeight','bold');
            end
                      
        end
        
    end

end
