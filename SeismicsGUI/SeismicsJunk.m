function varargout = Seismics(varargin)
%% SEISMICS MATLAB code for Seismics.fig
%      SEISMICS, by itself, creates a new SEISMICS or raises the existing
%      singleton*.
%
%      H = SEISMICS returns the handle to a new SEISMICS or the handle to
%      the existing singleton*.
%
%      SEISMICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEISMICS.M with the given input arguments.
%
%      SEISMICS('Property','Value',...) creates a new SEISMICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Seismics_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Seismics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Seismics

% Last Modified by GUIDE v2.5 11-Feb-2016 15:21:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Seismics_OpeningFcn, ...
                   'gui_OutputFcn',  @Seismics_OutputFcn, ...
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


%--- Executes just before Seismics is made visible.
function Seismics_OpeningFcn(hObject, eventdata, handles, varargin)
%% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Seismics (see VARARGIN)


%***TEMPORARY WHILE WRITING CODE automatically reads input file

handles.TimePicks=load('picks307.mat')';
handles.xmin = min(handles.TimePicks.x);
handles.xmax = max(handles.TimePicks.x);
 plot(handles.TimePicks.x,handles.TimePicks.t,'.k');
 xlabel('geophone position (m)');
 ylabel('first arrival time (ms)');
 hold on;
 
 %*** END TEMPORARY WHILE WRITING CODE
 
 
% not all of these are necessary here, but this serves as a list of the
% flags
handles.isShotSet = 0;
handles.doLinePlot = 0;
handles.RefractLeftPanelOn = 0;  handles.RefractRightPanelOn = 0;
handles.isDirectLeft = 0;        handles.isDirectRight = 0;
handles.isRefractLeft = 0;       handles.isRefractRight = 0;
handles.isSlopeRefractLeft = 0;   handles.isSlopeRefractRight = 0;
handles.isLineDirectLeft = 0;    handles.isLineDirectRight = 0;
handles.isLineRefractLeft = 0;    handles.isLineRefractRight = 0;

% Choose default command line output for Seismics
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);  % END OPENING

% UIWAIT makes Seismics wait for user response (see UIRESUME)
%% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Seismics_OutputFcn(hObject, eventdata, handles) 
%% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%%

% --- BUTTON TO OPEN INPUT FILE AND PLOT PICKS ----------------------------
function pushbutton_open_file_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% let user select file and read in the data, assumes there are equally
% sized arrays x and t
[filename1,filepath1]=uigetfile({'*.*','All Files'},...
  'Select Time Picks File');
 handles.TimePicks=load([filepath1 filename1])';
 plot(handles.TimePicks.x,handles.TimePicks.t,'.k');
 xlabel('geophone position (m)');
 ylabel('first arrival time (ms)');

 % Save the handles structure.
 guidata(hObject, handles);  % END OPEN INPUT FILE


% --- ENTER SHOT POINT LOCATION AND MAKE PICK ASSIGNMENTS---------------
function enter_shot_location_Callback(hObject, eventdata, handles)
% hObject    handle to enter_shot_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_shot_location as text
%        str2double(get(hObject,'String')) returns contents of enter_shot_location as a double

% if shot was previously set to another value, need to delete the previous
% marker
if handles.isShotSet == 1
    delete(handles.hShot);
    % delete any previously drawn slopes
    if handles.doLinePlot == 1 &&  handles.isDirectLeft == 1
        delete(handles.hLineDirectLeft);
    end        
end

% get the shot location
handles.ShotLoc = str2double(get(hObject,'String'));
handles.isShotSet = 1;

%plot the shot
handles.hShot = plot(handles.ShotLoc,0,'xr','MarkerSize',30);

% assign all picks to direct wave to start
handles.isDirectLeft = 0; 
handles.isDirectRight = 0; 
handles.isRefractLeft = 0; handles.isSlopeRefractLeft = 0;
handles.isRefractRight = 0; handles.isSlopeRefractRight = 0;

