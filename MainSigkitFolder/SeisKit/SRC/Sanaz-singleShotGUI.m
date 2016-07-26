function varargout = singleShotGUI(varargin)
%% SINGLESHOTGUI MATLAB code for singleShotGUI.fig
%      SINGLESHOTGUI, by itself, creates a new SINGLESHOTGUI or raises the existing
%      singleton*.
%
%      H = SINGLESHOTGUI returns the handle to a new SINGLESHOTGUI or the handle to
%      the existing singleton*.
%
%      SINGLESHOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLESHOTGUI.M with the given input
%      arguments.
%
%      SINGLESHOTGUI('Property','Value',...) creates a new SINGLESHOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before singleShotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to singleShotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help singleShotGUI

% Last Modified by GUIDE v2.5 06-Jul-2016 09:40:39
%%%%( on 6/29/2016): changed all x>>RecXProf  and t>>PickTime

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @singleShotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @singleShotGUI_OutputFcn, ...
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
%% End initialization code - DO NOT EDIT


%--- Executes just before singleShotGUI is made visible.
function singleShotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
%% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to singleShotGUI (see VARARGIN)

h = findobj('Tag','seismicsGUI');
 if isempty(h)
    msgbox('Error while loading')
 end
% get handles and other user-defined data associated to seismicsGUI
seismicsGUIdata = guidata(h);

% % % try
handles.obj = seismicsGUIdata.objFilename;
% % % catch
% % %     return;
% % % end

set(handles.txtLineNumber, 'String', num2str(handles.obj.FileNumber));

fs = filesep;
filepath = pwd;    
fileName = strcat([filepath fs 'Seismics' fs 'Processed_files' fs num2str(handles.obj.FileNumber) ,'_picks.mat']);


% % fileName = strcat(num2str(handles.obj.FileNumber) ,'_picks.mat');  
% % uiwait(msgbox({strcat('Processing line number  ' ,num2str(handles.obj.FileNumber), '...') ...
% %               strcat('Please input pick file( "', fileName , '" ), this is the pick file generated in previous step.')}));
% % 
% % [filenameInput,filepathInput]=uigetfile({'*.mat'},'Select File');
% % if filenameInput ~= fileName 
% %     uiwait(msgbox(strcat('" ', fileName, '" file should be selected!')));
% %     % if the user supplied 'exit' as an argument, save it in the handles
% %     % structure
% %     handles.closeFigure = true;
% %     handles.output = hObject;
% %     guidata(hObject, handles);
% %     return;
% % end
try     
    handles.TimePicks=load(fileName);
catch
    msgbox({'Can not find pick file in this directory',fileName});
end
handles.xmin = min(handles.TimePicks.RecXProf);
handles.xmax = max(handles.TimePicks.RecXProf);
% plot(handles.pick_plot,handles.TimePicks.RecXProf,handles.TimePicks.PickTime,'.k');
% xlabel('geophone position (m)');
% ylabel('first arrival time (ms)');
% hold on;
 
% not all of these are necessary here, but this serves as a list of the
% flags
handles.isShotSet = 0;
handles.doLinePlot = 0;
handles.isStructurePlot = 0;
handles.RefractLeftPanelOn = 0;  handles.RefractRightPanelOn = 0;
handles.isDirectLeft = 0;        handles.isDirectRight = 0;
handles.isRefractLeft = 0;       handles.isRefractRight = 0;
handles.isSlopeRefractLeft = 0;   handles.isSlopeRefractRight = 0;
handles.isLineDirectLeft = 0;    handles.isLineDirectRight = 0;
handles.isLineRefractLeft = 0;    handles.isLineRefractRight = 0;


% SET PARAMETERS FOR STRUCTURE PLOT ***********sanaz***********************
handles.vplotmin = 0; handles.vplotmax = 0; %m/s
handles.VertExag = 0;
colormap(jet);
%**********
set(handles.ComputeStructureButton,'Visible','off');
set(handles.SaveToFileButton,'Visible','off');
set(handles.StructurePlot,'Visible','off');
set(handles.StructurePanel,'Visible','off');
set(handles.VDirLabel,'Visible','off');
set(handles.VRefLabel,'Visible','off');



set(handles.refract_right_range,'Value',0)
set(handles.refract_left_range,'Value',0)

% get the shot location
% ******* handles.ShotLoc = str2double(get(hObject,'String')); %%%%%%sanaz
if ischar(handles.TimePicks.ShotXProf) == 1
    handles.ShotLoc = str2double(handles.TimePicks.ShotXProf); 
else
    handles.ShotLoc = handles.TimePicks.ShotXProf;
end
handles.isShotSet = 1;


plot(handles.pick_plot,handles.TimePicks.RecXProf,handles.TimePicks.PickTime,'.k');
xlabel('geophone position (m)');
ylabel('first arrival time (ms)');
hold on;

%plot the shot
handles.hShot = plot(handles.pick_plot,handles.ShotLoc,0,'xr','MarkerSize',30);hold on;


% make line plot toggle button visible
set(handles.toggle_line_fit,'Visible','on');


% --- find and assign picks to left of shot ---------------------------
indleft = find(handles.TimePicks.RecXProf < handles.ShotLoc);
% if refract pick panel was previously plotted, it may need to be removed
if (handles.RefractLeftPanelOn == 1 && length(indleft) < 1)
        set(handles.left_panel,'Visible','off');
        set(handles.label_direct_left,'Visible','off');
        set(handles.label_refract_left,'Visible','off');
