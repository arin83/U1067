function varargout = viewer_GUI(varargin)
% VIEWER_GUI MATLAB code for viewer_GUI.fig
%      VIEWER_GUI, by itself, creates a new VIEWER_GUI or raises the existing
%      singleton*.
%
%      H = VIEWER_GUI returns the handle to a new VIEWER_GUI or the handle to
%      the existing singleton*.
%
%      VIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWER_GUI.M with the given input arguments.
%
%      VIEWER_GUI('Property','Value',...) creates a new VIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewer_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewer_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewer_GUI

% Last Modified by GUIDE v2.5 14-May-2019 17:33:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewer_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @viewer_GUI_OutputFcn, ...
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


% --- Executes just before viewer_GUI is made visible.
function viewer_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewer_GUI (see VARARGIN)
handles.axes1;
ax1=gca;
set(ax1,'YTickLabel',[])  %remove labels frpm axis
set(ax1,'XTickLabel',[])
handles.ax1=ax1;

% Choose default command line output for viewer_GUI


if ~isfield(handles,'hListener')
    handles.sliderListener = addlistener(handles.slider1,'ContinuousValueChange', ...
                                      @(hObject, event) slifake(...
                                      hObject, eventdata));
end

switch nargin
    case 3
        
    case 4
        video=varargin{1};
    case 5
        video=varargin{1};
        fname=varargin{2};
        handles.myname=fname;
        set(handles.figure1, 'Name', fname);
    case 6
        video=varargin{1};
        fname=varargin{2};
        handles.myname=fname;
        set(handles.figure1, 'Name', fname);
        setappdata(handles.axes1,'info',varargin{3});        
        set(handles.menu_editmeta,'Enable','on');
end

colormap(handles.axes1,'gray')
handles.hfig=handles.axes1;
set(handles.hfig,'Tag','MyAxis')
guidata(hObject, handles);

%setup the first image

if exist('video','var')
 setup(hObject, eventdata, handles,video)
end
% Update handles structure

handles=guidata(hObject);
handles.output = hObject;
guidata(hObject, handles);



% UIWAIT makes viewer_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = viewer_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function setup(hObject, eventdata, handles,video)
  handles.frame=1; %the first image shown is the first frame in the video
    
    sizew=size(video,2);
    sizeh=size(video,1);
    textLabel1=[num2str(sizew) ' x ' num2str(sizeh) ' pixels'];
    set(handles.textsize,'String',textLabel1);
    handles.nFrame=size(video,3);
    textLabel2 = sprintf('/%g', handles.nFrame);
    set(handles.text_nFrame,'String',textLabel2);
    
    data=video(:,:,handles.frame);
    
    handles.range=[min(data(:)) max(data(:))];%define the contrast
    %setup frame sliders
    set(handles.slider1, ...
        'Value',1, ...
        'max',handles.nFrame, ...
        'min',1, ...
        'sliderstep',[1 1]/handles.nFrame);
    
    if isappdata(handles.hfig,'info')
        set(handles.menu_editmeta,'Enable','on');
    else
        set(handles.menu_editmeta,'Enable','off');
    end
    
    
    %find which channel is shown and store with different name to avoid
    %overwriting
    if isfield(handles,'myname')
        fname=handles.myname;
        
        if contains(fname,'Ch1')
            fname='Ch1';
        elseif contains(fname,'Ch2')
            fname='Ch2';
        else    
            fname='Ch1';
        end
        
    else
        handles.myname='not specified';
        fname='Ch1';
    end
    
    handles.fname=fname;
    setappdata(handles.hfig,fname,video); %store the video
    clear video
    
    %handles=guidata(hObject);
    guidata(hObject, handles);
    displayI(hObject, eventdata, handles);

    function cleanup(hObject, eventdata, handles)
        
        if isappdata(handles.hfig,'info')
            rmappdata(handles.hfig,'info')
        end
        
        if isfield(handles, 'himage')
            handles=rmfield(handles,'himage');
        end
        
        if isfield(handles,'fname')
            if isappdata(handles.hfig,handles.fname)
                rmappdata(handles.hfig,handles.fname)
            end
        end
        
        set(handles.menu_editmeta,'Enable','off');
        guidata(hObject, handles);


