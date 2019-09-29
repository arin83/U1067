function varargout = info_GUI(varargin)
% INFO_GUI MATLAB code for info_GUI.fig
%      INFO_GUI, by itself, creates a new INFO_GUI or raises the existing
%      singleton*.
%
%      H = INFO_GUI returns the handle to a new INFO_GUI or the handle to
%      the existing singleton*.
%
%      INFO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFO_GUI.M with the given input arguments.
%
%      INFO_GUI('Property','Value',...) creates a new INFO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before info_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to info_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help info_GUI

% Last Modified by GUIDE v2.5 25-Feb-2019 21:38:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @info_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @info_GUI_OutputFcn, ...
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


% --- Executes just before info_GUI is made visible.
function info_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to info_GUI (see VARARGIN)

switch nargin
    case 3
        handles.info=struct('none',0);
        
    case 4
        handles.info=varargin{1};
    case 5
        handles.info=varargin{1};
        fname=varargin{2};
        set(handles.figure1, 'Name', fname);
    case 6
         handles.info=varargin{1};
        fname=varargin{2};
        set(handles.figure1, 'Name', fname);
        handles.reffile=varargin{3};
        set(handles.push_Save,'Enable','on');
        
end
% Choose default command line output for info_GUI
fields={'AcqTime','Ypixel','Yrange','Xpixel','Xrange','date','time'...
    'comment','sample','microscope','cantilever'};
info=handles.info;

if ~isstruct(info)
    info=struct('none',0);
end

fieldstest=isfield(info,fields);
pos=find(~fieldstest);

if any(pos<5) && nargin==6
    set(handles.push_set,'Enable','on')
    set(handles.push_Save,'Enable','off');
end

if ~isempty(pos)
    for am=1:numel(pos)
      info.(fields{pos(am)})='Unknown';
    end
end

set(handles.text23,'String',info.AcqTime);
set(handles.text16,'String',info.Ypixel);
set(handles.text17,'String',info.Yrange);
set(handles.text15,'String',info.Xpixel);
set(handles.text14,'String',info.Xrange);
set(handles.text12,'String',info.date);
set(handles.text13,'String',info.time);

info.comment=regexprep(info.comment,'\s+',' ');
set(handles.text18,'String',info.comment);

info.sample=regexprep(info.sample,'\s+',' ');
set(handles.edit_sample,'String',info.sample);

info.microscope=regexprep(info.microscope,'\s+',' ');
set(handles.edit_microscope,'String',info.microscope);

info.cantilever=regexprep(info.cantilever,'\s+',' ');
set(handles.edit_cantilever,'String',info.cantilever);

handles.info=info;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes info_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = info_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_cant_Callback(hObject, eventdata, handles)
% hObject    handle to edit_microscope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_microscope as text
%        str2double(get(hObject,'String')) returns contents of edit_microscope as a double


% --- Executes during object creation, after setting all properties.
function edit1_cant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_microscope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_microscope_Callback(hObject, eventdata, handles)
% hObject    handle to edit_microscope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_microscope as text
%        str2double(get(hObject,'String')) returns contents of edit_microscope as a double


% --- Executes during object creation, after setting all properties.
function edit_microscope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_microscope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cantilever_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cantilever (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cantilever as text
%        str2double(get(hObject,'String')) returns contents of edit_cantilever as a double


% --- Executes during object creation, after setting all properties.
function edit_cantilever_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cantilever (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_edit.
function push_edit_Callback(hObject, eventdata, handles)
% hObject    handle to push_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
info=handles.info;
prompt = {'New comment'};
title='Edit comment';
numlines=[1 100];

if iscell(info.comment)
    default=info.comment;
else
    default={info.comment};
end

answer = inputdlg(prompt, title, numlines,default);

if ~isempty(answer)
    info.comment=char(answer);
else
    return
end

handles.info=info;
set(handles.text18,'String',info.comment);

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in push_Save.
function push_Save_Callback(hObject, eventdata, handles)
% hObject    handle to push_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
info=handles.info;
info.sample=get(handles.edit_sample,'String');
info.microscope=get(handles.edit_microscope,'String');
info.cantilever=get(handles.edit_cantilever,'String');
setappdata(handles.reffile,'info',info)
close(gcf)



function edit_sample_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sample as text
%        str2double(get(hObject,'String')) returns contents of edit_sample as a double


% --- Executes during object creation, after setting all properties.
function edit_sample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_set.
function push_set_Callback(hObject, eventdata, handles)
% hObject    handle to push_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
defaultValue = {'200', '200','200', '200','1000'};
titleBar = 'Set values';
userPrompt = {'X range: ','X pxls: ','Y range: ','Y pxls: ','Acq time: '};
setUserInput = inputdlg(userPrompt, titleBar, 1, defaultValue);
if isempty(setUserInput),return,end; % Bail out if they clicked Cancel.
% Convert to floating point from string.
usersValue = str2double(setUserInput);
defaultValue=str2double(defaultValue);

test=isnan(usersValue);
% Check for a valid integer.
if any(test)
    usersValue(test) = defaultValue(test);
    message = 'One ore more value inserted were inappropriate and replaced';
    uiwait(warndlg(message));
end

info=handles.info;

set(handles.text23,'String',usersValue(5)), info.AcqTime=usersValue(5);
set(handles.text16,'String',usersValue(4)), info.Ypixel=usersValue(4);
set(handles.text17,'String',usersValue(3)), info.Yrange=usersValue(3);
set(handles.text15,'String',usersValue(2)), info.Xpixel=usersValue(2);
set(handles.text14,'String',usersValue(1)), info.Xrange=usersValue(1);

set(handles.push_Save,'Enable','on');

handles.info=info;
guidata(hObject, handles);