end
if length(indleft) > 0

    handles.isDirectLeft = 1;  
    % all picks to left
    handles.xLeft = (handles.TimePicks.RecXProf(indleft))';
    handles.tLeft = handles.TimePicks.PickTime(indleft); 
    % initially assign all as direct arrivals
    handles.xDirectLeft = (handles.TimePicks.RecXProf(indleft))';
    handles.tDirectLeft = handles.TimePicks.PickTime(indleft);
    plot(handles.pick_plot,handles.xDirectLeft,handles.tDirectLeft,'*b');hold on;
    % turn label on
    set(handles.label_direct_left,'Visible','on');
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectLeft];
    tfit = [0; handles.tDirectLeft];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectLeft = p(1);
    handles.interDirectLeft = p(2);
    handles.vDirectLeft = -1/p(1)*1000; %convert to m/s
    % optional line plot
    if (handles.doLinePlot == 1)  
        handles.isLineDirectLeft = 1;
        xl(1) = min(handles.xDirectLeft); 
        % end where line crosses x axis
        xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
        tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
        tl(2) = 0;
        handles.hLineDirectLeft = plot(handles.pick_plot,xl,tl,'b'); hold on;      
    end
    
    %query for refraction picks to the left
    handles.RefractLeftPanelOn = 1;
    set(handles.left_panel,'Visible','on');
    set(handles.refract_left_range,'Enable','on');
    sliderminL = min(handles.TimePicks.RecXProf)-1;
    slidermaxL = handles.ShotLoc-0.05;
    startvalueL = sliderminL +(slidermaxL-sliderminL)*.9;
    caption_left = sprintf('%.2f', startvalueL);
    set(handles.refract_left_range,'Min',sliderminL);
    set(handles.refract_left_range,'Max',slidermaxL);
    set(handles.refract_left_range,'Value',startvalueL);
    set(handles.refract_left_range,'Visible','on');
    % set(handles.slider_value_refracted_right,'String', caption_right);
    % caption_right = sprintf('%.2f', handles.xMinRefractRight);
    set(handles.slider_value_refracted_left,'String',...
        ['Geophones before ' caption_left ' m']);
    set(handles.slider_value_refracted_left,'Visible','on');
    set(handles.left_slider_label_part_2,'Visible','on');
else
    handles.isDirectLeft = 0;
end

% --- find and assign picks to right of shot  --------------------------
indright = find(handles.TimePicks.RecXProf > handles.ShotLoc);
% if refract pick panel was previously plotted, it may need to be removed
if (handles.RefractRightPanelOn == 1 && length(indright) < 1)
        set(handles.right_panel,'Visible','off');
        set(handles.label_direct_right,'Visible','off'); 
        set(handles.label_refract_right,'Visible','off');
end
 
if length(indright) > 0    
    handles.isDirectRight = 1;
    % all picks to right
    handles.xRight = (handles.TimePicks.RecXProf(indright))';
    handles.tRight = handles.TimePicks.PickTime(indright); 
    % initially assign all as direct arrivals
    handles.xDirectRight = (handles.TimePicks.RecXProf(indright))';
    handles.tDirectRight = handles.TimePicks.PickTime(indright);
    plot(handles.pick_plot,handles.xDirectRight,handles.tDirectRight,'*g');hold on;
    % turn label on
    set(handles.label_direct_right,'Visible','on');
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectRight];
    tfit = [0; handles.tDirectRight];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectRight = p(1);
    handles.interDirectRight = p(2);
    handles.vDirectRight = 1/p(1)*1000; %convert to m/s
    % optional line plot
    if (handles.doLinePlot == 1)  
        handles.isLineDirectRight = 1;
        % start just before first pick
        xl(1) = -handles.interDirectRight/handles.slopeDirectRight; 
        % end where line crosses x axis
        xl(2) = max(handles.xDirectRight); 
        tl(1) = 0;
        tl(2) = handles.slopeDirectRight*xl(2)+handles.interDirectRight;
        handles.hLineDirectRight = plot(handles.pick_plot,xl,tl,'g');  hold on;    
    end

    %query for refraction picks to the right
    handles.RefractRightPanelOn = 1;
    set(handles.right_panel,'Visible','on');
    set(handles.refract_right_range,'Enable','on');
    sliderminR = handles.ShotLoc+0.05;
    slidermaxR = max(handles.TimePicks.RecXProf)+1;
    startvalueR = sliderminR +(slidermaxR-sliderminR)/10;
    caption_right = sprintf('%.2f', startvalueR);
    set(handles.refract_right_range,'Min',sliderminR);
    set(handles.refract_right_range,'Max',slidermaxR);
    set(handles.refract_right_range,'Value',startvalueR);
    set(handles.refract_right_range,'Visible','on');
    % set(handles.slider_value_refracted_right,'String', caption_right);
    % caption_right = sprintf('%.2f', handles.RecXProfMinRefractRight);
    set(handles.slider_value_refracted_right,'String',...
        ['Geophones past ' caption_right ' m']);
    set(handles.slider_value_refracted_right,'Visible','on');
    set(handles.right_slider_label_part_2,'Visible','on');
else
    handles.isDirectRight = 0;
end

%*************************************************************************


% Choose default command line output for singleShotGUI
% % % close seismicsGUI
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);  % END OPENING

% UIWAIT makes singleShotGUI wait for user response (see UIRESUME)
%% uiwait(handles.singleShotGUI);


% --- Outputs from this function are returned to the command line.
function varargout = singleShotGUI_OutputFcn(hObject, eventdata, handles) 
%% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if the user suppled an 'exit' argument, close the figure by calling
% figure's CloseRequestFcn
if (isfield(handles,'closeFigure') && handles.closeFigure)
      singleShotGUI_CloseRequestFcn(hObject, eventdata, handles)
