function varargout = magneticGUI(varargin)
% Last Modified by GUIDE v2.5 22-Jun-2016 10:52:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @magneticGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @magneticGUI_OutputFcn, ...
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


% --- Executes just before magneticGUI is made visible.
function magneticGUI_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.popmnuInput, 'String' , {'GEM' , 'G-858'});
set(handles.popmnuBase, 'String' , {'GEM' , 'G-858'});
set(handles.popmnuColour, 'String' , {'gray' , 'rainbow' , 'rwb'});
set(handles.popmnuIllumination, 'String' , {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'});

% Choose default command line output for magneticGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes magneticGUI wait for user response (see UIRESUME)
% uiwait(handles.magneticGUI);


% --- Outputs from this function are returned to the command line.
function varargout = magneticGUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on selection change in popmnuInput.
function popmnuInput_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function popmnuInput_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popmnuBase.
function popmnuBase_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function popmnuBase_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbnOpenBasefile.
function pushbnOpenBasefile_Callback(hObject, eventdata, handles)
strInput = get(handles.popmnuBase , 'String');
valInput = get(handles.popmnuBase,'Value');
% Set current data to the selected data set.

for i=1 : length(strInput)
    switch strInput{valInput};
    case strInput(i)
        popmnuBase.current_data = strInput(i);
    end
end

a = popmnuBase.current_data;

[filenameInput,filepathInput]=uigetfile({'*.',a},...
  'Select Input File');


 Save the handles structure.
 guidata(hObject, handles);  % END OPEN INPUT FILE


% --- Executes on button press in pushbnReadInputFile.
function pushbnReadInputFile_Callback(hObject, eventdata, handles)

strInput = get(handles.popmnuInput , 'String');
valInput = get(handles.popmnuInput,'Value');
% Set current data to the selected data set.

for i=1 : length(strInput)
    switch strInput{valInput};
    case strInput(i)
        popmnuInput.current_data = strInput(i);
    end
end

a = popmnuInput.current_data;

[filenameInput,filepathInput]=uigetfile({'*.',a},...
  'Select Input File');


 Save the handles structure.
 guidata(hObject, handles);  % END OPEN INPUT FILE


% --- Executes on button press in radiobnDCorrection.
function radiobnDCorrection_Callback(hObject, eventdata, handles)




function editAltitude_Callback(hObject, eventdata, handles)
% hObject    handle to editAltitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAltitude as text
%        str2double(get(hObject,'String')) returns contents of editAltitude as a double


% --- Executes during object creation, after setting all properties.
function editAltitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAltitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMagLat_Callback(hObject, eventdata, handles)
% hObject    handle to editMagLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMagLat as text
%        str2double(get(hObject,'String')) returns contents of editMagLat as a double


% --- Executes during object creation, after setting all properties.
function editMagLat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMagLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbnRefresh.
function pushbnRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editRangemin_Callback(hObject, eventdata, handles)
% hObject    handle to editRangemin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRangemin as text
%        str2double(get(hObject,'String')) returns contents of editRangemin as a double


% --- Executes during object creation, after setting all properties.
function editRangemin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRangemin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRangemax_Callback(hObject, eventdata, handles)
% hObject    handle to editRangemax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRangemax as text
%        str2double(get(hObject,'String')) returns contents of editRangemax as a double


% --- Executes during object creation, after setting all properties.
function editRangemax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRangemax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editXmin_Callback(hObject, eventdata, handles)
% hObject    handle to editXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXmin as text
%        str2double(get(hObject,'String')) returns contents of editXmin as a double


% --- Executes during object creation, after setting all properties.
function editXmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYmin_Callback(hObject, eventdata, handles)
% hObject    handle to editYmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmin as text
%        str2double(get(hObject,'String')) returns contents of editYmin as a double


% --- Executes during object creation, after setting all properties.
function editYmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editXGridsize_Callback(hObject, eventdata, handles)
% hObject    handle to editXGridsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXGridsize as text
%        str2double(get(hObject,'String')) returns contents of editXGridsize as a double


% --- Executes during object creation, after setting all properties.
function editXGridsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXGridsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYGridsize_Callback(hObject, eventdata, handles)
% hObject    handle to editYGridsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYGridsize as text
%        str2double(get(hObject,'String')) returns contents of editYGridsize as a double


% --- Executes during object creation, after setting all properties.
function editYGridsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYGridsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbnPdf.
function pushbnPdf_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnPdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbnSave.
function pushbnSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popmnuColour.
function popmnuColour_Callback(hObject, eventdata, handles)
% hObject    handle to popmnuColour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popmnuColour contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmnuColour


% --- Executes during object creation, after setting all properties.
function popmnuColour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmnuColour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobnReduPol.
function radiobnReduPol_Callback(hObject, eventdata, handles)
% hObject    handle to radiobnReduPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobnReduPol


% --- Executes on button press in radiobnAnaSig.
function radiobnAnaSig_Callback(hObject, eventdata, handles)
% hObject    handle to radiobnAnaSig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobnAnaSig


% --- Executes on button press in radiobnUpwCon.
function radiobnUpwCon_Callback(hObject, eventdata, handles)
% hObject    handle to radiobnUpwCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobnUpwCon



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popmnuIllumination.
function popmnuIllumination_Callback(hObject, eventdata, handles)
% hObject    handle to popmnuIllumination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popmnuIllumination contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmnuIllumination


% --- Executes during object creation, after setting all properties.
function popmnuIllumination_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmnuIllumination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbnAddAnother.
function pushbnAddAnother_Callback(hObject, eventdata, handles)
strInput = get(handles.popmnuInput , 'String');
valInput = get(handles.popmnuInput,'Value');
% Set current data to the selected data set.

for i=1 : length(strInput)
    switch strInput{valInput};
    case strInput(i)
        popmnuInput.current_data = strInput(i);
    end
end

a = popmnuInput.current_data;

[filenameInput,filepathInput]=uigetfile({'*.',a},...
  'Select Input File');


 Save the handles structure.
 guidata(hObject, handles);  % END OPEN INPUT FILE
