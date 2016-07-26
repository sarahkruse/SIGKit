function varargout = DippingInterfaceGUI(varargin)
% DIPPINGINTERFACEGUI MATLAB code for DippingInterfaceGUI.fig
%      DIPPINGINTERFACEGUI, by itself, creates a new DIPPINGINTERFACEGUI or raises the existing
%      singleton*.
%
%      H = DIPPINGINTERFACEGUI returns the handle to a new DIPPINGINTERFACEGUI or the handle to
%      the existing singleton*.
%
%      DIPPINGINTERFACEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIPPINGINTERFACEGUI.M with the given input arguments.
%
%      DIPPINGINTERFACEGUI('Property','Value',...) creates a new DIPPINGINTERFACEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DippingInterfaceGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DippingInterfaceGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DippingInterfaceGUI

% Last Modified by GUIDE v2.5 12-Jul-2016 12:07:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DippingInterfaceGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DippingInterfaceGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



%**************************************************************************
%****************** SETUP *************************************************
%**************************************************************************

% --- Executes just before DippingInterfaceGUI is made visible.
function DippingInterfaceGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DippingInterfaceGUI (see VARARGIN)

% Choose default command line output for DippingInterfaceGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

seismicsGUIdata = guidata(seismicsGUI);
handles.objFwd = seismicsGUIdata.objFilenameFwd;
fs = filesep;
filepath = pwd;    
fileNameFwd = strcat([filepath fs 'Seismics' fs 'Processed_files' fs num2str(handles.objFwd.FileNumber) ,'_picks.mat']);
handles.objRvs = seismicsGUIdata.objFilenameRvs;
fileNameRvs = strcat([filepath fs 'Seismics' fs 'Processed_files' fs num2str(handles.objRvs.FileNumber) ,'_picks.mat']);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using DippingInterfaceGUI.

%first input parameter = file name containing picks arrays in x, t format
%second input parameter = shot location
handles.Pforward = PicksObj(fileNameFwd,handles.objFwd.ShotXProf);
handles.Preverse = PicksObj(fileNameRvs,handles.objRvs.ShotXProf);


% INITIALIZE FORWARD AND REVERSE PLOTS ***********************************
% find common axis limits for forward and reverse
handles.xmin = handles.Pforward.ShotXProf;
handles.xmax = handles.Preverse.ShotXProf;

% forward plot
axes(handles.ForwardPlot) 
PlotPicksWithShot(handles.Pforward,'Forward Shot');
xlim([handles.xmin-1 handles.xmax+1]);

% reverse plot
axes(handles.ReversePlot) 
PlotPicksWithShot(handles.Preverse,'Reverse Shot');
xlim([handles.xmin-1 handles.xmax+1]);

% SET PARAMETERS FOR STRUCTURE PLOT ***************************************
handles.vplotmin = 0; handles.vplotmax = 2500; %m/s
handles.VertExag = 3;
colormap(jet);


% INITIATE SLIDER RANGES AND VALUES ***************************************
    set(handles.ForwardSlider,'Min',handles.xmin);
    set(handles.ForwardSlider,'Max',handles.xmax);
    set(handles.ReverseSlider,'Min',handles.xmin);
    set(handles.ReverseSlider,'Max',handles.xmax);
    handles.ForwardXCrossover = (handles.xmin+handles.xmax)/2;
    handles.ReverseXCrossover = (handles.xmin+handles.xmax)/2;
    set(handles.ForwardSlider,'Value',handles.ForwardXCrossover);
    set(handles.ReverseSlider,'Value',handles.ReverseXCrossover);
    set(handles.ForwardSlider,'Visible','on');
    set(handles.ReverseSlider,'Visible','on');
    SliderCaption = sprintf('%.2f', handles.ForwardXCrossover);
    set(handles.ForwardSliderValueLabel,'String',...
        ['Set crossover position ' SliderCaption ' m']);
    set(handles.ReverseSliderValueLabel,'String',...
        ['Set crossover position ' SliderCaption ' m']);
    set(handles.ForwardSliderValueLabel,'Visible','on');
    set(handles.ReverseSliderValueLabel,'Visible','on');
    set(handles.VReverse1Label,'Visible','off');
    set(handles.VReverse2Label,'Visible','off');
    set(handles.TiForwardLabel,'Visible','off');
    set(handles.TiReverseLabel,'Visible','off');
    set(handles.ComputeStructureButton,'Visible','off');
    set(handles.SaveToFileButton,'Visible','off');
    set(handles.StructurePlot,'Visible','off');
    set(handles.StructurePanel,'Visible','off');
    set(handles.V1Label,'Visible','off');
    set(handles.V2Label,'Visible','off');
    set(handles.dForwardLabel,'Visible','off');
    set(handles.dReverseLabel,'Visible','off');
    set(handles.DipAngleLabel,'Visible','off');