end

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
%% ******************************from here***comment for now,invisible, on
%6/30/2016 sanaz
% --- BUTTON TO OPEN INPUT FILE AND PLOT PICKS ----------------------------
% % function pushbutton_open_file_Callback(hObject, eventdata, handles)
% % %% hObject    handle to pushbutton_open_file (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % let user select file and read in the data, assumes there are equally
% % % sized arrays x and t
% % [filename1,filepath1]=uigetfile({'*.*','All Files'},...
% %   'Select Time Picks File');
% %  handles.TimePicks=load([filepath1 filename1])';
% %  plot(handles.pick_plot,handles.TimePicks.RecXProf,handles.TimePicks.PickTime,'.k');
% %  xlabel('geophone position (m)');
% %  ylabel('first arrival time (ms)');
% % 
% %  % Save the handles structure.
% %  guidata(hObject, handles);  % END OPEN INPUT FILE
% % 

% % % --- ENTER SHOT POINT LOCATION AND MAKE PICK ASSIGNMENTS---------------
% % function enter_shot_location_Callback(hObject, eventdata, handles)
% % %% hObject    handle to enter_shot_location (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % 
% % % Hints: get(hObject,'String') returns contents of enter_shot_location as text
% % %        str2double(get(hObject,'String')) returns contents of enter_shot_location as a double
% % 
% % % if shot was previously set to another value, need to delete the previous
% % % marker
% % if handles.isShotSet == 1
% %     delete(handles.hShot);
% %     % delete any previously drawn slopes
% %     if handles.doLinePlot == 1 &&  handles.isDirectLeft == 1
% %         delete(handles.hLineDirectLeft);
% %     end        
% % end
% % 
% % % get the shot location
% % handles.ShotLoc = str2double(get(hObject,'String')); 
% % handles.isShotSet = 1;
% % 
% % %plot the shot
% % handles.hShot = plot(handles.pick_plot,handles.ShotLoc,0,'xr','MarkerSize',30);
% % 
% % % assign all picks to direct wave to start
% % handles.isDirectLeft = 0; 
% % handles.isDirectRight = 0; 
% % handles.isRefractLeft = 0; handles.isSlopeRefractLeft = 0;
% % handles.isRefractRight = 0; handles.isSlopeRefractRight = 0;
% % 
% % % make line plot toggle button visible
% % set(handles.toggle_line_fit,'Visible','on');
% % 
% % 
% % % --- find and assign picks to left of shot ---------------------------
% % indleft = find(handles.TimePicks.RecXProf < handles.ShotLoc);
% % % if refract pick panel was previously plotted, it may need to be removed
% % if (handles.RefractLeftPanelOn == 1 && length(indleft) < 1)
% %         set(handles.left_panel,'Visible','off');
% %         set(handles.label_direct_left,'Visible','off');
% %         set(handles.label_refract_left,'Visible','off');
% % end
% % if length(indleft) > 0
% %     handles.isDirectLeft = 1;  
% %     % all picks to left
% %     handles.xLeft = handles.TimePicks.RecXProf(indleft);
% %     handles.tLeft = handles.TimePicks.PickTime(indleft); 
% %     % initially assign all as direct arrivals
% %     handles.xDirectLeft = handles.TimePicks.RecXProf(indleft);
% %     handles.tDirectLeft = handles.TimePicks.PickTime(indleft);
% %     plot(handles.pick_plot,handles.xDirectLeft,handles.tDirectLeft,'*b');
% %     % turn label on
% %     set(handles.label_direct_left,'Visible','on');
% %     
% %     % fit line to points, including the origin
% %     xfit = [handles.ShotLoc; handles.xDirectLeft];
% %     tfit = [0; handles.tDirectLeft];
% %     p = polyfit(xfit,tfit,1);
% %     handles.slopeDirectLeft = p(1);
% %     handles.interDirectLeft = p(2);
% %     handles.vDirectLeft = -1/p(1)*1000; %convert to m/s
% %     % optional line plot
% %     if (handles.doLinePlot == 1)  
% %         handles.isLineDirectLeft = 1;
% %         xl(1) = min(handles.xDirectLeft); 
% %         % end where line crosses x axis
% %         xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
% %         tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
% %         tl(2) = 0;
% %         handles.hLineDirectLeft = plot(handles.pick_plot,xl,tl,'b');       
% %     end
% %     
% %     %query for refraction picks to the left
% %     handles.RefractLeftPanelOn = 1;
% %     set(handles.left_panel,'Visible','on');
% %     sliderminL = min(handles.TimePicks.RecXProf)-1;
% %     slidermaxL = handles.ShotLoc-0.05;
% %     startvalueL = sliderminL +(slidermaxL-sliderminL)*.9;
% %     caption_left = sprintf('%.2f', startvalueL);
% %     set(handles.refract_left_range,'Min',sliderminL);
% %     set(handles.refract_left_range,'Max',slidermaxL);
% %     set(handles.refract_left_range,'Value',startvalueL);
% %     set(handles.refract_left_range,'Visible','on');
% %     % set(handles.slider_value_refracted_right,'String', caption_right);
% %     % caption_right = sprintf('%.2f', handles.xMinRefractRight);
% %     set(handles.slider_value_refracted_left,'String',...
% %         ['Geophones before ' caption_left ' m']);
% %     set(handles.slider_value_refracted_left,'Visible','on');
% %     set(handles.left_slider_label_part_2,'Visible','on');
% % else
% %     handles.isDirectLeft = 0;
% % end
% % 
% % % --- find and assign picks to right of shot  --------------------------
% % indright = find(handles.TimePicks.RecXProf > handles.ShotLoc);
% % % if refract pick panel was previously plotted, it may need to be removed
% % if (handles.RefractRightPanelOn == 1 && length(indright) < 1)
% %         set(handles.right_panel,'Visible','off');
% %         set(handles.label_direct_right,'Visible','off'); 
% %         set(handles.label_refract_right,'Visible','off');
% % end
% %  
% % if length(indright) > 0    
% %     handles.isDirectRight = 1;
% %     % all picks to right
% %     handles.xRight = handles.TimePicks.RecXProf(indright);
% %     handles.tRight = handles.TimePicks.PickTime(indright); 
% %     % initially assign all as direct arrivals
% %     handles.xDirectRight = handles.TimePicks.RecXProf(indright);
% %     handles.tDirectRight = handles.TimePicks.PickTime(indright);
% %     plot(handles.pick_plot,handles.xDirectRight,handles.tDirectRight,'*g');
% %     % turn label on
% %     set(handles.label_direct_right,'Visible','on');
% %     
% %     % fit line to points, including the origin
% %     xfit = [handles.ShotLoc; handles.xDirectRight];
% %     tfit = [0; handles.tDirectRight];
% %     p = polyfit(xfit,tfit,1);
% %     handles.slopeDirectRight = p(1);
% %     handles.interDirectRight = p(2);
% %     handles.vDirectRight = 1/p(1)*1000; %convert to m/s
% %     % optional line plot
% %     if (handles.doLinePlot == 1)  
% %         handles.isLineDirectRight = 1;
% %         % start just before first pick
% %         xl(1) = -handles.interDirectRight/handles.slopeDirectRight; 
% %         % end where line crosses x axis
% %         xl(2) = max(handles.xDirectRight); 
% %         tl(1) = 0;
% %         tl(2) = handles.slopeDirectRight*xl(2)+handles.interDirectRight;
% %         handles.hLineDirectRight = plot(handles.pick_plot,xl,tl,'g');      
% %     end
% % 
% %     %query for refraction picks to the right
% %     handles.RefractRightPanelOn = 1;
% %     set(handles.right_panel,'Visible','on');
% %     sliderminR = handles.ShotLoc+0.05;
% %     slidermaxR = max(handles.TimePicks.RecXProf)+1;
% %     startvalueR = sliderminR +(slidermaxR-sliderminR)/10;
% %     caption_right = sprintf('%.2f', startvalueR);
% %     set(handles.refract_right_range,'Min',sliderminR);
% %     set(handles.refract_right_range,'Max',slidermaxR);
% %     set(handles.refract_right_range,'Value',startvalueR);
% %     set(handles.refract_right_range,'Visible','on');
% %     % set(handles.slider_value_refracted_right,'String', caption_right);
% %     % caption_right = sprintf('%.2f', handles.RecXProfMinRefractRight);
% %     set(handles.slider_value_refracted_right,'String',...
% %         ['Geophones past ' caption_right ' m']);
% %     set(handles.slider_value_refracted_right,'Visible','on');
% %     set(handles.right_slider_label_part_2,'Visible','on');
% % else
% %     handles.isDirectRight = 0;
% % end
% % 
% %  % Save the handles structure.
% %  guidata(hObject, handles);
 % --- END SHOT POINT LOCATION AND MAKE PICK ASSIGNMENTS---------------
%%***********************end***********comment for now,invisible, on
%%6/30/2016 sanaz
%%
% --- NOT CLEAR ON THIS FUNCTION, REQUIRED FOR TIME PICK PLOT-------------
% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
%% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Save the handles structure.
 guidata(hObject, handles);
% Hint: place code in OpeningFcn to populate axes1


% --- SLIDER MOVEMENT TO SET RANGE OF REFRACTIONS TO LEFT -----------------
% --- Executes on slider movement.
function refract_left_range_Callback(hObject, eventdata, handles)
%%
handles.xMaxRefractLeft = get(hObject,'Value');
caption_left = sprintf('%.2f', handles.xMaxRefractLeft);
set(handles.slider_value_refracted_left,'String',...
    ['Geophones before ' caption_left ' m']);
% if they exist, delete previous plot lines
if handles.isLineDirectLeft == 1
    delete(handles.hLineDirectLeft);
    handles.isLineDirectLeft = 0;
end
if handles.isLineRefractLeft == 1
    delete(handles.hLineRefractLeft);
    handles.isLineRefractLeft = 0;
end

% clear legend labels off
set(handles.label_direct_left,'Visible','off'); 
set(handles.label_refract_left,'Visible','off'); 
set(handles.velocity_direct_left,'Visible','off'); 
set(handles.velocity_refract_left,'Visible','off'); 


% if pick is to left of xMaxRefractLeft, it is assigned to refracted wave
inddirleft = find(handles.xLeft >= handles.xMaxRefractLeft);
indrefleft = find(handles.xLeft < handles.xMaxRefractLeft);


%---DIRECT WAVE ----------------------------------------------------------
% assign and plot
if length(inddirleft) > 0
    handles.isDirectLeft = 1;
    set(handles.label_direct_left,'Visible','on'); 
    handles.xDirectLeft = handles.xLeft(inddirleft);
    handles.tDirectLeft = handles.tLeft(inddirleft);
    plot(handles.pick_plot,handles.xDirectLeft,handles.tDirectLeft,'*b');hold on;
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectLeft];
    tfit = [0; handles.tDirectLeft];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectLeft = p(1);
    handles.interDirectLeft = p(2);
    handles.vDirectLeft = -1/p(1)*1000; %convert to m/s
    % optional line plot
    if (handles.doLinePlot == 1)
        handles.isLineDirectLeft = 1;
        % start just before first pick
        xl(1) = min(handles.xDirectLeft); 
        % end where line crosses x axis
        xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
        tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
        tl(2) = 0;
        handles.hLineDirectLeft = plot(handles.pick_plot,xl,tl,'b');hold on; 
        
        % add velocity label below plot
        set(handles.velocity_direct_left,'Visible','on'); 
        caption_vdirleft = sprintf('%.0f', handles.vDirectLeft);
        set(handles.velocity_direct_left,'String',...
            ['v1 = -1/slope = ' caption_vdirleft ' m/s']);
    end
end


% --- REFRACTED WAVE ------------------------------------------------------
if length(indrefleft) > 0
    handles.isRefractLeft = 1;  
    handles.xRefractLeft = handles.xLeft(indrefleft);
    handles.tRefractLeft = handles.tLeft(indrefleft);
    plot(handles.pick_plot,handles.xRefractLeft,handles.tRefractLeft,'*m');hold on;
    set(handles.label_refract_left,'Visible','on'); 
    
    if length(indrefleft) > 1 % need to points to fit to a line
        handles.isSlopeRefractLeft = 1;
        p = polyfit(handles.xRefractLeft,handles.tRefractLeft,1);
        handles.slopeRefractLeft = p(1);
        handles.interRefractLeft = p(2);
        handles.vRefractLeft = -1/p(1)*1000; %convert to m/s
        % optional line plot
        if (handles.doLinePlot == 1)
            handles.isLineRefractLeft = 1;
            % start just before first pick
            xl(1) = min(handles.xRefractLeft); 
            % end just after last pick
            xl(2) = max(handles.xRefractLeft); 
            tl(1) = handles.slopeRefractLeft*xl(1)+handles.interRefractLeft;
            tl(2) = handles.slopeRefractLeft*xl(2)+handles.interRefractLeft;
            handles.hLineRefractLeft = plot(handles.pick_plot,xl,tl,'m'); hold on;   
            
            % add velocity label below plot
            set(handles.velocity_refract_left,'Visible','on'); 
            caption_vrefleft = sprintf('%.0f', handles.vRefractLeft);
            set(handles.velocity_refract_left,'String',...
                ['v2 = -1/slope = ' caption_vrefleft ' m/s']);
        end
    end
end

 guidata(hObject, handles);  
% --- END SLIDER TO SET RANGE OF REFRACTIONS TO LEFT ---------------------

% --- SLIDER MOVEMENT TO SET RANGE OF REFRACTIONS TO RIGHT -----------------
% --- Executes on slider movement.
function refract_right_range_Callback(hObject, eventdata, handles)
%% hObject    handle to refract_right_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xMinRefractRight = get(hObject,'Value');
caption_right = sprintf('%.2f', handles.xMinRefractRight);
set(handles.slider_value_refracted_right,'String',...
    ['Geophones past ' caption_right ' m']);

% if they exist, delete previous plot lines
if handles.isLineDirectRight == 1
    delete(handles.hLineDirectRight);
    handles.isLineDirectRight = 0;
end
if handles.isLineRefractRight == 1
    delete(handles.hLineRefractRight);
    handles.isLineRefractRight = 0;
end

% clear legend labels off
set(handles.label_direct_right,'Visible','off'); 
set(handles.label_refract_right,'Visible','off'); 

% if pick is to right of xMinRefractRight, it is assigned to refracted
% wave
inddirright = find(handles.xRight <= handles.xMinRefractRight);
indrefright = find(handles.xRight > handles.xMinRefractRight);


%---DIRECT WAVE ----------------------------------------------------------
% assign and plot
if length(inddirright) > 0
    handles.isDirectRight = 1;
    set(handles.label_direct_right,'Visible','on');    
    handles.xDirectRight = handles.xRight(inddirright);
    handles.tDirectRight = handles.tRight(inddirright);
    plot(handles.pick_plot,handles.xDirectRight,handles.tDirectRight,'*g');hold on;
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectRight];
    tfit = [0; handles.tDirectRight];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectRight = p(1);
    handles.interDirectRight = p(2);
    handles.vDirectRight = 1/p(1)*1000; %convert to m/s
    % optional line plot
    if (handles.doLinePlot == 1)
        handles.isLineDirectRight = 1;
        % start just before first pick
        xl(1) = -handles.interDirectRight/handles.slopeDirectRight; 
        % end where line crosses x axis
        xl(2) = max(handles.xDirectRight); 
        tl(1) = 0;
        tl(2) = handles.slopeDirectRight*xl(2)+handles.interDirectRight;
        handles.hLineDirectRight = plot(handles.pick_plot,xl,tl,'g'); hold on;       
                
        % add velocity label below plot
        set(handles.velocity_direct_right,'Visible','on'); 
        caption_vdirright = sprintf('%.0f', handles.vDirectRight);
        set(handles.velocity_direct_right,'String',...
            ['v1 = 1/slope = ' caption_vdirright ' m/s']);

    end
