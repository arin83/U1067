function varargout = plot3d_GUI(varargin)
% PLOT3D_GUI MATLAB code for plot3d_GUI.fig
%      PLOT3D_GUI, by itself, creates a new PLOT3D_GUI or raises the existing
%      singleton*.
%
%      H = PLOT3D_GUI returns the handle to a new PLOT3D_GUI or the handle to
%      the existing singleton*.
%
%      PLOT3D_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT3D_GUI.M with the given input arguments.
%
%      PLOT3D_GUI('Property','Value',...) creates a new PLOT3D_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plot3d_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plot3d_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot3d_GUI

% Last Modified by GUIDE v2.5 06-Oct-2018 13:24:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plot3d_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @plot3d_GUI_OutputFcn, ...
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


% --- Executes just before plot3d_GUI is made visible.
function plot3d_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot3d_GUI (see VARARGIN)
if nargin<4 

      

else
    image=varargin{1};
    setappdata(0,'MyImage',image);
    handles.resetImage=image;
    handles.crange=[];
    handles.output = hObject;
    guidata(hObject, handles);
    
end

%set upo slider view
set(handles.slider1, ...
    'Value',45, ...
    'max',180, ...
    'min',1, ...
    'sliderstep',[1 10]/179);

set(handles.slider2, ...
    'Value',45, ...
    'max',180, ...
    'min',1, ...
    'sliderstep',[1 10]/179);

set(handles.slider3, ...
    'Value',2, ...
    'max',5, ...
    'min',0.1, ...
    'sliderstep',[1 10]/200);

% Update handles structure
colormap gray

handles = guidata(hObject);
guidata(hObject, handles);

displayI(hObject, eventdata, handles);
% Choose default command line output for plot3d_GUI
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes plot3d_GUI wait for user response (see UIRESUME)
% uiwait(handles.GUI1);