% CREATE AND SET FLAGS ****************************************************
handles.isForwardDirect = 0; handles.isReverseDirect = 0;
handles.isForwardRefract = 0; handles.isReverseRefract = 0; 
handles.isStructurePlot = 0;

guidata(hObject, handles);  % END OPENING



%**************************************************************************
%************* FORWARD SHOT ANALYSIS - FORWARD SLIDER *********************
%**************************************************************************

% --- Executes on Forward Slider movement.
function ForwardSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ForwardSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if previous lines exist, delete them
if handles.isForwardDirect == 1
    delete(handles.hForwardDirectLine);
end
if handles.isForwardRefract == 1
    delete(handles.hForwardRefractLine);
    delete(handles.hForwardRefractLine2);
end

%---USER SETS CROSSOVER POSITION
handles.ForwardXCrossover = get(hObject,'Value');
ForwardSliderCaption = sprintf('%.2f', handles.ForwardXCrossover);
set(handles.ForwardSliderValueLabel,'String',...
    ['Set crossover position ' ForwardSliderCaption ' m']);
set(handles.ForwardSliderValueLabel,'Visible','on');

%---BEST-FITTING LINES TO DIRECT AND REFRACTED ARRIVALS PLOTTED
%   VELOCITIES COMPUTED

%For forward shot DIRECT picks are to left of ForwardXCrossover
inddir = find(handles.Pforward.RecXProf < handles.ForwardXCrossover);
if length(inddir) > 0
    handles.isForwardDirect = 1;
    x1 = handles.Pforward.RecXProf(inddir);
    t1 = handles.Pforward.PickTime(inddir);
    % fit line to points, including the origin
    xfit = [handles.Pforward.ShotXProf, x1];
    tfit = [0; t1];
    p = polyfit(xfit,(tfit)',1);
    slopeForwardDirect = p(1);
    interForwardDirect = p(2);
    handles.VForward1= 1/p(1)*1000; %convert to m/s

    % plot best fitting direct line, end where it crosses x axis
    xline(1) = -interForwardDirect/slopeForwardDirect;
    xline(2) = max(x1);
    tline(1) = 0;
    tline(2) = xline(2)*slopeForwardDirect+interForwardDirect;
    handles.hForwardDirectLine = plot(handles.ForwardPlot,...
                                      xline, tline, 'b');
                                  
    % label velocity
    set(handles.VForward1Label,'Visible','on');
    caption = sprintf('%.0f', handles.VForward1);
        set(handles.VForward1Label,'String',...
            ['v1f = 1/slope = ' caption ' m/s']);    

end

%For forward shot REFRACTED picks are to right of ForwardXCrossover
indref = find(handles.Pforward.RecXProf >= handles.ForwardXCrossover);
if length(indref) > 0
    handles.isForwardRefract = 1;
    xfit = handles.Pforward.RecXProf(indref);
    tfit = handles.Pforward.PickTime(indref);
    % fit line to points
    p = polyfit(xfit,(tfit)',1);
    handles.slopeForwardRefract = p(1);
    handles.interForwardRefract= p(2);
    handles.VForward2 = 1/p(1)*1000; %convert to m/s

    % plot best fitting refracted line
    xline(1) = min(xfit);
    xline(2) = max(xfit);
    tline = xline*handles.slopeForwardRefract+handles.interForwardRefract;
    handles.hForwardRefractLine = plot(handles.ForwardPlot,...
                                      xline, tline, 'r');
                                  
    % plot dashed continuation to shot location, get intercept time
    xline(1) = handles.xmin; % =shot location
    xline(2) = min(xfit);
    tline = xline*handles.slopeForwardRefract+handles.interForwardRefract;
    handles.hForwardRefractLine2 = plot(handles.ForwardPlot,...
                                      xline, tline, '--r');
    handles.TiForward = tline(1);
                                  
    % label velocity
    set(handles.VForward2Label,'Visible','on');
    caption = sprintf('%.0f', handles.VForward2);
        set(handles.VForward2Label,'String',...
            ['v2f = 1/slope = ' caption ' m/s']);  
    % label intercept time
    set(handles.TiForwardLabel,'Visible','on');
    caption = sprintf('%.1f', handles.TiForward);
        set(handles.TiForwardLabel,'String',...
            ['tif = ' caption ' ms']);  

                                  
 
end

%show compute structure button if sufficient info to compute structure
if (handles.isForwardDirect == 1 & handles.isForwardRefract == 1 &...
    handles.isReverseDirect == 1 & handles.isReverseRefract == 1)
    set(handles.ComputeStructureButton,'Visible','on');
end
guidata(hObject, handles);
% END FORWARD SLIDER MOVE, LINE PLOT, VELOCITY CALCULATION



%**************************************************************************
%************* REVERSE SHOT ANALYSIS - REVERSE SLIDER *********************
%**************************************************************************

% --- Executes on Reverse Slider movement.
function ReverseSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ReverseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if previous lines exist, delete them
if handles.isReverseDirect == 1
    delete(handles.hReverseDirectLine);
end
if handles.isReverseRefract == 1
    delete(handles.hReverseRefractLine);
    delete(handles.hReverseRefractLine2);
end

%---USER SETS CROSSOVER POSITION
handles.ReverseXCrossover = get(hObject,'Value');
ReverseSliderCaption = sprintf('%.2f', handles.ReverseXCrossover);
set(handles.ReverseSliderValueLabel,'String',...
    ['Set crossover position ' ReverseSliderCaption ' m']);
set(handles.ReverseSliderValueLabel,'Visible','on');

%---BEST-FITTING LINES TO DIRECT AND REFRACTED ARRIVALS PLOTTED
%   VELOCITIES COMPUTED

%For reverse shot DIRECT picks are to right of ReverseXCrossover
inddir = find(handles.Preverse.RecXProf > handles.ReverseXCrossover);
if length(inddir) > 0
    handles.isReverseDirect = 1;
    x1 = handles.Preverse.RecXProf(inddir);
    t1 = handles.Preverse.PickTime(inddir);
    % fit line to points, including the origin
    xfit = [handles.Preverse.ShotXProf, x1];
    tfit = [0; t1];
    p = polyfit(xfit,(tfit)',1);
    slopeReverseDirect = p(1);
    interReverseDirect = p(2);
    handles.VReverse1= -1/p(1)*1000; %convert to m/s

    % plot best fitting direct line, end where it crosses x axis
    xline(1) = -interReverseDirect/slopeReverseDirect;
    xline(2) = min(x1);
    tline(1) = 0;
    tline(2) = xline(2)*slopeReverseDirect+interReverseDirect;
    handles.hReverseDirectLine = plot(handles.ReversePlot,...
                                      xline, tline, 'b');
                                  
    % label velocity
    set(handles.VReverse1Label,'Visible','on');
    caption = sprintf('%.0f', handles.VReverse1);
        set(handles.VReverse1Label,'String',...
            ['v1r = 1/slope = ' caption ' m/s']);    

end

%For reverse shot REFRACTED picks are to left of ReverseXCrossover
indref = find(handles.Preverse.RecXProf <= handles.ReverseXCrossover);
if length(indref) > 0
    handles.isReverseRefract = 1;
    xfit = handles.Preverse.RecXProf(indref);
    tfit = handles.Preverse.PickTime(indref);
    % fit line to points
    p = polyfit(xfit,(tfit)',1);
    handles.slopeReverseRefract = p(1); 
    handles.interReverseRefract= p(2);
    handles.VReverse2 = -1/p(1)*1000; %convert to m/s

    % plot best fitting refracted line
    xline(1) = min(xfit);
    xline(2) = max(xfit);
    tline = xline*handles.slopeReverseRefract+handles.interReverseRefract;
    handles.hReverseRefractLine = plot(handles.ReversePlot,...
                                      xline, tline, 'r');
                                  
    % plot dashed continuation to shot location, get intercept time
    xline(1) = max(xfit); 
    xline(2) = handles.xmax; % =shot location
    tline = xline*handles.slopeReverseRefract+handles.interReverseRefract;
    handles.hReverseRefractLine2 = plot(handles.ReversePlot,...
                                      xline, tline, '--r');
    handles.TiReverse = tline(2);
                                                              
    % label velocity
    set(handles.VReverse2Label,'Visible','on');
    caption = sprintf('%.0f', handles.VReverse2);
        set(handles.VReverse2Label,'String',...
            ['v2r = 1/slope = ' caption ' m/s']);  
    % label intercept time
    set(handles.TiReverseLabel,'Visible','on');
    caption = sprintf('%.1f', handles.TiReverse);
        set(handles.TiReverseLabel,'String',...
            ['tir = ' caption ' ms']);  
end
%show compute structure button if sufficient info to compute structure
if (handles.isForwardDirect == 1 & handles.isForwardRefract == 1 &...
    handles.isReverseDirect == 1 & handles.isReverseRefract == 1)
    set(handles.ComputeStructureButton,'Visible','on');
end
guidata(hObject, handles);
% END REVERSE SLIDER MOVE, LINE PLOT, VELOCITY CALCULATION



%**************************************************************************
%************* COMPUTE STRUCTURE - PUSHBUTTON******************************
%**************************************************************************

% --- Executes on button press in ComputeStructureButton.
function ComputeStructureButton_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeStructureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if pre-existing plot is there, delete it
if (handles.isStructurePlot == 1)
    delete(handles.hV1Patch);
    delete(handles.hV2Patch);
end
handles.isStructurePlot = 1;


% average v1
handles.V1 = (handles.VForward1+handles.VReverse1)/2;
% dip angle - convert slopes to s/m; convert reverse slope to positive
% Burger et al. p. 99
handles.beta = (asin(handles.V1*handles.slopeForwardRefract/1000.) - ...
                asin(handles.V1*handles.slopeReverseRefract/-1000.))/2;

% note in this formulation beta is positive if forward is the Downdip shot
% (unlike figure 3.19 in Burger)
handles.betadeg = handles.beta*180/pi;
% critical angle
thetaic = (asin(handles.V1*handles.slopeForwardRefract/1000.) + ...
                asin(handles.V1*handles.slopeReverseRefract/-1000.))/2;
handles.V2 = handles.V1/sin(thetaic);
    
handles.dForward = handles.TiForward/1000.*handles.V1/...
                   (2*cos(thetaic)*cos(handles.beta));
               
handles.dReverse = handles.TiReverse/1000.*handles.V1/...
                   (2*cos(thetaic)*cos(handles.beta));
               
% create structure plot
set(handles.StructurePlot,'Visible','on');
axes(handles.StructurePlot);

% plot upper layer V1
XV1Patch = [handles.xmin handles.xmax handles.xmax...
                    handles.xmin];
YV1Patch = [0 0 -handles.dReverse -handles.dForward];
handles.hV1Patch = patch(XV1Patch, YV1Patch,handles.V1,'EdgeColor','none');
hold on;
% plot lower layer V2
ymin = -max([handles.dForward handles.dReverse])-3; 
XV2Patch = [handles.xmin handles.xmax handles.xmax...
                    handles.xmin];
YV2Patch = [-handles.dForward -handles.dReverse  ymin+0.5 ymin+0.5];
handles.hV2Patch = patch(XV2Patch, YV2Patch,handles.V2,'EdgeColor','none');
% add shot locations
plot([handles.xmin handles.xmax],[0 0],'rx');
% add receiver locations
plot(handles.Pforward.RecXProf,zeros(length(handles.Pforward.RecXProf)),'.k');
% in case there are picks on reverse shot that weren't on forward shot,
%   plot these also
plot(handles.Preverse.RecXProf,zeros(length(handles.Preverse.RecXProf)),'.k');
% other controls on structure plot
xlim([handles.xmin-1 handles.xmax+1]);
ylim([ymin 1]);
caxis([handles.vplotmin handles.vplotmax]);
ylabel('depth (m)'); xlabel('distance(m)');
hcb = colorbar;
title(hcb,'velocity (m/s)');


% write out structure parameters
set(handles.StructurePanel,'Visible','on');
set(handles.V1Label,'Visible','on');
    caption = sprintf('%.0f', handles.V1);
    set(handles.V1Label,'String',['v1ave = ' caption ' m/s']);  
set(handles.V2Label,'Visible','on');
    caption = sprintf('%.0f', handles.V2);
    set(handles.V2Label,'String',['v2 = ' caption ' m/s']);
set(handles.dForwardLabel,'Visible','on');
    caption1 = sprintf('%.1f', handles.dForward);
    caption2 = sprintf('%.1f', handles.xmin);
    set(handles.dForwardLabel,'String',...
        ['dforward = ' caption1 ' m (at x=' caption2 'm)']);  
set(handles.dReverseLabel,'Visible','on');
    caption1 = sprintf('%.1f', handles.dReverse);
    caption2 = sprintf('%.1f', handles.xmax);
    set(handles.dReverseLabel,'String',...
        ['dreverse = ' caption1 ' m (at x=' caption2 'm)']);
set(handles.DipAngleLabel,'Visible','on');
    caption = sprintf('%.1f', handles.betadeg);
    set(handles.DipAngleLabel,'String',['dip angle = ' caption ' deg']); 
    
set(handles.SaveToFileButton,'Visible','on');

% handles.txt , A for saving structure information on save button in a txt file
A = {'v1ave = ','v2 = ','dforward at x = ',...
    'dreverse at x = ','dip angle = '...
    ;sprintf('%.0f', handles.V1),sprintf('%.0f', handles.V2),strcat(sprintf('%.1f', handles.dForward),' ' ,' at ' , ' ' ,sprintf('%.1f', handles.xmin)),...
    strcat(sprintf('%.1f', handles.dReverse),' ' ,' at ' , ' ', sprintf('%.1f', handles.xmax)), sprintf('%.1f', handles.betadeg)}';
handles.txt = A;

guidata(hObject, handles); % END STRUCTURE PLOT PUSHBUTTON

%**************************************************************************
%************* SAVE STRUCTURE PARAMETERS TO FILE - PUSHBUTTON******************************
%**************************************************************************

% --- Executes on button press in SaveToFileButton.
function SaveToFileButton_Callback(hObject, eventdata, handles)

fs = filesep;
filepath = pwd;
Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
%test the existence of a Processed files directory for saving the file.
%If the directory does not exist, make one then save the files to it.
if exist(Savepath,'dir')

    Filenametxt = [Savepath,fs,num2str(handles.objFwd.FileNumber),'_',num2str(handles.objRvs.FileNumber),'_Structure_Parameters.txt'];
    
    Filenamepng = [Savepath,fs,num2str(handles.objFwd.FileNumber),'_',num2str(handles.objRvs.FileNumber),'_Velocity_structure.png'];
    
    print(gcf,'-dpng','-r300',Filenamepng)
    fileID = fopen(Filenametxt,'w');
    for i=1:length(handles.txt)
        formatSpec = strcat('%s \t %s \r\n');
        fprintf(fileID,formatSpec,handles.txt{i,:});
    end
    fclose(fileID);
   
else
    mkdir (Savepath)
    
    Filenametxt = [Savepath,fs,num2str(handles.objFwd.FileNumber),'_',num2str(handles.objRvs.FileNumber),'_Structure_Parameters.txt'];
    
    Filenamepng = [Savepath,fs,num2str(handles.objFwd.FileNumber),'_',num2str(handles.objRvs.FileNumber),'_Velocity_structure.png'];
    
    print(gcf,'-dpng','-r300',Filenamepng)
    fileID = fopen(Filenametxt,'w');
    for i=1:length(handles.txt)
        formatSpec = strcat('%s \t %s \r\n');
        fprintf(fileID,formatSpec,handles.txt{i,:});
    end
    fclose(fileID);
    
end
msgbox({('Your files has been saved in this directory successfully : '),Savepath})


% --- Outputs from this function are returned to the command line.
function varargout = DippingInterfaceGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





%**************************************************************************
%************** GUI OBJECT CREATIONS **************************************
%**************************************************************************

% --- Executes during object creation, after setting all properties.
function ComputeStructureButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComputeStructureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during Forward Slider creation, after setting all properties.
function ForwardSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ForwardSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function ReverseSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReverseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%Static Text

function ForwardSliderValueLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ForwardSliderValueLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function VForward1Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VForward1Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function TiForwardLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TiForwardLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function StructurePlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StructurePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate StructurePlot


% --- Executes during object creation, after setting all properties.
function StructurePanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StructurePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function V2Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V2Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function dForwardLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dForwardLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function dReverseLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dReverseLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function DipAngleLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DipAngleLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function V1Label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V1Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