end
        
% --- REFRACTED WAVE ------------------------------------------------------
if length(indrefright) > 0
    handles.isRefractRight = 1;  
    handles.xRefractRight = handles.xRight(indrefright);
    handles.tRefractRight = handles.tRight(indrefright);
    plot(handles.pick_plot,handles.xRefractRight,handles.tRefractRight,'*r');hold on;
    set(handles.label_refract_right,'Visible','on'); 
    
    % if possible, find slope of refracted arrivals 
    if length(indrefright) > 1 % need two points to fit to a line
        handles.isSlopeRefractRight = 1;
        p = polyfit(handles.xRefractRight,handles.tRefractRight,1);
        handles.slopeRefractRight = p(1);
        handles.interRefractRight = p(2);
        handles.vRefractRight = 1/p(1)*1000; %convert to m/s
        guidata(hObject, handles); % save all handle variables for use below
        
        % if v1 also exists, find layer thickness
        if handles.isDirectRight == 1;
            isLayerThicknessRight = 1;
            t_at_shot = handles.slopeRefractRight*handles.ShotLoc +...
                handles.interRefractRight;
            handles.LayerThicknessRight = t_at_shot/2000*...
                handles.vRefractRight*handles.vDirectRight/...
                sqrt(handles.vRefractRight^2-handles.vDirectRight^2);
        end
        % optional line plot
        if (handles.doLinePlot == 1)
            handles.isLineRefractRight = 1;
            % start just before first pick
            xl(1) = min(handles.xRefractRight); 
            % end just after last pick
            xl(2) = max(handles.xRefractRight); 
            tl(1) = handles.slopeRefractRight*xl(1)+handles.interRefractRight;
            tl(2) = handles.slopeRefractRight*xl(2)+handles.interRefractRight;
            handles.hLineRefractRight = plot(handles.pick_plot,xl,tl,'r'); hold on; 
            
            % add velocity label below plot
            set(handles.velocity_refract_right,'Visible','on'); 
            caption_vrefright = sprintf('%.0f', handles.vRefractRight);
            set(handles.velocity_refract_right,'String',...
                ['v2 = 1/slope = ' caption_vrefright ' m/s']);
        end
    end
    
