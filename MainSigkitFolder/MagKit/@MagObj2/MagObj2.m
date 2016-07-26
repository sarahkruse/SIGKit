classdef MagObj2
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       Easting
       Northing
       Fraw
       Gradient
       Time
    end
    
    methods        
        function this = MagObj2(varargin)
            
            Mode = varargin{1};
            datasets = varargin{2};
            
            if strcmp(Mode, 'MAG')
                
               Easting=[]; Northing=[]; Fraw=[]; Gradient=[]; Time=[];
                for N = (1:datasets)
                    filename = input('Enter individual filenames for each seperate file...    ','s');
                    [hour,Fr,Diff,W,Z]=GEM_read_g(filename);
                    %combine datasets;
                    this.Easting= vertcat(Easting,W);
                    this.Northing= vertcat(Northing,Z);
                    this.Fraw= vertcat(Fraw,([Fr]/1000));
                    this.Gradient= vertcat(Gradient,Diff);
                    this.Time= vertcat(Time,[hour]);
                end 
                
            elseif strcmp(Mode, 'Manual')
                this.Easting = varargin{2};
                this.Northing = varargin{3};
                this.Fraw = varargin{4};
%                 this.Diff = varargin{5};
                this.Time = varargin{5};
             
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
                this.Easting = lon(k);
                this.Northing = lat(k);
                %this.Elev = elev(k);
                this.Fraw = Mag(Mt);
                this.Time = Mtime(Mt);
            end
        end   
    end
    
    methods
        MFilt = FilterMag(this);
        fuc = upcont(this);
        fr2p = r2p(this);
        A = analytical_signal(this);
    end  
end