% --- Outputs from this function are returned to the command line.
function varargout = plot3d_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
displayI(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
displayI(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Zlim.
function Zlim_Callback(hObject, eventdata, handles)
% hObject    handle to Zlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Zlim

function displayI(hObject, eventdata, handles)

crange=handles.crange;
az=round(get(handles.slider1,'Value'));
ex=round(get(handles.slider2,'Value'));
xyVSz=(get(handles.slider3,'Value'));

axes(handles.axes1);
image=getappdata(0,'MyImage');
sizeY=size(image,1);
sizeX=size(image,1);
h=surf(double(flipud(image)));
set(h,'EdgeColor','none');
view(az,ex);
daspect([5 5 xyVSz]);
if not(isempty(crange))
    caxis(crange);
end
xlim([1 sizeX]);
ylim([1 sizeY]);







% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
displayI(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_low_Callback(hObject, eventdata, handles)
% hObject    handle to edit_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_low as text
%        str2double(get(hObject,'String')) returns contents of edit_low as a double


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


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function smooth_auto_Callback(hObject, eventdata, handles)
% hObject    handle to smooth_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=getappdata(0,'MyImage');
image=smoothn(image,'robust');
setappdata(0,'MyImage',image);
displayI(hObject, eventdata, handles)

% --------------------------------------------------------------------
function spline_Callback(hObject, eventdata, handles)
% hObject    handle to spline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
param=inputdlg('FSmoothing window','Spline filter option');
param=str2num(param{1});
image=getappdata(0,'MyImage');
image=smoothn(image,param);
setappdata(0,'MyImage',image);
displayI(hObject, eventdata, handles)


% --------------------------------------------------------------------
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.resetImage;
setappdata(0,'MyImage',image);
displayI(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gen_preset_Callback(hObject, eventdata, handles)
% hObject    handle to gen_preset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function preset1_Callback(hObject, eventdata, handles)
% hObject    handle to preset1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------
function lutGray_Callback(hObject, eventdata, handles)
% hObject    handle to lutGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap=gray(256);
handles.cmap=colormap;
guidata(hObject, handles);
% --------------------------------------------------------------------
function lutAFM_Callback(hObject, eventdata, handles)
% hObject    handle to lutAFM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cmap=loadColormap;

colormap(handles.cmap)
guidata(hObject, handles);


% --- Executes on button press in push_contrast.
function push_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to push_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(0,'MyImage');
activeaxes=gca;
h=gcbo;
rangename='crange';
h_contrast_GUI=contrast_GUI(data,h,activeaxes,rangename);
guidata(hObject, handles);


% --- Executes on button press in push_light.
function push_light_Callback(hObject, eventdata, handles)
% hObject    handle to push_light (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of push_light


% --- Executes on button press in push_grid.
function push_grid_Callback(hObject, eventdata, handles)
% hObject    handle to push_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of push_grid


% --------------------------------------------------------------------
function preset2_Callback(hObject, eventdata, handles)
% hObject    handle to preset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%  set(o,'FaceLighting','phong')
%  material dull;
% 
% camlight('headlight')


% --------------------------------------------------------------------
function video3d_Callback(hObject, eventdata, handles)
% hObject    handle to video3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file,path] = uigetfile('*.tif','Select your TIFF video');
cd(path)
myvideo=single(loadtiff(file));

sizeY=size(myvideo,1);
sizeX=size(myvideo,2);

% Choose default command line output for vPlay_GUI

az=round(get(handles.slider1,'Value'));
ex=round(get(handles.slider2,'Value'));
xyVSz=(get(handles.slider3,'Value'));


wb = waitbar(0,'working...','Name','progression...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(wb,'canceling',0);

%f=figure('Name','Preset 1');

f=figure('Position',[100/2 100/2 850/2 600/2],'Name','Preset 1');
% set(f, 'Color', 'black')
ax=axes;
colormap(handles.cmap);

for k=1:size(myvideo,3)
    
    if getappdata(wb,'canceling')
        break
    end
    
    myimage=myvideo(:,:,k);
    
    h=surf(ax,double(flipud(myimage)));
    set(h,'EdgeColor','none');
    view(az,ex);
    daspect([5 5 xyVSz]);
    xlim([1 sizeX]);
    ylim([1 sizeY]);
    zlim([-50 50]);
    axis off
    if not(isempty(handles.crange))
        caxis(handles.crange);
        
    end
    
    set(gca,'Projection','perspective')
    
    o = findobj('Type','surface');
    set(o,'FaceLighting','phong')
    material dull;
    shading interp
    camlight('headlight');
    
    %ax.OuterPosition=[0.1 0.1 0.7 0.7];
    video3d(k)=getframe(gca);
    waitbar(k/size(myvideo,3));
end

delete(wb)

v = VideoWriter('newfile.avi','Uncompressed AVI');
open(v)
writeVideo(v,video3d)
close(v)

% --------------------------------------------------------------------
function frame3d3_Callback(hObject, eventdata, handles)
% hObject    handle to frame3d3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=figure('Position',[100 100 850 600],'Name','Preset 1');
set(f, 'Color', 'black')

az=round(get(handles.slider1,'Value'));
ex=round(get(handles.slider2,'Value'));
xyVSz=(get(handles.slider3,'Value'));


colormap(handles.cmap);

image=getappdata(0,'MyImage');
sizeY=size(image,1);
sizeX=size(image,1);
h=surf(double(flipud(image)));
set(h,'EdgeColor','none');
view(az,ex);
daspect([5 5 xyVSz]);
xlim([1 sizeX]);
ylim([1 sizeY]);

if not(isempty(handles.crange))
    caxis(handles.crange);
end

c=colorbar;
set(c,'XColor','white','YColor','white');
set(c,'FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',3);
set(gca,'Projection','perspective')
set(gca,'FontSize',14);
set(gca,'Color',[0.1 0.1 0.1]);
set(gca,'XColor','white',...
        'YColor','white',...
        'ZColor','white');
o = findobj('Type','surface');
set(o,'FaceLighting','phong')
material dull;
shading interp
camlight('headlight');


% --------------------------------------------------------------------
function frame3d2_Callback(hObject, eventdata, handles)
% hObject    handle to frame3d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=figure('Position',[100 100 850 600],'Name','Preset 1');
set(f, 'Color', 'black')

az=round(get(handles.slider1,'Value'));
ex=round(get(handles.slider2,'Value'));
xyVSz=(get(handles.slider3,'Value'));


colormap(handles.cmap);

image=getappdata(0,'MyImage');
sizeY=size(image,1);
sizeX=size(image,1);
h=surf(double(flipud(image)));
set(h,'EdgeColor','none');
%shading interp
view(az,ex);
daspect([5 5 xyVSz]);
xlim([1 sizeX]);
ylim([1 sizeY]);

if not(isempty(handles.crange))
    caxis(handles.crange);
end

c=colorbar;
set(c,'XColor','white','YColor','white');
set(c,'FontSize',10,'FontWeight','bold');
set(gca,'LineWidth',3);
set(gca,'FontSize',14);
set(gca,'Color',[0.1 0.1 0.1]);
set(gca,'XColor','white',...
        'YColor','white',...
        'ZColor','white');
 o = findobj('Type','surface');

% --------------------------------------------------------------------
function video3d2_Callback(hObject, eventdata, handles)
% hObject    handle to video3d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.tif','Select your TIFF video');
cd(path)
myvideo=single(loadtiff(file));

sizeY=size(myvideo,1);
sizeX=size(myvideo,2);

% Choose default command line output for vPlay_GUI

az=round(get(handles.slider1,'Value'));
ex=round(get(handles.slider2,'Value'));
xyVSz=(get(handles.slider3,'Value'));


wb = waitbar(0,'working...','Name','progression...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(wb,'canceling',0);

%f=figure('Name','Preset 1');

f=figure('Position',[100/2 100/2 850/2 600/2],'Name','Preset 1');
% set(f, 'Color', 'black')
ax=axes;
colormap(handles.cmap);

for k=1:size(myvideo,3)
    
    if getappdata(wb,'canceling')
        break
    end
    
    myimage=myvideo(:,:,k);
    
    h=surf(ax,double(flipud(myimage)));
    set(h,'EdgeColor','none');
    view(az,ex);
    daspect([5 5 xyVSz]);
    xlim([1 sizeX]);
    ylim([1 sizeY]);
    zlim([-50 50]);
    axis off
    if not(isempty(handles.crange))
        caxis(handles.crange);
        
    end
    
    set(gca,'Projection','perspective')
        
    %ax.OuterPosition=[0.1 0.1 0.7 0.7];
    video3d(k)=getframe(gca);
    waitbar(k/size(myvideo,3));
end

delete(wb)

v = VideoWriter('newfile.avi','Uncompressed AVI');
open(v)
writeVideo(v,video3d)
close(v)