%      
%         % optional line plot
%         if (handles.doLinePlot == 1)
%             handles.isLineRefractRight = 1;
%             % start just before first pick
%             xl(1) = min(handles.xRefractRight); 
%             % end just after last pick
%             xl(2) = max(handles.xRefractRight); 
%             tl(1) = handles.slopeRefractRight*xl(1)+handles.interRefractRight;
%             tl(2) = handles.slopeRefractRight*xl(2)+handles.interRefractRight;
%             handles.hLineRefractRight = plot(xl,tl,'r'); 
%             
%             % add velocity label below plot
%             set(handles.velocity_refract_right,'Visible','on'); 
%             caption_vrefright = sprintf('%.0f', handles.vRefractRight);
%             set(handles.velocity_refract_right,'String',...
%                 ['v2 = 1/slope = ' caption_vrefright ' m/s']);
% 
%         end
%     end
end
 guidata(hObject, handles);  
% --- END SLIDER TO SET RANGE OF REFRACTIONS TO RIGHT ---------------------


% --- TOGGLE BUTTON TO SHOW LINES ----------------------------------------
% --- Executes on button press in toggle_line_fit.
function toggle_line_fit_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max') %button is pushed
	handles.doLinePlot = 1;
    
    % make structure and ray plot toggle button visible
    set(handles.ComputeStructureButton,'Visible','on');
    
    if handles.isDirectLeft == 1;  
        handles.isLineDirectLeft = 1;
        % plot line 
        % start just before first pick
        xl(1) = min(handles.xDirectLeft); 
        % end where line crosses x axis
        xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
        tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
        tl(2) = 0;
        handles.hLineDirectLeft = plot(handles.pick_plot,xl,tl,'b'); hold on;                
        % add velocity label below plot
        set(handles.velocity_direct_left,'Visible','on'); 
        caption_vdirleft = sprintf('%.0f', handles.vDirectLeft);
        set(handles.velocity_direct_left,'String',...
            ['v1 = -1/slope = ' caption_vdirleft ' m/s']);
    end
    if  handles.isSlopeRefractLeft == 1;
        handles.isLineRefractLeft = 1;
        % start just before first pick
        xl(1) = min(handles.xRefractLeft); 
        % end just after last pick
        xl(2) = max(handles.xRefractLeft); 
        tl(1) = handles.slopeRefractLeft*xl(1)+handles.interRefractLeft;
        tl(2) = handles.slopeRefractLeft*xl(2)+handles.interRefractLeft;
        handles.hLineRefractLeft = plot(handles.pick_plot,xl,tl,'m'); hold on;
        % add velocity label below plot
        set(handles.velocity_refract_left,'Visible','on'); 
        caption_vrefleft = sprintf('%.0f', handles.vRefractLeft);
        set(handles.velocity_refract_left,'String',...
            ['v2 = -1/slope = ' caption_vrefleft ' m/s']);

    end
    if handles.isDirectRight == 1;  
        handles.isLineDirectRight = 1;
        % plot line 
        % start just before first pick
        xl(1) = -handles.interDirectRight/handles.slopeDirectRight; 
        % end where line crosses x axis
        xl(2) = max(handles.xDirectRight); 
        tl(1) = 0;
        tl(2) = handles.slopeDirectRight*xl(2)+handles.interDirectRight;
        handles.hLineDirectRight = plot(handles.pick_plot,xl,tl,'g'); hold on;                       
        % add velocity label below plot
        set(handles.velocity_direct_right,'Visible','on'); 
        caption_vdirright = sprintf('%.0f', handles.vDirectRight);
        set(handles.velocity_direct_right,'String',...
            ['v1 = 1/slope = ' caption_vdirright ' m/s']);

    end
    if  handles.isSlopeRefractRight == 1;
        handles.isLineRefractRight = 1;
        % start just before first pick
        xl(1) = min(handles.xRefractRight); 
        % end just after last pick
        xl(2) = max(handles.xRefractRight); 
        tl(1) = handles.slopeRefractRight*xl(1)+handles.interRefractRight;
        tl(2) = handles.slopeRefractRight*xl(2)+handles.interRefractRight;
        handles.hLineRefractRight = plot(handles.pick_plot,xl,tl,'m'); hold on; 
         % add velocity label below plot
        set(handles.velocity_refract_right,'Visible','on'); 
        caption_vrefright = sprintf('%.0f', handles.vRefractRight);
        set(handles.velocity_refract_right,'String',...
            ['v2 = 1/slope = ' caption_vrefright ' m/s']);

    end