function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slifake(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
sliderValue=round(get(handles.slider1,'Value'));
handles.frame=sliderValue;
% video = getappdata(0,'MyVideo');
% displayImage(video(:,:,sliderValue),handles.range);
%axes(handles.axes1);

guidata(hObject,handles);
displayI(hObject, eventdata, handles);
%handles = guidata(hObject);




% --- Executes on button press in player.
function player_Callback(hObject, eventdata, handles)
% hObject    handle to player (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of player
player=get(hObject,'Value');
sliderValue=handles.frame;


fps=str2double(get(handles.edit_speed,'String'));

if fps > 100
    fps=100;
end

count=1;
nFrames=handles.nFrame;

while player==1
    set(handles.player,'String','playing','ForegroundColor','k','FontWeight','bold','BackgroundColor','g')
    
    for k=sliderValue:nFrames   
        
         sliderValue=1;         
         displayI(hObject, eventdata, handles)
         
         if count==1
             handles=guidata(hObject);            
         end
         
         pause(1/fps);
         
         set(handles.slider1,'Value',k);                  
         player=get(hObject,'Value');
                 
         if player==0 
             handles.frame=k;
             set(handles.player,'String','Stopped','BackgroundColor','r')
             guidata(hObject, handles);
             break
             
         end
         handles.frame=k;
         count=count+1;
    end
    
end


function edit_speed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_speed as text
%        str2double(get(hObject,'String')) returns contents of edit_speed as a double


% --- Executes during object creation, after setting all properties.
function edit_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_frame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_frame as text
%        str2double(get(hObject,'String')) returns contents of edit_frame as a double
handles.frame=str2double(get(hObject,'String'));
set(handles.slider1,'Value',handles.frame);
guidata(hObject, handles);
displayI(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function displayI(hObject, eventdata, handles)

frame=handles.frame;

video = getappdata(handles.hfig,handles.fname);

data=video(:,:,frame);

clear video;

flag=get(handles.menu_display_trajectory,'Checked');

if strcmp(flag,'on')&&isfield(handles,'htraj')
    
         
    traj=handles.trajectories;
    traj=traj(:,:,frame);
            
        set(handles.htraj,'XData',traj(:,1));
        set(handles.htraj,'YData',traj(:,2));
        
end

if isfield(handles, 'himage')==0
    ax1=handles.axes1;
    if strcmp(get(handles.menu_auto_ON,'Checked'),'on')
        range=[prctile(data(:),0.1) prctile(data(:),99.9)];
    else
        range=handles.range;
    end
    handles.himage=showImage(ax1,data,range);
else
     
   set(handles.himage,'CData',data)
   if strcmp(get(handles.menu_auto_ON,'Checked'),'on')
       range=[prctile(data(:),0.1) prctile(data(:),99.9)];
       caxis(get(handles.himage,'Parent'),range)
   end
end


set(handles.edit_frame,'String',frame);
guidata(hObject, handles);


 function himage=showImage(where,data,range)
                           
           himage=imagesc(data,'parent',where,range);      
        
        axis(where,'image')
        axis(where,'off')


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_tool_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to menu_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(handles.hfig,handles.fname);
frame=handles.frame;
data=data(:,:,frame);
activeaxes=handles.axes1;
h=gcbo;
rangename='range';

if isfield(handles,'myname')
    fname=handles.myname;
    h_contrast_GUI=contrast_GUI(data,h,activeaxes,rangename,fname);
else
    h_contrast_GUI=contrast_GUI(data,h,activeaxes,rangename)
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_norm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_profile_Callback(hObject, eventdata, handles)
% hObject    handle to menu_profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hlin=imline(handles.hfig);

%make sure the ROI is within the image
api = iptgetapi(hlin);
fcn = makeConstrainToRectFcn('imline',get(handles.ax1,'XLim'),...
    get(handles.ax1,'YLim'));
api.setPositionConstraintFcn(fcn);

wait(hlin); %wait for double click

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    calibration=info.Xrange/info.Xpixel;
    profile_GUI(calibration,hlin,handles.hfig);
else
    profile_GUI(hlin,handles.hfig);
end



% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_LUT_AFM_Callback(hObject, eventdata, handles)
% hObject    handle to menu_LUT_AFM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lutAFM=loadColormap;
colormap(handles.axes1,lutAFM)

% --------------------------------------------------------------------
function menu_LUT_gray_Callback(hObject, eventdata, handles)
% hObject    handle to menu_LUT_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormap(handles.axes1,gray)

% --------------------------------------------------------------------
function menu_LUT_slimer_Callback(hObject, eventdata, handles)
% hObject    handle to menu_LUT_slimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
slimer=loadColormap2;
colormap(handles.axes1,slimer)

% --------------------------------------------------------------------
function menu_LUT_inferno_Callback(hObject, eventdata, handles)
% hObject    handle to menu_LUT_inferno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inferno=loadColormap3;
colormap(handles.axes1,inferno)

% --------------------------------------------------------------------
function menu_LUT_matlab_Callback(hObject, eventdata, handles)
% hObject    handle to menu_LUT_matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imcolormaptool


% --------------------------------------------------------------------
function menu_loadtiff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadtiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function menu_loadWS_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadWS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanup(hObject, eventdata, handles);
handles=guidata(hObject);

varName=readWS;
handles.myname=varName;
mydata = evalin('base',varName);

if isstruct(mydata)
    video=mydata.video;
    mydata=rmfield(mydata,'video');
    setappdata(handles.hfig,'info',mydata);
    set(handles.menu_editmeta,'Enable','on');
else
    video=mydata;
    set(handles.menu_editmeta,'Enable','off');
end    

guidata(hObject, handles);

setup(hObject, eventdata, handles,video);
% Choose default command line output for vPlay_GUI
handles=guidata(hObject);
set(handles.figure1,'Name',['WS var: ' varName ]);
guidata(hObject, handles);
    
  

% --------------------------------------------------------------------
function menu_saveTiff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_saveTiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);

[~,name,~]=fileparts(handles.myname);
[file,path] = uiputfile('*.tif','Save video as tiff',name);
cd(path)
fullpath=fullfile(path,file);

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    mat2tiff(video,info,fullpath);
else
    mat2tiff(video,fullpath);
end



% --------------------------------------------------------------------
function menu_saveWS_Callback(hObject, eventdata, handles)
% hObject    handle to menu_saveWS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isappdata(handles.hfig,'info')
    mydata=getappdata(handles.hfig,'info');
    mydata.video=getappdata(handles.hfig,handles.fname);
else
    mydata=getappdata(handles.hfig,handles.fname);
end

name = inputdlg('Variable name','Save to workspace');
assignin('base',name{1},mydata);


% --------------------------------------------------------------------
function menu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_editmeta_Callback(hObject, eventdata, handles)
% hObject    handle to menu_editmeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
info=getappdata(handles.hfig,'info');
name=get(handles.figure1,'Name');
info_GUI(info,name,handles.hfig);


% --------------------------------------------------------------------
function menu_gen_tiff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gen_tiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanup(hObject, eventdata, handles);
handles=guidata(hObject);

[file,path] = uigetfile('*.tif','Select your TIFF video');
cd(path)
video=single(loadtiff(file));

guidata(hObject, handles);

setup(hObject, eventdata, handles, video);
% Choose default command line output for vPlay_GUI
 %recall handles
handles=guidata(hObject);
set(handles.figure1,'Name',file);
handles.myname=file;

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_asd_tiff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_asd_tiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cleanup(hObject, eventdata, handles);
handles=guidata(hObject);

[file,path] = uigetfile('*.tif','Select your TIFF video');
cd(path)
mydata=loadASDtiff(file);

header=mydata{1};
setappdata(handles.hfig,'info',header);
Ch1=mydata{2};
Ch2=mydata{3};

if ~isempty(Ch2)
     name1=['Ch1 ' file];
     name2=['Ch2 ' file];    
    viewer_GUI(Ch2,name2,header)
else
     name1=file;
end

guidata(hObject, handles);

setup(hObject, eventdata, handles, Ch1);
% Choose default command line output for vPlay_GUI
 %recall handles
handles=guidata(hObject);
set(handles.figure1,'Name',name1);



handles.myname=name1;
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_createmeta_Callback(hObject, eventdata, handles)
% hObject    handle to menu_createmeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isappdata(handles.hfig,'info')
    fake=0;
    info_GUI(fake,get(handles.figure1,'Name'),handles.hfig)
    set(handles.menu_editmeta,'Enable','on');
end


% --------------------------------------------------------------------
function menu_export_Callback(hObject, eventdata, handles)
% hObject    handle to menu_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_frame_png_Callback(hObject, eventdata, handles)
% hObject    handle to menu_frame_png (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cmap=colormap(handles.hfig);
range=caxis(handles.hfig);

video = getappdata(handles.hfig,handles.fname);
frame=handles.frame;
video=video(:,:,frame);


Image=mat2ind(video,range);

[filename,path] = uiputfile('*.png','Save image as png');
filepath=fullfile(path,filename);

imwrite(Image,cmap,filepath,'png','Mode','lossless');

% --------------------------------------------------------------------
function menu_videoexport_Callback(hObject, eventdata, handles)
% hObject    handle to menu_videoexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cmap=colormap(handles.hfig);
range=caxis(handles.hfig);
video = getappdata(handles.hfig,handles.fname);

video=mat2ind(video,range);
videoRGB=zeros(size(video,1), size(video,2), 3, size(video,3));

for k=1:size(video,3)
    videoRGB(:,:,:,k)=ind2rgb(video(:,:,k),cmap);
end

prompt={'Frame per seconds:',...
        'Quality (0-100):'};
name='Video conversion proerties';
numlines=1;
defaultanswer={'30','75'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
a1=str2double(answer{1});
a2=str2double(answer{2});
[filename,path] = uiputfile('*.avi','Save video as tiff');
filepath=fullfile(path,filename);

v = VideoWriter(filepath);
v.FrameRate = a1;
v.Quality=a2;
open(v)
writeVideo(v,videoRGB);
close(v)


% --------------------------------------------------------------------
function menu_export_lut_Callback(hObject, eventdata, handles)
% hObject    handle to menu_export_lut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_lutonly_Callback(hObject, eventdata, handles)
% hObject    handle to menu_lutonly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cmap=colormap(handles.hfig);
range=caxis(handles.hfig);
printCmap(cmap,range);

% --------------------------------------------------------------------
function menu_lutfig_Callback(hObject, eventdata, handles)
% hObject    handle to menu_lutfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=getappdata(handles.hfig,handles.fname);
image=image(:,:,handles.frame);

cmap=colormap(handles.hfig);
range=caxis(handles.hfig);
printCmap(cmap,range,image);


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_avgframe_Callback(hObject, eventdata, handles)
% hObject    handle to menu_avgframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_mavg_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mavg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
video=mavg(video);
filename=get(handles.figure1,'Name');
filename=['mavg ' filename];

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,filename,info)
else    
    viewer_GUI(video,filename)
end


% --------------------------------------------------------------------
function menu_avgpreset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_avgpreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
meanframe=mean(video,3);
video(:,:,end+1)=meanframe;

setup(hObject, eventdata, handles,video)
% --------------------------------------------------------------------
function menu_avg_set_Callback(hObject, eventdata, handles)
% hObject    handle to menu_avg_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
nframe=size(video,3);

defaultValue = {'1', num2str(nframe),num2str(nframe+1)};
titleBar = 'Setup average';
userPrompt = {'Start frame: ','End frame: ','Append: '};
options.WindowStyle='normal';
setUserInput = inputdlg(userPrompt, titleBar, 1, defaultValue,options);
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

meanframe=mean(video(:,:,usersValue(1):usersValue(2)),3);
video(:,:,usersValue(3))=meanframe;

setup(hObject, eventdata, handles,video)


% --------------------------------------------------------------------
function menu_edit2x_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit2x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_edit_del_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
frame=handles.frame;
video(:,:,frame)=[];
setup(hObject, eventdata, handles,video)
handles=guidata(hObject);

if frame>size(video,3)
    frame=size(video,3);
    handles.frame=frame;
end

handles.frame=frame;
set(handles.slider1,'Value',frame);
guidata(hObject, handles);
handles=guidata(hObject);

displayI(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menu_duplicateall_Callback(hObject, eventdata, handles)
% hObject    handle to menu_duplicateall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
filename=get(handles.figure1,'Name');
filename=['copy ' filename];

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,filename,info)
else
    viewer_GUI(video,filename)
end

% --------------------------------------------------------------------
function menu_duplicatesele_Callback(hObject, eventdata, handles)
% hObject    handle to menu_duplicatesele (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
filename=get(handles.figure1,'Name');
filename=['copy ' filename];

%make the selection
nframe=size(video,3);

defaultValue = {'1', num2str(nframe)};
titleBar = 'Setup frame selection';
userPrompt = {'Start frame: ','End frame: '};
options.WindowStyle='normal';
setUserInput = inputdlg(userPrompt, titleBar, 1, defaultValue,options);
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

video=video(:,:,usersValue(1):usersValue(2));


if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,filename,info)
else
    viewer_GUI(video,filename)
end


% --------------------------------------------------------------------
function menu_rename_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.figure1,'Name');


titleBar = 'Rename file';
userValue = inputdlg('New file name', titleBar, 1, {filename});
set(handles.figure1,'Name',userValue{1})


% --------------------------------------------------------------------
function menu_edit_concat_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_concat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
testsize=[size(video,1) size(video,2)];
hviewers=findall(0,'Tag','figure1');
size_hview=numel(hviewers);
count=0;

for k=1:size_hview
    myhandles=guidata(hviewers(k));
    if isfield(myhandles,'hfig')
        appdata=getappdata(myhandles.hfig);
        channels={'Ch1','Ch2'};
        myvideo=isfield(appdata,channels);
        pos=find(myvideo);
        if ~isempty(pos)
            getsize=[size(appdata.(channels{pos}),1) size(appdata.(channels{pos}),2)];
            if getsize==testsize
                count=count+1;
                mylistname{count}=get(hviewers(k),'Name');
                mylisthandle(count)=myhandles.hfig;
            end
        end
    end
end

choice=listboxchoice(mylistname);

if ~isempty(choice)
    appdatav=getappdata(mylisthandle(choice));
    
    myvideov=isfield(appdatav,channels);
    posv=find(myvideov);
    video2=appdatav.(channels{posv});
    
    %specify where to cat
    frame=handles.frame;
    defaultValue = {num2str(frame)}; 
   
    options.WindowStyle='normal';
    setUserInput = inputdlg('Insert at frame: ', 'Setup frame selection',...
        1, defaultValue,options);
    if isempty(setUserInput),return,end; % Bail out if they clicked Cancel.
    % Convert to floating point from string.
    usersValue = str2double(setUserInput);
    defaultValue=str2double(defaultValue);
    
    test=isnan(usersValue);
    % Check for a valid integer.
    if test
        usersValue(test) = defaultValue(test);
        message = 'One ore more value inserted were inappropriate and replaced';
        uiwait(warndlg(message));
    end
    
    video=cat(3,video(:,:,1:usersValue(1)),video2,video(:,:,usersValue(1)+1:end));
    
    clearvars -except video hObject
    handles=guidata(hObject);
    
    if isappdata(handles.hfig,'info')
        info=getappdata(handles.hfig,'info');
        viewer_GUI(video,'concatenated video',info)
    else
        viewer_GUI(video,'concatenated video')
    end
end


        


% --------------------------------------------------------------------
function menu_editadd0_Callback(hObject, eventdata, handles)
% hObject    handle to menu_editadd0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
framesize=[size(video,1) size(video,2)];
frame=handles.frame;
blank=zeros(framesize);

if frame<size(video,3)
    video=cat(3,video(:,:,1:frame),blank,video(:,:,frame+1:end));
elseif frame==size(video,3)
    video(:,:,end+1)=blank;
end

setup(hObject, eventdata, handles, video)


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_auto_ON_Callback(hObject, eventdata, handles)
% hObject    handle to menu_auto_ON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_auto_OFF,'Checked','off')
set(handles.menu_contrast,'Enable','off')
set(hObject,'Checked','on')
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_auto_OFF_Callback(hObject, eventdata, handles)
% hObject    handle to menu_auto_OFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_auto_ON,'Checked','off')
set(hObject,'Checked','on')
set(handles.menu_contrast,'Enable','on')
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_edit_tag_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
nframe=size(video,3);
textdeleted=zeros(20,size(video,2),nframe);

