classdef Magobj
    %Mabobj is an object to contain the pertinent data and methods for
    %processing magnetic field observation
    %
    % Public fields are Lon, Lat, Magnetic observation, observation time
    % and elevation. Mean magnetic field reading and magnetic anomaly are
    % dependent properties of the magnetic object that are calculated when
    % a new object is created.
    %
    % When creating a new magnetic object, the first argument should be the
    % mode that will be used to create the object. Current modes enabled
    % are Manual/manual and Mag858 with GPS file DG100
    %
    % M = Magobj(Lon,Lat,MagObs,Time); 
    % fills the public fields of the magnetic object M and calculates the
    % MagAn and MagMean based on these values
    %
    % If Mode is Mag858 and the GPS data was recorded on DG100, then a mag
    % object can be built using this line.
    %
    % M = Magobj('Mag858','03262014b.stn','DG100','03262014b.txt')
    % 
    % There are three data plotting options currently available:
    %
    % plot(M,'scatter') or M.plot('scatter') will create an X,Y plot of the
    % magnetic data colored by the magnitude of the magnetic anomaly.
    %
    % plot(M,'grid') or M.plot('grid') creates a gridded surface plot of the
    % magnetic data
    %
    % plot(M,'time') or M.plot('time') creates a time, magnetic anomaly
    % plot.
    
    
    properties
        Lon
        Lat
        Magobs
        Time
        Elev
    end
    
    properties(Dependent)
        Mmag
        MagAn
    end
    
    methods
        %define the method for building the class; the first option should
        %be the mode to build the cut
        function newMagobj = Magobj(varargin)
            Mode = varargin{1};
            
            if strcmp(Mode,'Manual') || strcmp(Mode,'manual');
                newMagobj.Lon    = varargin{2};
                newMagobj.Lat  = varargin{3};
                newMagobj.Magobs = varargin{4};
                newMagobj.Time = varargin{5};
               
            elseif strcmp(Mode,'Mag858') && strcmp(varargin{3},'DG100')
                magfile = varargin{2};
                gpsfile = varargin{4};
                
                disp('Now reading magnetic data file ...'); 
                [Mag,Mtime] = readmag858(magfile);
                
                disp('Now reading GPS data file ...'); 
                [lon,lat,Gtime,elev] = readgpsDG100(gpsfile);
                
                disp('Now doing time-step match between GPS and Magnetic data ...'); 
                [k,Mt] = GPS2MagMatch(Gtime,Mtime);
                %add the matched GPS  and Magnetic data to the magnetic
                %object
                newMagobj.Lon    = lon(k);
                newMagobj.Lat  = lat(k)  ;
                newMagobj.Elev  = elev(k)  ;
                newMagobj.Magobs = Mag(Mt);
                newMagobj.Time = Mtime(Mt);
                
            end
        end
        
        %     Calculate the mean Magnetic observation
        function Mmag = get.Mmag(theMagobj)
            Mmag = mean(theMagobj.Magobs);
        end
        
        %      Use the mean magnetic observation to calculate a magnetic anomaly
        function MagAn = get.MagAn(theMagobj)
            MagAn = theMagobj.Magobs-theMagobj.Mmag;
        end
        
        function plot(theMagobj, varargin)
            if strcmp(varargin,'scatter')
                figure
                scatter(theMagobj.Lon, theMagobj.Lat, 20,theMagobj.MagAn,'filled')
                xlabel('Lon')
                ylabel('Lat')
                h = colorbar;
                ylabel(h,'Magnetic Anomaly (nT)')
                axis tight
                grid on
                
           elseif strcmp(varargin,'time')
               figure
               plot(theMagobj.Time,theMagobj.MagAn,'ko','MarkerFaceColor','k')
               datetick('x','keeplimits')
               xlabel('Time')
               ylabel('Magnetic Anomaly (nT)')
              
                
            elseif strcmp(varargin,'grid')
               
                colormap(jet);
                X = theMagobj.Lon;
                Y = theMagobj.Lat;
                
% %               create map limit vaiables
%                 latlim = [min(Y)+.05 max(Y)+0.05];
%                 lonlim = [min(X)+.05 max(X)+0.05];
%                 
%                 worldmap(latlim,lonlim);
%                 
                %create grid points that cover the limit of the data then
                %grid and plot the data
                x = linspace(min(X),max(X),300);
                y = linspace(min(Y),max(Y),300);
                [x,y] = meshgrid(x,y);
                zi = griddata(X,Y,theMagobj.MagAn,x,y);
                surface(x,y,zi);
                shading interp
%                 axis tight
                
%                 %control the number output format for the data.
                ax = gca;
                ax.XAxis.Exponent = 0;
                ax.XAxis.TickLabelFormat = '%d';
                ax.YAxis.Exponent = 0;
                ax.YAxis.TickLabelFormat = '%d';
                
                xlabel('Lon')
                ylabel('Lat')
                h = colorbar;
                ylabel(h, 'Magnetic Anomaly (nT)')
               
            end
        end
        
        
    end
    
end