% make line plot toggle button visible
set(handles.toggle_line_fit,'Visible','on');


% --- find and assign picks to left of shot ---------------------------
indleft = find(handles.TimePicks.x < handles.ShotLoc);
% if refract pick panel was previously plotted, it may need to be removed
if (handles.RefractLeftPanelOn == 1 && length(indleft) < 1)
        set(handles.left_panel,'Visible','off');
        set(handles.label_direct_left,'Visible','off');
        set(handles.label_refract_left,'Visible','off');
end
if length(indleft) > 0
    handles.isDirectLeft = 1;  
    % all picks to left
    handles.xLeft = handles.TimePicks.x(indleft);
    handles.tLeft = handles.TimePicks.t(indleft); 
    % initially assign all as direct arrivals
    handles.xDirectLeft = handles.TimePicks.x(indleft);
    handles.tDirectLeft = handles.TimePicks.t(indleft);
    plot(handles.xDirectLeft,handles.tDirectLeft,'*b');
    % turn label on
    set(handles.label_direct_left,'Visible','on');
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectLeft];
    tfit = [0; handles.tDirectLeft];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectLeft = p(1);
    handles.interDirectLeft = p(2);
    % optional line plot
    if (handles.doLinePlot == 1)  
        handles.isLineDirectLeft = 1;
        % start just before first pick
        xl(1) = min(handles.xDirectLeft)-0.05; 
        % end where line crosses x axis
        xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
        tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
        tl(2) = 0;
        handles.hLineDirectLeft = plot(xl,tl,'b');       
    end
    
    %query for refraction picks to the left
    handles.RefractLeftPanelOn = 1;
    set(handles.left_panel,'Visible','on');
    sliderminL = min(handles.TimePicks.x)-1;
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
indright = find(handles.TimePicks.x > handles.ShotLoc);
% if refract pick panel was previously plotted, it may need to be removed
if (handles.RefractRightPanelOn == 1 && length(indright) < 1)
        set(handles.right_panel,'Visible','off');
        set(handles.label_direct_right,'Visible','off'); 
        set(handles.label_refract_right,'Visible','off');
end
 
if length(indright) > 0    
    handles.isDirectRight = 1;
    % all picks to right
    handles.xRight = handles.TimePicks.x(indright);
    handles.tRight = handles.TimePicks.t(indright); 
    % initially assign all as direct arrivals
    handles.xDirectRight = handles.TimePicks.x(indright);
    handles.tDirectRight = handles.TimePicks.t(indright);
    plot(handles.xDirectRight,handles.tDirectRight,'*g');
    % turn label on
    set(handles.label_direct_right,'Visible','on');
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectRight];
    tfit = [0; handles.tDirectRight];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectRight = p(1);
    handles.interDirectRight = p(2);
    % optional line plot
    if (handles.doLinePlot == 1)  
        handles.isLineDirectRight = 1;
        % start just before first pick
        xl(1) = -handles.interDirectRight/handles.slopeDirectRight; 
        % end where line crosses x axis
        xl(2) = max(handles.xDirectRight)+0.05; 
        tl(1) = 0;
        tl(2) = handles.slopeDirectRight*xl(2)+handles.interDirectRight;
        handles.hLineDirectRight = plot(xl,tl,'g');      
    end

    %query for refraction picks to the right
    handles.RefractRightPanelOn = 1;
    set(handles.right_panel,'Visible','on');
    sliderminR = handles.ShotLoc+0.05;
    slidermaxR = max(handles.TimePicks.x)+1;
    startvalueR = sliderminR +(slidermaxR-sliderminR)/10;
    caption_right = sprintf('%.2f', startvalueR);
    set(handles.refract_right_range,'Min',sliderminR);
    set(handles.refract_right_range,'Max',slidermaxR);
    set(handles.refract_right_range,'Value',startvalueR);
    set(handles.refract_right_range,'Visible','on');
    % set(handles.slider_value_refracted_right,'String', caption_right);
    % caption_right = sprintf('%.2f', handles.xMinRefractRight);
    set(handles.slider_value_refracted_right,'String',...
        ['Geophones past ' caption_right ' m']);
    set(handles.slider_value_refracted_right,'Visible','on');
    set(handles.right_slider_label_part_2,'Visible','on');