elseif button_state == get(hObject,'Min')
	handles.doLinePlot = 0;
    
    % make structure and ray plot toggle button invisible
    set(handles.ComputeStructureButton,'Visible','off');
    set(handles.SaveToFileButton,'Visible','off');
    
    if handles.isLineDirectLeft == 1
        delete(handles.hLineDirectLeft);
        set(handles.velocity_direct_left,'Visible','off'); 
        handles.isLineDirectLeft = 0;
        handles.hLineDirectLeft = 0;
    end
    if handles.isLineRefractLeft == 1
        delete(handles.hLineRefractLeft);
        set(handles.velocity_refract_left,'Visible','off'); 
        handles.isLineRefractLeft = 0;
        handles.hLineRefractLeft = 0;
    end
    if handles.isLineDirectRight == 1
        delete(handles.hLineDirectRight);
        set(handles.velocity_direct_right,'Visible','off'); 
        handles.isLineDirectRight = 0;
        handles.hLineDirectRight = 0;
    end
    if handles.isLineRefractRight == 1
        delete(handles.hLineRefractRight);
        set(handles.velocity_refract_right,'Visible','off'); 
        handles.isLineRefractRight = 0;
        handles.hLineRefractRight = 0;
    end
end
% Save the handles structure.
 guidata(hObject, handles);
 
% --- TOGGLE BUTTON TO SHOW STRUCTURE AND RAYS ----------------------------
%% --- Executes on button press in ComputeStructureButton.
function ComputeStructureButton_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max') %button is pushed
	handles.isStructurePlot = 1;
elseif button_state == get(hObject,'Min')
	handles.isStructurePlot = 0;
end

xshot = handles.ShotLoc;
if handles.isStructurePlot == 1 
%     VelDirectLeft = 200;
    if handles.isLineDirectLeft == 1
        VelDirectLeft = round(handles.vDirectLeft);
        x2DirLt = min(handles.xDirectLeft); 
        x1DirLt = max(handles.xDirectLeft); 
    else
        VelDirectLeft = 0;
        x2DirLt = 0;
        x1DirLt = 0;
    end    
%     VelRefractLeft = 1500;
    if handles.isLineRefractLeft == 1
        VelRefractLeft = round(handles.vRefractLeft);
        x2RefLt = min(handles.xRefractLeft); 
        x1RefLt = max(handles.xRefractLeft); 
    else
        VelRefractLeft = 0;
        x2RefLt = 0;
        x1RefLt = 0;
    end    
%     VelDirectRight = 270;
    if handles.isLineDirectRight == 1
        VelDirectRight = round(handles.vDirectRight);
        x1DirRt = min(handles.xDirectRight); 
        x2DirRt = max(handles.xDirectRight); 
    else
        VelDirectRight = 0;
        x2DirRt = 0;
        x1DirRt = 0;
    end
    if handles.isLineRefractRight == 1
        VelRefractRight = round(handles.vRefractRight);
        x1RefRt = min(handles.xRefractRight); 
        x2RefRt = max(handles.xRefractRight); 
    else
        VelRefractRight = 0;
        x2RefRt = 0;
        x1RefRt = 0;
    end 
    
