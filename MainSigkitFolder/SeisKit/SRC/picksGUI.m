function varargout = picksGUI(varargin)
% PICKSGUI MATLAB code for picksgui.fig
%      PICKSGUI, by itself, creates a new PICKSGUI or raises the existing
%      singleton*.
%
%      H = PICKSGUI returns the handle to a new PICKSGUI or the handle to
%      the existing singleton*.
%
%      PICKSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKSGUI.M with the given input arguments.
%
%      PICKSGUI('Property','Value',...) creates a new PICKSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picksGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picksGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picksgui

% Last Modified by GUIDE v2.5 28-Jun-2016 12:07:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picksGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @picksGUI_OutputFcn, ...
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


% --- Executes just before picksgui is made visible.
function picksGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picksgui (see VARARGIN)

set(handles.txtWait,'Visible','off');
%%%%*********All the Figures should be closed for this step, So ask user
%%%%*********to save and close figures in last step and then Program will
%%%%*********automatically close all figures here

fh = findall(0,'Type','Figure');    
for i=1:length(fh)
    if isempty(fh(i).Tag)==1
        close(fh(i))
    end
end

% Choose default command line output for picksgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picksgui wait for user response (see UIRESUME)
% uiwait(handles.PicksGUI);


% --- Outputs from this function are returned to the command line.
function varargout = picksGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbnGoBack.
function pushbnGoBack_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnGoBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close picksGUI

% --- Executes on button press in pushbnContinue.
function pushbnContinue_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnContinue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.txtWait,'Visible','on');
drawnow 
 % get the handle of seismicsGUI
 h = findobj('Tag','seismicsGUI');

 % if exists (not empty)
 if ~isempty(h)
    
    % get handles and other user-defined data associated to seismicsGUI
    seismicsGUIdata = guidata(h);
    if get(seismicsGUIdata.radiobnSingle,'Value') == 1
        obj = seismicsGUIdata.objFilename;
    elseif get(seismicsGUIdata.radiobnDipping,'Value') == 1  && seismicsGUIdata.flg == 1
        obj = seismicsGUIdata.objFilenameFwd;
    elseif get(seismicsGUIdata.radiobnDipping,'Value') == 1  && seismicsGUIdata.flg == 2
        obj = seismicsGUIdata.objFilenameRvs;
    end
    try
        obj.picktimes;
    catch
        set(handles.txtWait,'Visible','off');
        uiwait(msgbox('Error in picking file'));        
    end
 end
 set(handles.txtWait,'Visible','off');
 close picksGUI