for j=1:nframe
    textdeleted(:,:,j)=rgb2gray(Other_MEM_Text2Im(['f' num2str(j)],size(video,2),20,[1 1 1]));    
end

textdeleted(textdeleted==0) = min(min(min(video)));
textdeleted(textdeleted==1) = max(max(max(video)));

video=cat(1,video,textdeleted);
setup(hObject, eventdata, handles, video)


% --------------------------------------------------------------------
function edit_crop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_crop_drag_Callback(hObject, eventdata, handles)
% hObject    handle to menu_crop_drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);

haxis=handles.hfig;
h= imrect(haxis);
addNewPositionCallback(h,@(p) title(mat2str(p,3),'Color','w'));
%constrain to the axis movement
fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
setPositionConstraintFcn(h,fcn); 

position = wait(h);
delete(h); 

test=cut(video,[position(1) position(2) round(position(3)) round(position(4))]) ;
video=test;

%delete all text
title(handles.hfig,'');

%display in new window
if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,['crop ' get(handles.figure1,'Name')],info)
else
    viewer_GUI(video,['crop ' get(handles.figure1,'Name')])
end

% --------------------------------------------------------------------
function menu_crop_xy_Callback(hObject, eventdata, handles)
% hObject    handle to menu_crop_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
frame=video(:,:,1);

