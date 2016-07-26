function varargout = seismicsGUI(varargin)
% Last Modified by GUIDE v2.5 08-Jul-2016 13:56:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seismicsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @seismicsGUI_OutputFcn, ...
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


% --- Executes just before seismicsGUI is made visible.
function seismicsGUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for seismicsGUI
handles.output = hObject;

set(handles.txtWait,'Visible','off');
set(handles.pushbnReadData,'Enable','on');
set(handles.pushbnPickTime,'Enable','off');
set(handles.pushbnVelocity,'Enable','off');
 
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = seismicsGUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbnReadData.
function pushbnReadData_Callback(hObject, eventdata, handles)

set(handles.txtWait,'Visible','on');
[filenameInput,filepathInput]=uigetfile({'*.dat'},...
  'Select Input File');
if filenameInput ~= 0 
     FileName = filenameInput(1:(length(filenameInput)-4));
     objFilename = SeisObj(filenameInput);

     handles.objFilename = objFilename;
%      test=figure;
     plot(objFilename,'clipped');
     title('test');
     set(handles.txtWait,'Visible','off');
     set(handles.pushbnReadData,'Enable','off');
     set(handles.pushbnPickTime,'Enable','on');
     set(handles.pushbnVelocity,'Enable','off');
    %  Save the handles structure.
    
end
% guidata(hObject, handles);  % END OPEN INPUT FILE

 
set(handles.txtWait,'Visible','off');
shotPosition = objFilename.ShotXProf;
ReceiverPosition = objFilename.RecXProf;
options.Interpreter = 'tex';
% Include the desired Default answer
options.Default = 'Yes';
% Create a TeX string for the question
qstringS = strcat('Shot position is at ' , ' :( ' , num2str(shotPosition), ' ',') Is it correct?');
choiceS = questdlg(qstringS,'','Yes','No',options);
switch choiceS
    case 'Yes'
        %%%%case yes in shot position
        ShotCaseAnswer = 1;
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
                %%%%case No and changing in receiver position in case of yes for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilename.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
                
            case ''
                RecCaseAnswer = 0;
        end    
    case 'No'
        ShotCaseAnswer = 2;
        %%%%case No and changing in shot position
        answer = inputdlg('What is the correct shot position : ',...
             ' ', [1 20]); 
        if isempty(answer)
            ShotCaseAnswer = 0; 
        else
            handles.objFilename.ShotXProf = [str2double(answer{1})];
        end
        
        %%%%asking about receiver position
        qstringR = strcat('Receiver position is at ' , ' :( ' , num2str(ReceiverPosition), ' ',') Is it correct?');
        choiceR = questdlg(qstringR,'','Yes','No',options);
        switch choiceR
            case 'Yes'
                RecCaseAnswer = 1;
            case 'No'
        %%%%case No and changing in receiver position in case of no for shot
                RecCaseAnswer = 2;
                prompt = {'What is the correct Receiver position? FirstGeophone:','Spacing:','LastGeophone:'};
                answer = inputdlg(prompt,'',[1 50; 1 50; 1 50]);
                if isempty(answer)
                    RecCaseAnswer = 0;
                else
                    handles.objFilename.RecXProf = [str2num(answer{1}):str2num(answer{2}):str2num(answer{3})];
                end
    
            case ''
                RecCaseAnswer = 0;
        end    
    case ''
        ShotCaseAnswer = 0;
end

objFinal = handles.objFilename; 

if (ShotCaseAnswer == 2) || (RecCaseAnswer == 2)
    set(handles.txtWait,'Visible','on');
    fh = findall(0,'Type','Figure');
    
    for i=1:length(fh)
        if isempty(fh(i).Tag)==1
            close(fh(i))
        end
    end

    plot(objFinal,'simple');
    filename = [num2str(handles.objFilename.FileNumber),'_corr.mat'];
    %setup path to save the results of the picking routine
    fs = filesep;
    filepath = pwd;    
    Savepath = strcat([filepath fs 'Seismics' fs 'Processed_files']);
    %test the existence of a Processed files directory for saving the file.
    %If the directory does not exist, make one then save the files to it.
    if exist(Savepath,'dir')
        save([Savepath fs,filename],'objFinal');
    else
        mkdir (Savepath)
        save([Savepath fs ,filename],'objFinal');
    end
        
    set(handles.txtWait,'Visible','off');
    msgbox(strcat('Your correction file has been saved with (', filename, ' ) name'));
end

%%%%*********All the Figures should be closed for next step, So ask user
%%%%*********to save and close figures and then Program will
%%%%*********automatically close all figures at opening the next step
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
msgString = {'Please save your figures that you may need' ...
             ,'and close all figures before going to the next step.'...
             ,'If you do not the program will close but NOT save them automatically!'};
uiwait(msgbox(msgString,'Warning','error',CreateStruct));

%%%%*******************************************************


guidata(hObject, handles);  % END OPEN INPUT FILE
setappdata(handles.seismicsGUI,'objFilename',handles.objFilename);

% msgbox('Please for continuing seicmic steps go back to main seismic page')

% --- Executes on button press in pushbnPickTime.
function pushbnPickTime_Callback(hObject, eventdata, handles)

set(handles.pushbnReadData,'Enable','off');
set(handles.pushbnPickTime,'Enable','off');
set(handles.pushbnVelocity,'Enable','on');
varargout = picksGUI(figure(picksGUI));

% --- Executes on button press in pushbnVelocity.
function pushbnVelocity_Callback(hObject, eventdata, handles)

try
   varargout = singleShotGUI(figure(singleShotGUI));
catch
   msgbox('Error while loading');
   close seismicsGUI
end

 