else
    handles.isDirectRight = 0;
end

 % Save the handles structure.
 guidata(hObject, handles);
 % --- END SHOT POINT LOCATION AND MAKE PICK ASSIGNMENTS---------------


% --- NOT CLEAR ON THIS FUNCTION, REQUIRED FOR TIME PICK PLOT-------------
% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Save the handles structure.
 guidata(hObject, handles);
% Hint: place code in OpeningFcn to populate axes1


% --- SLIDER MOVEMENT TO SET RANGE OF REFRACTIONS TO LEFT -----------------
% --- Executes on slider movement.
function refract_left_range_Callback(hObject, eventdata, handles)
handles.xMaxRefractLeft = get(hObject,'Value');
caption_left = sprintf('%.2f', handles.xMaxRefractLeft);
set(handles.slider_value_refracted_left,'String',...
    ['Geophones before ' caption_left ' m']);
% if they exist, delete previous plot lines
disp(handles.isLineDirectLeft)
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
    plot(handles.xDirectLeft,handles.tDirectLeft,'*b');
    
    % fit line to points, including the origin
    xfit = [handles.ShotLoc; handles.xDirectLeft];
    tfit = [0; handles.tDirectLeft];
    p = polyfit(xfit,tfit,1);
    handles.slopeDirectLeft = p(1);
    handles.interDirectLeft = p(2);
    % optional line plot
    if (handles.doLinePlot == 1)
        handles.isLineDirectLeft = 1;
        % start just before first pick
        xl(1) = min(handles.xDirectLeft)-0.05; 
        % end where line crosses x axis
        xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
        tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
        tl(2) = 0;
        handles.hLineDirectLeft = plot(xl,tl,'b');       
    end
end


% --- REFRACTED WAVE ------------------------------------------------------
if length(indrefleft) > 0
    handles.isRefractLeft = 1;  
    handles.xRefractLeft = handles.xLeft(indrefleft);
    handles.tRefractLeft = handles.tLeft(indrefleft);
    plot(handles.xRefractLeft,handles.tRefractLeft,'*m');
    set(handles.label_refract_left,'Visible','on'); 
    
    if length(indrefleft) > 1 % need to points to fit to a line
        handles.isSlopeRefractLeft = 1;
        p = polyfit(handles.xRefractLeft,handles.tRefractLeft,1);
        handles.slopeRefractLeft = p(1);
        handles.interRefractLeft = p(2);
        % optional line plot
        if (handles.doLinePlot == 1)
            handles.isLineRefractLeft = 1;
            % start just before first pick
            xl(1) = min(handles.xRefractLeft)-0.05; 
            % end just after last pick
            xl(2) = max(handles.xRefractLeft)+0.05; 
            tl(1) = handles.slopeRefractLeft*xl(1)+handles.interRefractLeft;
            tl(2) = handles.slopeRefractLeft*xl(2)+handles.interRefractLeft;
            handles.hLineRefractLeft = plot(xl,tl,'m');       
        end
    end
end
 guidata(hObject, handles);  
% --- END SLIDER TO SET RANGE OF REFRACTIONS TO LEFT ---------------------

% --- SLIDER MOVEMENT TO SET RANGE OF REFRACTIONS TO RIGHT -----------------
% --- Executes on slider movement.
function refract_right_range_Callback(hObject, eventdata, handles)
% hObject    handle to refract_right_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xMinRefractRight = get(hObject,'Value');
caption_right = sprintf('%.2f', handles.xMinRefractRight);
set(handles.slider_value_refracted_right,'String',...
    ['Geophones past ' caption_right ' m']);

