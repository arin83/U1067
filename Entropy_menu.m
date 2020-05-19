function varargout = Entropy_menu(varargin)
% ENTROPY_MENU MATLAB code for Entropy_menu.fig
%      ENTROPY_MENU, by itself, creates a new ENTROPY_MENU or raises the existing
%      singleton*.
%
%      H = ENTROPY_MENU returns the handle to a new ENTROPY_MENU or the handle to
%      the existing singleton*.
%
%      ENTROPY_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENTROPY_MENU.M with the given input arguments.
%
%      ENTROPY_MENU('Property','Value',...) creates a new ENTROPY_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Entropy_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Entropy_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Entropy_menu

% Last Modified by GUIDE v2.5 11-Apr-2018 18:34:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Entropy_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @Entropy_menu_OutputFcn, ...
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


% --- Executes just before Entropy_menu is made visible.
function Entropy_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Entropy_menu (see VARARGIN)

% Choose default command line output for Entropy_menu
handles.output = hObject;

if nargin>3
    handles.data=varargin{1};
    
else
    set(handles.push_preview,'enable','off');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Entropy_menu wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Entropy_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = str2double(get(handles.edit_ksize,'String'));
varargout{2} = str2double(get(handles.edit_under,'String'));
delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
    if isfield(handles,'hpreview')
        delete(handles.hpreview);
    end
else
    
    if isfield(handles,'hpreview')
        delete(handles.hpreview);
    end
    delete(hObject);
end


% --- Executes on button press in push_OK.
function push_OK_Callback(hObject, eventdata, handles)
% hObject    handle to push_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)

% --- Executes on button press in push_preview.
function push_preview_Callback(hObject, eventdata, handles)
% hObject    handle to push_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.hpreview=figure('Name','Entropy preview','NumberTitle','Off');
ksize=str2double(get(handles.edit_ksize,'String'));
data=entropyfilt(mat2gray(handles.data),ones(ksize));
imagesc(data)
axis image
guidata(hObject, handles);


function edit_ksize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ksize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ksize as text
%        str2double(get(hObject,'String')) returns contents of edit_ksize as a double
l_ker=str2double(get(hObject,'String'));
idx = mod(l_ker,2)==0;
l_ker(idx)=l_ker(idx)+1;
set(hObject,'String',l_ker);

% --- Executes during object creation, after setting all properties.
function edit_ksize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ksize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_under_Callback(hObject, eventdata, handles)
% hObject    handle to edit_under (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_under as text
%        str2double(get(hObject,'String')) returns contents of edit_under as a double


% --- Executes during object creation, after setting all properties.
function edit_under_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_under (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