haxis=handles.hfig;

    defaultValue = {num2str(size(frame,1)/2), num2str(size(frame,2)/2)}; 
   
    options.WindowStyle='normal';
    setUserInput = inputdlg({'X dim: ','Y dim: '}, 'Setup crop',...
        1, defaultValue,options);
    if isempty(setUserInput),return,end; % Bail out if they clicked Cancel.
    % Convert to floating point from string.
    usersValue = str2double(setUserInput);
    defaultValue=str2double(defaultValue);
    
    test=isnan(usersValue);
    % Check for a valid integer.
    if test
        usersValue(test) = defaultValue(test);
        message = 'One ore more value inserted were inappropriate and replaced';
        uiwait(warndlg(message));
    end





h= imrect(haxis,[1 1 usersValue(1) usersValue(2)]);
setResizable(h,false);
addNewPositionCallback(h,@(p) title(mat2str(p,3),'Color','w'));
%constrain to the axis movement
fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
setPositionConstraintFcn(h,fcn); 

position = wait(h);
delete(h); 

test=cut(video,[position(1) position(2) round(position(3)) round(position(4))]) ;
video=test;

%delete all text
title(handles.hfig,'');

%display in new window
if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,['crop ' get(handles.figure1,'Name')],info)
else
    viewer_GUI(video,['crop ' get(handles.figure1,'Name')])
