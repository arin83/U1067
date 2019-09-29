function varargout = contrast_GUI(varargin)
% CONTRAST_GUI MATLAB code for contrast_GUI.fig
%      CONTRAST_GUI, by itself, creates a new CONTRAST_GUI or raises the existing
%      singleton*.
%
%      H = CONTRAST_GUI returns the handle to a new CONTRAST_GUI or the handle to
%      the existing singleton*.
%
%      CONTRAST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTRAST_GUI.M with the given input arguments.
%
%      CONTRAST_GUI('Property','Value',...) creates a new CONTRAST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before contrast_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to contrast_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help contrast_GUI

% Last Modified by GUIDE v2.5 04-Apr-2018 15:03:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @contrast_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @contrast_GUI_OutputFcn, ...
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


% --- Executes just before contrast_GUI is made visible.
function contrast_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to contrast_GUI (see VARARGIN)
if nargin<4 

      

else
    image=varargin{1};
    handles.parentGUI=varargin{2};
    
    handles.parentaxes=varargin{3};
    handles.rangename=varargin{4};
    if nargin==8
        fname=varargin{5};
        set(handles.GUI2, 'Name', fname);
    end
    data=image(:);
    handles.inc=0.01;
    setappdata(gcf,'MyData',data);
       
    
    setup(hObject, eventdata, handles);
    handles = guidata(hObject);
    guidata(hObject, handles);
end
% Choose default command line output for contrast_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes contrast_GUI wait for user response (see UIRESUME)
% uiwait(handles.GUI2);


% --- Outputs from this function are returned to the command line.
function varargout = contrast_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if  isfield(handles,'ln1')
    delete(handles.ln1);
end
ax=handles.axes1;
yLimits = get(ax,'YLim');
xpos=get(handles.slider2,'Value');
range=handles.range;
range(1)=xpos;

if range(1)>=range(2)
    range(1)=range(2)-abs(range(2)/500);
    xpos=range(2)-abs(range(2)/500);
    set(hObject, ...
    'Value',range(1))
end

ln1=line([xpos xpos],yLimits);
handles.ln1=ln1;

set(handles.edit_low,'String',range(1))

if get(handles.check_lock,'Value')
    delta=str2double(get(handles.text_delta,'String'));
    range(2)=range(1)+delta;
    
    if  isfield(handles,'ln2')
        handles.ln2.XData=[range(2) range(2)];
    end
    
    set(handles.slider3,'Value',range(2));
    set(handles.edit_high,'String',range(2))
end

handles.range=range;
guidata(hObject, handles);

status=get(handles.checkbox1,'Value');
set(handles.text_delta,'String', num2str(range(2)-range(1)));

if status
    transfer(hObject, eventdata, handles)
end    

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if isfield(handles,'ln2')
    delete(handles.ln2);
end
ax=handles.axes1;
yLimits = get(ax,'YLim');
xpos=get(handles.slider3,'Value');
range=handles.range;
range(2)=xpos;
if range(2)<=range(1)
    range(2)=range(1)+abs(range(1)/500);
    xpos=range(1)+abs(range(1)/500);
    set(hObject, ...
    'Value',range(2))
end


ln2=line([xpos xpos],yLimits,'color','r');
handles.ln2=ln2;

set(handles.edit_high,'String',range(2))

if get(handles.check_lock,'Value')
    delta=str2double(get(handles.text_delta,'String'));
    range(1)=range(2)-delta;
    
    if  isfield(handles,'ln1')
        handles.ln1.XData=[range(1) range(1)];
    end
    
    set(handles.slider2,'Value',range(1));
    set(handles.edit_low,'String',range(1))
end

handles.range=range;
guidata(hObject, handles);

status=get(handles.checkbox1,'Value');
set(handles.text_delta,'String', num2str(range(2)-range(1)));

if status
    transfer(hObject, eventdata, handles)
end   



% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OK
transfer(hObject, eventdata, handles)
closereq

function edit_low_Callback(hObject, eventdata, handles)
% hObject    handle to edit_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_low as text
%        str2double(get(hObject,'String')) returns contents of edit_low as a double
range=handles.range;
rg1=str2double(get(hObject,'String'));
range(1)=rg1;
handles.range=range;
set(handles.slider2, ...
    'Value',range(1))