%     LayerThicknessLeft = 4;
%     xmin = 10; xmax = 79; xshot = 62.5;
%     vplotmin = 0; vplotmax = 2500; %m/s
% create structure plot
    set(handles.StructurePlot,'Visible','on');
    axes(handles.StructurePlot);
    
    if VelRefractLeft == 0 && VelDirectLeft ~= 0
        %when we don't have refraction, depth is unknown, assume it is 2 for plotting
        ThicknessLt1 = 2;
        ThicknessLt2 = 0;
        handles.xRefractLeft = 0;
        
        XPatchDirectLeft = [x2DirLt xshot xshot x2DirLt];
        YPatchDirectLeft = [0 0 -ThicknessLt1 -ThicknessLt1];
        patch(XPatchDirectLeft, YPatchDirectLeft,VelDirectLeft,'EdgeColor','none'); hold on;
        %add ? to indicate true depth unknown
        xQ = x2DirLt+xshot/2;
        text(xQ, -ThicknessLt1 ,'?');
        
    elseif VelRefractLeft ~= 0 && VelDirectLeft ~= 0
        ThicknessLt1 = 0.5 * handles.interRefractLeft * VelRefractLeft * VelDirectLeft...
            /(1000*sqrt((VelRefractLeft^2)-(VelDirectLeft^2)));
        % Illustrate refracted velocity to Right (could compute actually min depth
        % to which velocity is known from picks), for now just draw the second
        % layer with a thickness of 2 m
        ThicknessLt2 = ThicknessLt1+2;
        %find crossover distance - don't want to plot second layer at distances
        %less than this to make clear to student that refractor is not resolved
        %there
        CrossOverLeft = (handles.interRefractLeft-...
                        (((VelRefractLeft*handles.interRefractLeft)-(VelDirectLeft*handles.interDirectLeft))/...
                        (VelRefractLeft-VelDirectLeft)))...
                        *VelRefractLeft/1000;
                    
        XPatchDirectLeft = [x2RefLt xshot xshot x2RefLt];
        YPatchDirectLeft = [0 0 -ThicknessLt1 -ThicknessLt1];
        patch(XPatchDirectLeft, YPatchDirectLeft,VelDirectLeft,'EdgeColor','none'); hold on;
        XPatchRefractLeft = [x2RefLt CrossOverLeft CrossOverLeft x2RefLt];
        YPatchRefractLeft = [-ThicknessLt1 -ThicknessLt1 ...
                               -ThicknessLt2 -ThicknessLt2];
        patch(XPatchRefractLeft, YPatchRefractLeft,VelRefractLeft,'EdgeColor','none'); hold on;
        %add ? to indicate true depth unknown
        xQ = (x2RefLt+CrossOverLeft)/2;
        text(xQ, -round(ThicknessLt2) ,'?');
        
    elseif VelDirectLeft == 0
        ThicknessLt1 = 0;
        ThicknessLt2 = 0;
        handles.xDirectLeft = 0;
        handles.xRefractLeft = 0;
    end
    
    if VelRefractRight == 0 && VelDirectRight ~= 0
%         when we don't have refraction, depth is unknown, assume it is 2 for plotting
        ThicknessRt1 = 2;
        ThicknessRt2 = 0;
        handles.xRefractRight = 0;
        
        XPatchDirectRight = [x2DirRt xshot xshot x2DirRt];
        YPatchDirectRight = [0 0 -ThicknessRt1 -ThicknessRt1];
        patch(XPatchDirectRight, YPatchDirectRight,VelDirectRight,'EdgeColor','none'); hold on;
        %add ? to indicate true depth unknown
        xQ = (x1DirRt+xshot)/2;
        text(xQ, -ThicknessRt1 ,'?');
        
    elseif VelRefractRight ~= 0 && VelDirectRight ~= 0
        t = handles.interRefractRight + (1000*xshot/VelRefractRight);
        ThicknessRt1 = 0.5 * t * VelRefractRight * VelDirectRight...
            /(1000*sqrt((VelRefractRight^2)-(VelDirectRight^2)));
        % Illustrate refracted velocity to Right (could compute actually min depth
        % to which velocity is known from picks), for now just draw the second
        % layer with a thickness of 2 m
        ThicknessRt2 = ThicknessRt1 + 2;
        %find crossover distance - don't want to plot second layer at distances
        %less than this to make clear to student that refractor is not resolved
        %there
        CrossOverRight = 2*ThicknessRt1*sqrt((VelRefractRight+VelDirectRight)/...
                        (VelRefractRight-VelDirectRight));
        
        XPatchDirectRight = [x1DirRt x2RefRt x2RefRt x1DirRt];
        YPatchDirectRight = [0 0 -ThicknessRt1 -ThicknessRt1];
        patch(XPatchDirectRight, YPatchDirectRight,VelDirectRight,'EdgeColor','none'); hold on;
        XPatchRefractRight = [x2RefRt CrossOverRight+xshot CrossOverRight+xshot x2RefRt];
        YPatchRefractRight = [-ThicknessRt1 -ThicknessRt1 ...
                               -ThicknessRt2 -ThicknessRt2];
        patch(XPatchRefractRight, YPatchRefractRight,VelRefractRight,'EdgeColor','none'); hold on;
        %add ? to indicate true depth unknown
        xQ = x2RefRt+(xshot+CrossOverRight)/2;
        text(xQ, -ThicknessRt2 ,'?');
        
    elseif VelDirectRight == 0
        ThicknessRt1 = 0;
        ThicknessRt2 = 0;
        handles.xDirectRight = 0;
        handles.xRefractRight = 0;
    end

    v = [VelDirectLeft, VelRefractLeft, VelDirectRight, VelRefractRight];
    vplotmin = min(v(:));
    vplotmax = max(v(:));
    colormap(jet)
    VertExag = 3;

%     % create structure plot
%     set(handles.StructurePlot,'Visible','on');
%     axes(handles.StructurePlot);
  
    X = [xshot; handles.xDirectRight; handles.xRefractRight; handles.xDirectLeft; handles.xRefractLeft];
    X = X(X~=0);
    mxX = max(X(:));
    mnX = min(X(:));
    xlim([mnX mxX]);
    D = [ThicknessRt1, ThicknessRt2, ThicknessLt1, ThicknessLt2];
    mxD = max(D(:));
    ylim([ -round(mxD) 1]);
    caxis([vplotmin vplotmax]);
    ylabel('depth (m)'); xlabel('distance(m)');
    hcb = colorbar;
    title(hcb,'velocity (m/s)');