end


% --------------------------------------------------------------------
function menu_manuali_Callback(hObject, eventdata, handles)
% hObject    handle to menu_manuali (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
cmap=colormap(handles.hfig);
range=caxis(handles.hfig);
video=correctDrift(video,cmap,range);

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,['aligned ' get(handles.figure1,'Name')],info)
else
    viewer_GUI(video,['aligned ' get(handles.figure1,'Name')])
end


% --------------------------------------------------------------------
function menu_minicanvas_Callback(hObject, eventdata, handles)
% hObject    handle to menu_minicanvas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
video=videoUnion(video);

setup(hObject, eventdata, handles,video)
handles=guidata(hObject);
displayI(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menu_gfilter_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
range=caxis(handles.hfig);
start=handles.frame;
cmap=colormap(handles.hfig);

video = gaussfGUI(start,video,range,cmap);

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video,['filtered ' get(handles.figure1,'Name')],info)
else
    viewer_GUI(video,['filtered ' get(handles.figure1,'Name')])
end


% --------------------------------------------------------------------
function menu_newviewer_Callback(hObject, eventdata, handles)
% hObject    handle to menu_newviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
viewer_GUI


% --------------------------------------------------------------------
function menu_alignment_Callback(hObject, eventdata, handles)
% hObject    handle to menu_alignment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_load_ali_Callback(hObject, eventdata, handles)
% hObject    handle to menu_load_ali (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
drift=XYtable(size(video,3));
video2=addDriftJ(drift,video);

if isappdata(handles.hfig,'info')
    info=getappdata(handles.hfig,'info');
    viewer_GUI(video2,['aligned ' get(handles.figure1,'Name')],info)
else
    viewer_GUI(video2,['aligned ' get(handles.figure1,'Name')])
end


% --------------------------------------------------------------------
function menu_extra_ali_Callback(hObject, eventdata, handles)
% hObject    handle to menu_extra_ali (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
findXYvideo(video);


% --------------------------------------------------------------------
function menu_general_plugins_Callback(hObject, eventdata, handles)
% hObject    handle to menu_general_plugins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
% function menu_surfalt_Callback(hObject, eventdata, handles)
% % hObject    handle to menu_surfalt (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% name=get(handles.figure1,'Name');
% video=getappdata(handles.hfig,handles.fname);
% surFlat(video,name,handles.figure1)


% --------------------------------------------------------------------
function uitoggletool_angle_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
angle_status=get(hObject,'State');
if strcmp(angle_status,'on')
    handles.myangle=my_angle_tool(handles.hfig);
   
else
    if isfield(handles,'myangle')
        delete(handles.myangle)
        title(handles.hfig,'')
    end
end

htitle=get(handles.hfig,'title');
guidata(hObject, handles);
set(htitle,'Color','w')


% --------------------------------------------------------------------
function menu_norm_trimmed_Callback(hObject, eventdata, handles)
% hObject    handle to menu_norm_trimmed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
video=vnorm(video);
setappdata(handles.hfig,handles.fname,video);

%reset contrast and refresh image
data=video(:,:,handles.frame);
clear video
handles.range=[min(data(:)) max(data(:))];

if isfield(handles, 'himage')==1
    ax1=handles.axes1;
    range=handles.range;
    handles.himage=showImage(ax1,data,range);
end

displayI(hObject, eventdata, handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_norm_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to menu_norm_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(handles.hfig,handles.fname);
video=vnorm(video,1);
setappdata(handles.hfig,handles.fname,video);

%reset contrast and refresh image
data=video(:,:,handles.frame);
clear video
handles.range=[min(data(:)) max(data(:))];

if isfield(handles, 'himage')==1
    ax1=handles.axes1;
    range=handles.range;
    handles.himage=showImage(ax1,data,range);
end

displayI(hObject, eventdata, handles);

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_load_trajectory_Callback(hObject, eventdata, handles)
% hObject    handle to menu_load_trajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


varName=readWS;
handles.myname=varName;
mydata = evalin('base',varName);

video=getappdata(handles.hfig,handles.fname);

if size(video,3)~=size(mydata,3)
    warndlg('number of frames not corresponding','Process aborted!')
    return
end

handles.trajectories=mydata;  

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_display_trajectory_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display_trajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag=get(hObject,'Checked'); 

if strcmp(flag,'off')
    set(hObject,'Checked','on');
    traj=handles.trajectories;
    traj=traj(:,:,handles.frame);
        hold on        
        handles.htraj=plot(handles.axes1,traj(:,1),traj(:,2), 'r+', 'MarkerSize', 12, 'LineWidth', 2);
        hold off
else
    set(hObject,'Checked','off');
    
    if isfield(handles,'htraj')
        delete(handles.htraj)
    end
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_traj_number_Callback(hObject, eventdata, handles)
% hObject    handle to menu_traj_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag=get(hObject,'Checked'); 

if strcmp(flag,'off')
    set(hObject,'Checked','on');

    traj=handles.trajectories;
    traj=traj(:,:,handles.frame);
    
    for k=1:size(traj,1)
        txtPart=sprintf('%g',k);
        
        if traj(k,1)&&traj(k,2)==0
            continue
        end
        
        hold on
        handles.text(k)=text(handles.axes1,traj(k,1)-5, traj(k,2)-5,txtPart,'FontSize', 7,'color','g','FontWeight','bold');        
        hold off
    end
    

else 
    set(hObject,'Checked','off');
    
    if isfield(handles,'text')
        delete(handles.text)
    end
end

guidata(hObject, handles);

 


% --------------------------------------------------------------------
function menu_display_Callback(hObject, eventdata, handles)
% hObject    handle to menu_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