guidata(hObject, handles);
slider2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_high_Callback(hObject, eventdata, handles)
% hObject    handle to edit_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_high as text
%        str2double(get(hObject,'String')) returns contents of edit_high as a double
range=handles.range;
rg2=str2double(get(hObject,'String'));
range(2)=rg2;
handles.range=range;
set(handles.slider3, ...
    'Value',range(2))
guidata(hObject, handles);
slider3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

%setup the histogram

function setup(hObject, eventdata, handles)

axes(handles.axes1);
inc=handles.inc;

data=getappdata(gcf,'MyData');
hist(data,sqrt(length(data)));

rangedata=[min(data(:)) max(data(:))];
drange=(rangedata(2)-rangedata(1))/2;
xlim([rangedata(1)-drange rangedata(2)+drange]);

targetAxis=handles.parentaxes;
range=caxis(targetAxis);
handles.range=range;

set(handles.slider2, ...
    'Value',range(1), ...
    'max',rangedata(2)+drange, ...
    'min',rangedata(1)-drange,...
    'sliderstep',[inc 0.1]);
set(handles.slider3, ...
    'Value',range(2), ...
    'max',rangedata(2)+drange, ...
    'min',rangedata(1)-drange,...
    'sliderstep',[inc 0.1]);

%draw the lines
yLimits = get(gca,'YLim');
xpos=range(1);
ln1=line([xpos xpos],yLimits);
handles.ln1=ln1;
xpos=range(2);
ln2=line([xpos xpos],yLimits,'color','r');
handles.ln2=ln2;

%put info in the edit boxes
set(handles.edit_low,'String',num2str(range(1)));
set(handles.edit_high,'String',num2str(range(2)));

set(handles.text_delta,'String', num2str(range(2)-range(1)));

guidata(hObject, handles);


%GUI transfer data

function transfer(hObject, eventdata, handles)
  h = handles.parentGUI;
  if ~isempty(h)
      g1data = guidata(h);
      targetAxis=handles.parentaxes;
      
      range=[get(handles.slider2,'Value') get(handles.slider3,'Value')];
      caxis(targetAxis,range);
      name=handles.rangename;
      g1data.(name)=range;
%guidata(hObject, handles);     
guidata(h,g1data);
 end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sli_001_Callback(hObject, eventdata, handles)
% hObject    handle to sli_001 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.inc=0.01;  
set(handles.slider2, ...
    'sliderstep',[handles.inc 0.1]);
set(handles.slider3, ...
    'sliderstep',[handles.inc 0.1]);
guidata(hObject, handles);

% --------------------------------------------------------------------
function sli_0005_Callback(hObject, eventdata, handles)
% hObject    handle to sli_0005 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.inc=0.005;
set(handles.slider2, ...
    'sliderstep',[handles.inc 0.1]);
set(handles.slider3, ...
    'sliderstep',[handles.inc 0.1]);
guidata(hObject, handles);

% --------------------------------------------------------------------
function sli_0001_Callback(hObject, eventdata, handles)
% hObject    handle to sli_0001 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.inc=0.001;
set(handles.slider2, ...
    'sliderstep',[handles.inc 0.1]);
set(handles.slider3, ...
    'sliderstep',[handles.inc 0.1]);
guidata(hObject, handles);


% --- Executes on button press in push_auto.
function push_auto_Callback(hObject, eventdata, handles)
% hObject    handle to push_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(gcf,'MyData');
delta=[min(data)+range(data)/10 max(data)-range(data)/10];
handles.range=delta;

set(handles.slider2, ...
    'Value',delta(1))
set(handles.slider3, ...
    'Value',delta(2))

guidata(hObject, handles);

slider2_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
slider3_Callback(hObject, eventdata, handles)


% --- Executes on button press in push_update.
function push_update_Callback(hObject, eventdata, handles)
% hObject    handle to push_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%clean the axis
    
cla(handles.axes1,'reset');

%get the data shown in surFlat GUI and setup data
targetAxis=handles.parentaxes;
findimage=findobj(targetAxis,'type','image');
data=findimage.CData;
setappdata(gcf,'MyData',data(:));

%show the new graph
setup(hObject, eventdata, handles);
handles = guidata(hObject);
guidata(hObject, handles);


% --- Executes on button press in check_lock.
function check_lock_Callback(hObject, eventdata, handles)
% hObject    handle to check_lock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_lock