%     daspect([1 1/VertExag 1]);
    %add marker to indicate shot location
    plot(xshot,0.2,'k*','Markersize',14);
    
   
    % write out structure parameters
    set(handles.StructurePanel,'Visible','on');

    set(handles.VDirLabel,'Visible','on');
    set(handles.VRefLabel,'Visible','on');
    if VelDirectLeft == 0
        VDirAve = VelDirectRight;
    elseif VelDirectRight == 0
        VDirAve = VelDirectLeft;
    else
        VDirAve = (VelDirectLeft + VelDirectRight)/2;
    end
    
    if VelRefractLeft == 0 && VelRefractRight == 0
        VRefAve = 0;
    elseif VelRefractLeft ~= 0 && VelRefractRight == 0
        VRefAve = VelRefractLeft;
    elseif VelRefractLeft == 0 && VelRefractRight ~= 0
        VRefAve = VelRefractRight;
    elseif VelRefractLeft ~= 0 && VelRefractRight ~= 0
        VRefAve = (VelRefractRight+VelRefractLeft)/2;
    end
    
    caption = sprintf('%.0f', VDirAve);
    set(handles.VDirLabel,'String',['VDirAve = ' caption ' m/s']);  
    caption = sprintf('%.0f', VRefAve);
    set(handles.VRefLabel,'String',['VRefAve = ' caption ' m/s']);

end
% handles.txt , A for saving structure information on save button in a txt file
A = {'VelDirectLeft','VelRefractLeft','VelDirectRight','VelRefractRight','ThicknessRt1', 'ThicknessRt2', 'ThicknessLt1', 'ThicknessLt2'...
    ;num2str(VelDirectLeft),num2str(VelRefractLeft),num2str(VelDirectRight),num2str(VelRefractRight),num2str(ThicknessRt1), num2str(ThicknessRt2), num2str(ThicknessLt1), num2str(ThicknessLt2)}';
handles.txt = A;
%**********************************************************
set(handles.SaveToFileButton,'Visible','on');
% Save the handles structure.
 guidata(hObject, handles);



 
%% --- FROM HERE ON DOWN ARE ALL FUNCTIONS CREATING GUI ITEMS

% --- CREATES THE BOX IN WHICH TO ENTER THE SHOT LOCATION
% --- Executes during object creation, after setting all properties.
function enter_shot_location_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_shot_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');    
end
% Save the handles structure.
 guidata(hObject, handles);
 
 
% --- CREATE SLIDER TO SET RANGE OF REFRACTIONS TO LEFT -------------------
% --- Executes during object creation, after setting all properties.
function refract_left_range_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- CREATE SLIDER TO SET RANGE OF REFRACTIONS TO RIGHT ------------------
% --- Executes during object creation, after setting all properties.
function refract_right_range_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function pick_plot_CreateFcn(hObject, eventdata, handles)
% Hint: place code in OpeningFcn to populate pick_plot

% --- THE FOLLOWING ARE STATIC LABELS ------------------------------------

% --- Executes during object creation, after setting all properties.
function pick_plot_title_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider_value_refracted_right_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function label_direct_left_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call


% --- Executes during object creation, after setting all properties.
function label_direct_right_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call

% --- Executes during object creation, after setting all properties.
function label_refract_right_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call

% --- Executes during object creation, after setting all properties.
function right_panel_CreateFcn(hObject, eventdata, handles)
% NOTE  invisible in initial call

% --- Executes during object creation, after setting all properties.
function slider_value_refracted_left_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function left_slider_label_part_2_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function right_slider_label_part_2_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function toggle_line_fit_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call

% --- Executes during object creation, after setting all properties.
function ComputeStructureButton_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call


% --- Executes during object creation, after setting all properties.
function velocity_direct_left_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call


% --- Executes during object creation, after setting all properties.
function velocity_refract_left_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call


% --- Executes during object creation, after setting all properties.
function velocity_direct_right_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call

% --- Executes during object creation, after setting all properties.
function velocity_refract_right_CreateFcn(hObject, eventdata, handles)
% NOTE invisible in initial call


% --- Executes on button press in SaveToFileButton.
function SaveToFileButton_Callback(hObject, eventdata, handles)

% filename = [num2str(handles.objFilename.FileNumber),'_corr.mat'];
%setup path to save the results of the picking routine
fs = filesep;
filepath = pwd;
Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
%test the existence of a Processed files directory for saving the file.
%If the directory does not exist, make one then save the files to it.
if exist(Savepath,'dir')
    %     save([Savepath fs,filename],'objFinal');
    Filenametxt = [Savepath,fs,num2str(handles.obj.FileNumber),'_Structure_Parameters.txt'];
    
    Filenamepng = [Savepath,fs,num2str(handles.obj.FileNumber),'_Velocity_structure.png'];
    
    print(gcf,'-dpng','-r300',Filenamepng)
    fileID = fopen(Filenametxt,'w');
    for i=1:length(handles.txt)
        formatSpec = strcat('%s \t %s \r\n');
        fprintf(fileID,formatSpec,handles.txt{i,:});
    end
    fclose(fileID);
   
else
    mkdir (Savepath)
    %     save([Savepath fs ,filename],'objFinal');
    
    Filenametxt = [Savepath,fs,num2str(handles.obj.FileNumber),'_Structure_Parameters.txt'];
    
    Filenamepng = [Savepath,fs,num2str(handles.obj.FileNumber),'_Velocity_structure.png'];
    
    print(gcf,'-dpng','-r300',Filenamepng)
    fileID = fopen(Filenametxt,'w');
    for i=1:length(handles.txt)
        formatSpec = strcat('%s \t %s \r\n');
        fprintf(fileID,formatSpec,handles.txt{i,:});
    end
    fclose(fileID);
    
end
msgbox({('Your files has been saved in this directory successfully : '),Savepath})


% --- Executes when user attempts to close singleShotGUI.
function singleShotGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to singleShotGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
