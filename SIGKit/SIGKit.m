% Last Modified by GUIDE v2.5 23-Jun-2016 14:33:57


function varargout = SIGKit(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SIGKit_OpeningFcn, ...
                   'gui_OutputFcn',  @SIGKit_OutputFcn, ...
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


% --- Executes just before SIGKit is made visible.
function SIGKit_OpeningFcn(hObject, eventdata, handles, varargin)

cd PICS
% Directory = pwd;
% 
% if isunix
%     a = '/';
% elseif ispc
%     a = '\';
% else
%     disp('Platform not supported');
%     return;
% end

axes(handles.UofTAxes );
matlabImage = imread('UofT.png');
image(matlabImage);
axis off;
axis image;

axes(handles.MatAxes);
matlabImage = imread('Mat.png');
image(matlabImage);
axis off;
axis image;

axes(handles.USFAxes);
matlabImage = imread('USF.png');
image(matlabImage);
axis off;
axis image;
cd ..


axes(handles.PicsAxes); 
% while true
     cd slides
 
%     for i=1:6
        i = floor(rand(1,1)*6+1);
        slidesName = ['Slide',num2str(i), '.bmp'];
        x = imread(slidesName);
        image(x);
        axis off;
        
          
%         time = 0; 
%         while true
%             drawnow()
%             stop_state = get(YourPushbuttonHandle, 'Value');
%             if stop_state
%                break;
%             end
%         end
%         tic;
%         while time < 2
%              time = toc;
%         end
%     end
%  end 
 cd ..
% Choose default command line output for SIGKit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SIGKit wait for user response (see UIRESUME)
% uiwait(handles.SIGKit);


% --- Outputs from this function are returned to the command line.
function varargout = SIGKit_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in siesmicButton.
function siesmicButton_Callback(hObject, eventdata, handles)
varargout = seismicsGUI(figure(seismicsGUI));

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
close all;


% --- Executes on button press in AboutButton.
function AboutButton_Callback(hObject, eventdata, handles)
varargout = AboutGUI(figure(AboutGUI));


% --- Executes on button press in GprButton.
function GprButton_Callback(hObject, eventdata, handles)



% --- Executes on button press in MagneticButton.
function MagneticButton_Callback(hObject, eventdata, handles)
varargout = magneticGUI(figure(magneticGUI));


% --- Executes on button press in ResistivityButton.
function ResistivityButton_Callback(hObject, eventdata, handles)



% --- Executes on button press in GravityButton.
function GravityButton_Callback(hObject, eventdata, handles)



% --- Executes on button press in EmButton.
function EmButton_Callback(hObject, eventdata, handles)


% --- Executes on key press with focus on SIGKit and none of its controls.
function SIGKit_KeyPressFcn(hObject, eventdata, handles)
