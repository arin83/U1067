function varargout = gaussfGUI(varargin)

% GAUSSFGUI MATLAB code for gaussfGUI.fig
%      GAUSSFGUI, by itself, creates a new GAUSSFGUI or raises the existing
%      singleton*.
%
%      H = GAUSSFGUI returns the handle to a new GAUSSFGUI or the handle to
%      the existing singleton*.
%
%      GAUSSFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAUSSFGUI.M with the given input arguments.
%
%      GAUSSFGUI('Property','Value',...) creates a new GAUSSFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gaussfGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gaussfGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gaussfGUI

% Last Modified by GUIDE v2.5 22-Nov-2017 22:10:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gaussfGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @gaussfGUI_OutputFcn, ...
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


% --- Executes just before gaussfGUI is made visible.
function gaussfGUI_OpeningFcn(hObject, eventdata, handles, varargin)

switch nargin
    case 6
        
        frame=varargin{1};
        video=varargin{2};
        range=varargin{3};
        cmap=colormap(gray);
    case 7
        frame=varargin{1};
        video=varargin{2};
        range=varargin{3};
        cmap=varargin{4};
end

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gaussfGUI (see VARARGIN)
% Choose default command line output for gaussfGUI
handles.frame=frame;
handles.video=video;
handles.range=range;


% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);

displayImage(video(:,:,frame),range);
colormap(handles.axes1,cmap)
handles.output = hObject;


% UIWAIT makes gaussfGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gaussfGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.filtered;
delete(handles.figure1);

function edit_filterSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filterSize as text
%        str2double(get(hObject,'String')) returns contents of edit_filterSize as a double


% --- Executes during object creation, after setting all properties.
function edit_filterSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filterVar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filterVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filterVar as text
%        str2double(get(hObject,'String')) returns contents of edit_filterVar as a double


% --- Executes during object creation, after setting all properties.
function edit_filterVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filterVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_process.
function pushbutton_process_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

video=handles.video;


dim=str2double(get(handles.edit_filterSize,'String'));
variance=str2double(get(handles.edit_filterVar,'String')); 
filtered=single(gaussian2d(video,dim,variance)) ;
handles.filtered=filtered;
guidata(hObject, handles);
close(gcf);




% --- Executes on button press in pushbutton_Preview.
function pushbutton_Preview_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame=handles.frame;
video=handles.video;
range=handles.range;

dim=str2double(get(handles.edit_filterSize,'String'));
variance=str2double(get(handles.edit_filterVar,'String'));
filtered=gaussian2d(video(:,:,frame),dim,variance);
axes(handles.axes1);
displayImage(filtered,range);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=handles.video;
handles.filtered=video;
guidata(hObject, handles);
close(gcf);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end


% --- Executes on button press in pushbuttonReset.
function pushbuttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame=handles.frame;
video=handles.video;
range=handles.range;

axes(handles.axes1);
displayImage(video(:,:,frame),range);