% if pick is to right of xMinRefractRight, it is assigned to refracted
% wave
handles.isRefractRight = 0; 
inddirright = find(handles.xRight <= handles.xMinRefractRight);
indrefright = find(handles.xRight > handles.xMinRefractRight);
handles.xDirectRight = handles.xRight(inddirright);
handles.tDirectRight = handles.tRight(inddirright);
plot(handles.xDirectRight,handles.tDirectRight,'*g');
set(handles.label_refract_right,'Visible','off'); 
if length(indrefright) > 0
    handles.isRefractRight = 1;  
    handles.xRefractRight = handles.xRight(indrefright);
    handles.tRefractRight = handles.tRight(indrefright);
    plot(handles.xRefractRight,handles.tRefractRight,'*r');
    set(handles.label_refract_right,'Visible','on');   
end
% --- END SLIDER TO SET RANGE OF REFRACTIONS TO RIGHT ---------------------


% --- TOGGLE BUTTON TO SHOW LINES ----------------------------------------
% --- Executes on button press in toggle_line_fit.
function toggle_line_fit_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max') %button is pushed
	handles.doLinePlot = 1;
    
    if handles.isDirectLeft == 1;  
        handles.isLineDirectLeft = 1;
        % plot line 
        % start just before first pick
        xl(1) = min(handles.xDirectLeft)-0.05; 
        % end where line crosses x axis
        xl(2) = -handles.interDirectLeft/handles.slopeDirectLeft; 
        tl(1) = handles.slopeDirectLeft*xl(1)+handles.interDirectLeft;
        tl(2) = 0;
        handles.hLineDirectLeft = plot(xl,tl,'b');    
    end
    if  handles.isSlopeRefractLeft == 1;
        handles.isLineRefractLeft = 1;
        % start just before first pick
        xl(1) = min(handles.xRefractLeft)-0.05; 
        % end just after last pick
        xl(2) = max(handles.xRefractLeft)+0.05; 
        tl(1) = handles.slopeRefractLeft*xl(1)+handles.interRefractLeft;
        tl(2) = handles.slopeRefractLeft*xl(2)+handles.interRefractLeft;
        handles.hLineRefractLeft = plot(xl,tl,'m');       
    end
        if handles.isDirectRight == 1;  
        handles.isLineDirectRight = 1;
        % plot line 
        % start just before first pick
        xl(1) = -handles.interDirectRight/handles.slopeDirectRight; 
        % end where line crosses x axis
        xl(2) = max(handles.xDirectRight)+0.05; 
        tl(1) = 0;
        tl(2) = handles.slopeDirectRight*xl(2)+handles.interDirectRight;
        handles.hLineDirectRight = plot(xl,tl,'g');    
    end
    if  handles.isSlopeRefractRight == 1;
        handles.isLineRefractRight = 1;
        % start just before first pick
        xl(1) = min(handles.xRefractRight)-0.05; 
        % end just after last pick
        xl(2) = max(handles.xRefractRight)+0.05; 
        tl(1) = handles.slopeRefractRight*xl(1)+handles.interRefractRight;
        tl(2) = handles.slopeRefractRight*xl(2)+handles.interRefractRight;
        handles.hLineRefractRight = plot(xl,tl,'m');       
    end

elseif button_state == get(hObject,'Min')
	handles.doLinePlot = 0;
    if handles.isLineDirectLeft == 1
        delete(handles.hLineDirectLeft);
        handles.isLineDirectLeft = 0;
    end
    if handles.isLineRefractLeft == 1
        delete(handles.hLineRefractLeft);
        handles.isLineRefractLeft = 0;
    end
    if handles.isLineDirectRight == 1
        delete(handles.hLineDirectRight);
        handles.isLineDirectRight = 0;
    end
    if handles.isLineRefractRight == 1
        delete(handles.hLineRefractRight);
        handles.isLineRefractRight = 0;
    end
end
% Save the handles structure.
 guidata(hObject, handles);

 
% --- FROM HERE ON DOWN ARE ALL FUNCTIONS CREATING GUI ITEMS

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

