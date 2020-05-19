function varargout = surFlat(varargin)
% SURFLAT MATLAB code for surFlat.fig
%      SURFLAT, by itself, creates a new SURFLAT or raises the existing
%      singleton*.
%
%      H = SURFLAT returns the handle to a new SURFLAT or the handle to
%      the existing singleton*.
%
%      SURFLAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURFLAT.M with the given input arguments.
%
%      SURFLAT('Property','Value',...) creates a new SURFLAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before surFlat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to surFlat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help surFlat

% Last Modified by GUIDE v2.5 08-Apr-2019 15:23:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @surFlat_OpeningFcn, ...
                   'gui_OutputFcn',  @surFlat_OutputFcn, ...
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


% --- Executes just before surFlat is made visible.
function surFlat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to surFlat (see VARARGIN)
ax1=handles.axes1;

 set(ax1,'YTickLabel',[])
 set(ax1,'XTickLabel',[])

 ax2=handles.axes2;
                                        

guidata(hObject, handles);

% UIWAIT makes surFlat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


 set(ax2,'YTickLabel',[])
 set(ax2,'XTickLabel',[])
 
% Choose default command line output for surFlat
handles.output = hObject;
handles.tabManager = TabManager( hObject );
% Update handles structure

if ~isfield(handles,'hListener')
    handles.sliderListener = addlistener(handles.slider1,'ContinuousValueChange', ...
                                      @(hObject, event) slider1test(...
                                      hObject, eventdata));
end

handles.sens=10;
handles.ksize=17;
handles.unders=0.5;
handles.mindata=10;

if nargin > 4
    video=varargin{1};
    handles.path=pwd;
    filtered=video;
    save('temp.mat','video','filtered');
    clear filtered
    
    setappdata(0,'MySubtrVideo',video);
    setappdata(0,'original',video);   %video for backup
    clear video
    
    if isfield(handles, 'flagsubtr')==1
        handles.flagsubtr=0;
    end
end

switch nargin
    case 3
        
    case 4
        
    case 6
        handles.phandle=varargin{3};        
        figname=varargin{2};
        set(handles.figure1, 'Name', ['Flattening ' figname]);
    case 5
        figname=varargin{2};
        set(handles.figure1, 'Name', ['Flattening ' figname]);
end

set_up(hObject, eventdata, handles);
% Choose default command line output for vplayer_GUI
handles = guidata(hObject); %recall handles

%axes(handles.axes1);
displayI(hObject, eventdata, handles);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = surFlat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

if (isfield(handles,'closeFigure') && handles.closeFigure)
    figure1_CloseRequestFcn(hObject, eventdata, handles)
end


function slider1test(hObject, eventdata, handles)
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
displayI(hObject, eventdata, handles);
handles = guidata(hObject);

guidata(hObject,handles);

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
function sli1(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%handles = guidata(hObject);



% --------------------------------------------------------------------
function Open_general_Callback(hObject, eventdata, handles)
% hObject    handle to Open_general (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_tiff_Callback(hObject, eventdata, handles)
% hObject    handle to load_tiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.tif','Select your TIFF video');
cd(path)
video=single(loadtiff(file));
handles.path=path;
filtered=video;
save('temp.mat','video','filtered');
clear filtered

setappdata(0,'MySubtrVideo',video);
setappdata(0,'original',video);   %video for backup
clear video

if isfield(handles, 'flagsubtr')==1
    handles.flagsubtr=0;
end

set_up(hObject, eventdata, handles);
% Choose default command line output for vplayer_GUI
handles = guidata(hObject); %recall handles

%axes(handles.axes1);
displayI(hObject, eventdata, handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function load_asd_Callback(hObject, eventdata, handles)
% hObject    handle to load_asd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.asd','Select your .asd video');
cd(path)
handles.path=path;
fullFileName = fullfile(path, file);
video =loadASD(fullFileName);
filtered=video;
save('temp.mat','video','filtered');
clear filtered

setappdata(0,'MySubtrVideo',video);
setappdata(0,'original',video);   %video for backup
clear video

if isfield(handles, 'flagsubtr')==1
    handles.flagsubtr=0;
end

set_up(hObject, eventdata, handles);
% Choose default command line output for vplayer_GUI

handles = guidata(hObject); %recall handles
guidata(hObject, handles);
%axes(handles.axes1);
displayI(hObject, eventdata, handles);



function displayI(hObject, eventdata, handles)

frame=handles.frame;

video = getappdata(0,'original');

data=video(:,:,frame);
clear video;

if isfield(handles, 'himage')==0
    ax1=handles.axes1;
    range=handles.range;
    handles.himage=showImage(ax1,data,range);
else
    set(handles.himage,'CData',data)
end


if isfield(handles, 'flagsubtr')==1 && handles.flagsubtr==1
    
    video = getappdata(0,'MySubtrVideo');
    data2=video(:,:,frame);
    clear video;
    
    if isfield(handles, 'himage2')==0
        ax2=handles.axes2;
        range2=handles.range2;
        handles.himage2=showImage(ax2,data2,range2);
    else
        set(handles.himage2,'CData',data2)
    end
end

set(handles.edit_frame,'String',frame);
guidata(hObject, handles);


    function himage=showImage(where,data,range)
                           
           himage=imagesc(data,'parent',where,range);      
        
        axis(where,'image')
        axis(where,'off')
  %      impixelinfo is slowing a lot the displaying      
  %      impixelinfo(himage);
    



function set_up(hObject, eventdata, handles)

    %clear everything was drawn before
reset_Callback(hObject, eventdata, handles)    
handles=guidata(hObject);

video = getappdata(0,'original');
frame=1;
handles.frame=frame;
nFrame=size(video,3);
handles.nFrame=nFrame;
ysize=size(video,1);
xsize=size(video,2);
data=video(:,:,frame);
data=data(:);
range=[min(data) max(data)];
handles.range=range;
textLabel = sprintf('/%g', nFrame);
set(handles.text2,'String',textLabel);

[xx,yy] = meshgrid(1:1:xsize, 1:1:ysize); %meshgrid for surface fitting
handles.xx=xx; handles.yy=yy;
[sxx,syy] = meshgrid(1:10:xsize, 1:10:ysize);
handles.sxx=sxx; handles.syy=syy;

%setup frame sliders
set(handles.slider1, ...
    'Value',1, ...
    'max',nFrame, ...
    'min',1, ...
    'sliderstep',[1 1]/nFrame);
% if ~isfield(handles,'hListener')
%     handles.sliderListener = addlistener(handles.slider1,'ContinuousValueChange', ...
%                                       @(hObject, event) sli1(...
%                                         hObject, eventdata, handles));
% end
colormap gray
guidata(hObject, handles);


% --------------------------------------------------------------------
function tools_general_Callback(hObject, eventdata, handles)
% hObject    handle to tools_general (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function bright_all_Callback(hObject, eventdata, handles)
% hObject    handle to bright_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
video=vnorm(video);
setappdata(0,'original',video);
frame=handles.frame;
data=video(:,:,frame);
handles.range=[min(min(data)) max(max(data))];

if isfield(handles,'himage')
    handles = rmfield(handles,'himage');
end

guidata(hObject, handles);
handles=guidata(hObject);
displayI(hObject, eventdata, handles)
% --------------------------------------------------------------------
function bright_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to bright_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
video=vnorm(video,1);
setappdata(0,'original',video);
frame=handles.frame;
data=video(:,:,frame);
handles.range=[min(min(data)) max(max(data))];
handles = rmfield(handles,'himage');
guidata(hObject, handles);
handles=guidata(hObject);
displayI(hObject, eventdata, handles)

% --- Executes on button press in player.
function player_Callback(hObject, eventdata, handles)
% hObject    handle to player (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of player
player=get(hObject,'Value');
sliderValue=handles.frame;
fps=str2double(get(handles.edit_fps,'String'));

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



function edit_fps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fps as text
%        str2double(get(hObject,'String')) returns contents of edit_fps as a double


% --- Executes during object creation, after setting all properties.
function edit_fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stdevF(hObject, eventdata, handles, video)

nFrame=handles.nFrame;

video=reshape(video,[],nFrame);
stdF=std(video);
stdF(isnan(stdF))=-1;
stdF(stdF==0)=-1;

handles.stdF=stdF;
handles.meanStd=median(stdF);
guidata(hObject, handles);

if numel(stdF)<67
    TF = isoutlier(stdF,'gesd');
else
    TF = isoutlier(stdF,'movmedian',33,'ThresholdFactor',5);
end


if any(TF)
    k=sum(TF);
    string=sprintf('%d Outlier detected!!',k);
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
    figure
    x=1:nFrame;
    plot(x,stdF,x(TF),stdF(TF),'x')
    xlabel('frame #')
    ylabel('standard deviation')
end

guidata(hObject, handles);

% --- Executes on button press in push_plotStd1.
function push_plotStd1_Callback(hObject, eventdata, handles)
% hObject    handle to push_plotStd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
stdevF(hObject, eventdata, handles, video);
handles = guidata(hObject);
medStd=handles.meanStd;
textLabel = num2str(medStd);
set(handles.text_med1,'String',textLabel);
set(handles.text_sigma1,'String','NaN');
axes(handles.axes3);
histogram(handles.stdF);
set(handles.axes3,'FontSize',6);



% --- Executes on button press in push_plotStd2.
function push_plotStd2_Callback(hObject, eventdata, handles)
% hObject    handle to push_plotStd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'flagsubtr')==1 && handles.flagsubtr==1
    
    video=getappdata(0,'MySubtrVideo');
    stdevF(hObject, eventdata, handles, video);
    handles = guidata(hObject);
    medStd=handles.meanStd;
    textLabel = num2str(medStd);
    set(handles.text_sigma2,'String','NaN');
    set(handles.text_med2,'String',textLabel);
    axes(handles.axes4);
    histogram(handles.stdF);
    set(handles.axes4,'FontSize',6);
    
end

% --------------------------------------------------------------------
function del_outlier_Callback(hObject, eventdata, handles)
% hObject    handle to del_outlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nFrame=handles.nFrame;
video=getappdata(0,'original');

count=1;
deletedF=[];


video2=reshape(video,[],nFrame);
stdF=std(video2);

clear video2

stdF(isnan(stdF))=-1;
stdF(stdF==0)=-1;

if numel(stdF)<67
    TF = isoutlier(stdF,'gesd');
else
    TF = isoutlier(stdF,'movmedian',33,'ThresholdFactor',5);
end

k= find(TF);

if any(k)==0
    return
end

for j=1:numel(k)
    textdeleted(:,:,j)=rgb2gray(Other_MEM_Text2Im(num2str(k(j)),60,20,[1 1 1]));    
end

deletedF=cat(3,deletedF, video(:,:,k));

video(:,:,k)=[];

deletedF=mat2gray(deletedF);
deletedF(end-19:end,end-59:end,:)=textdeleted;

if not(isempty(deletedF))
    deletedF=permute(deletedF,[1 2 4 3]);
    h=figure('Name','Deleted Frames','NumberTitle','off');
    montage(deletedF)
    imcontrast(h)
end

setappdata(0,'original',video);
guidata(hObject, handles);

%reset everything

set_up(hObject, eventdata, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset')
if isfield(handles, 'himage')
    handles = rmfield(handles,'himage');
end

cla(handles.axes2,'reset')
if isfield(handles, 'himage2')
    handles = rmfield(handles,'himage2');
end

guidata(hObject, handles);

% --- Executes on button press in push_SeleMarker.
function push_SeleMarker_Callback(hObject, eventdata, handles)
% hObject    handle to push_SeleMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load the data
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'filtered');
frame=handles.frame;

image=filtered(:,:,frame);
clear filtered
n=str2double(get(handles.edit_nMark,'String'));

axes(handles.axes1);
[x y]=ginput(n);
nameRp='Coordinate xyz';

for k=1:size(x)
    z(k)=image(round(y(k)),round(x(k)));
    P(k,:)=[round(x(k)) round(y(k)) z(k)];
    nameR(:) = [nameRp '_' num2str(k,'%02d')];
    disp(nameR)
    disp(P(k,:))
end
 
handles.sele=P;
guidata(hObject, handles);


function push_ClearAx_Callback(hObject, eventdata, handles)
% hObject    handle to push_ClearAx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of push_ClearAx as text
%        str2double(get(hObject,'String')) returns contents of push_ClearAx as a double
p = findobj('Type', 'line');
delete(p);

if isfield(handles, 'sele')
    handles = rmfield(handles,'sele');
    
    set(handles.toggle_displayMark,'String','Show','BackgroundColor','w','Value',0)
end
guidata(hObject, handles);


function edit_nMark_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nMark as text
%        str2double(get(hObject,'String')) returns contents of edit_nMark as a double


% --- Executes during object creation, after setting all properties.
function edit_nMark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in toggle_displayMark.
function toggle_displayMark_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_displayMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_displayMark
status=get(hObject,'Value');

if status && isfield(handles, 'sele')

        set(handles.toggle_displayMark,'String','Showing','BackgroundColor','g')
        P=handles.sele;
        hold on
        axes(handles.axes1);
        plot(P(:,1),P(:,2), 'r+', 'MarkerSize', 20, 'LineWidth', 2);
        hold off
    
elseif status==0 && isfield(handles, 'sele')
   
        set(handles.toggle_displayMark,'String','Hidden','BackgroundColor','r')
        axes(handles.axes1);
        p = findobj(gca,'Type', 'line');
        delete(p);
    
end
        guidata(hObject, handles);

% --- Executes on button press in push_current.
function push_current_Callback(hObject, eventdata, handles)
% hObject    handle to push_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabMan = handles.tabManager;
method=get(tabMan.Handles.TabA.SelectedTab,'title');
video=getappdata(0,'original');
vbck=single(zeros(size(video)));
fullFileName = fullfile(handles.path,'temp.mat');
fullFileName2 = fullfile(handles.path,'temp2.mat');

flag2=get(handles.check_saveBG,'Value');
flag3=get(handles.check_overwrite,'Value');

frame=round(get(handles.slider1,'Value'));

switch method
    
    case '2D morp'
        try
            SE=handles.SE;
        catch
            string='SE not defined. Aborting operation!!';
            h=warndlg(string,'!! Warning !!');
            waitfor(h);
            return
        end
        vbck(:,:,frame)=imopen(video(:,:,frame),SE);
        vbck(:,:,frame)=gaussian2d(vbck(:,:,frame),7,3);
        
        video=video-vbck;
              
    case '2D fit'
        
        %get the needed variables
        if get(handles.check_mask,'Value')
            load(fullFileName,'masked');
            filtered=masked;
            clear masked
        else
            load(fullFileName,'filtered');
            P=handles.sele;
        end
        count=1;
        wb=waitbar(0,'computing....');
        
        for k=start:stop
            
            timage=filtered(:,:,k);
            
            if get(handles.check_mask,'Value')
                clear P
                [P(:,2), P(:,1), P(:,3)]=find(timage);
                
                if length(P)>1000
                    nsub=round(length(P)/1000);
                    P=P(1:nsub:end,:);
                    
                end
                
            else
                for i=1:size(P,1)
                    P(i,3)=timage(P(i,2),P(i,1));
                end
            end
            
            
            handles.sele=P;
            
            guidata(hObject, handles);
            handles = guidata(hObject);
            
            if get(handles.radio_linear,'Value') == 1
                linearFit(hObject, eventdata, handles);
            end
            
            if get(handles.radio_2ndor,'Value') == 1
                ord2ndFit(hObject, eventdata, handles)
            end
            
            handles = guidata(hObject);
            
            vbck(:,:,k)=handles.background;
            
            
            dataa=diag(timage(P(:,2),P(:,1)));
            datab=diag(handles.background(P(:,2),P(:,1)));
            error(count)=immse(dataa,datab);
            count=count+1;
            waitbar(k/(stop-start));
        end
        
        close(wb)
        
        video=video-vbck;
        error=mean(error);
        
        if flag3
            filtered=filtered-vbck;
            save(fullFileName,'filtered','-append');
        end
        
        clear filtered
        guidata(hObject, handles);
        set(handles.text_MSE,'String',num2str(error));
        
        case '1D polish'
            
            if get(handles.check_ax1c,'Value')
                range=caxis(handles.axes1);
                lvid=video>range(1)&video<range(2);
                nanvideo=video;
                nanvideo(lvid==0)=NaN;
                clear lvid
            else
                load(fullFileName,'masked');
                masked(masked==0)=NaN;
                nanvideo=masked;
                clear masked
            end
            
            if get(handles.radio_X,'Value')
                
                smean2d=nanmedian(nanvideo,2);
                nn = isnan(smean2d);
                n= nanmean(smean2d);
                z=nn.*n;
                smean2d(nn)=z(nn);
                video=video-smean2d;              
                
                clear z nn n
                
            elseif get(handles.radio_Y,'Value')
                                
                smean2d=nanmedian(nanvideo);
                nn = isnan(smean2d);
                n= nanmean(smean2d);
                z=nn.*n;
                smean2d(nn)=z(nn);
                video=video-smean2d;
                
                clear z nn n
                
            else
                
                tol=str2double(get(handles.edit_tolerance,'String'));
                maxIter=str2double(get(handles.edit_maxIter,'String'));
                wb = waitbar(0,'computing...');
                
                for k=start:stop
                
                [~, re(:,:,k), ce(:,:,k)]=median_polish(nanvideo(:,:,k),tol,maxIter);
                waitbar(k/(stop-start));
                
                end
                
                close(wb)
                smean2d=re+ce;
                clear re ce
                
                nn = isnan(smean2d);
                n= nanmean(smean2d);
                z=nn.*n;
                smean2d(nn)=z(nn);
                clear z nn n
                
                video=video-smean2d;
                
            end
end

setappdata(0,'MySubtrVideo',video);

if flag2
    save(fullFileName2,'vbck');
end

clear vbck



handles.flagsubtr=1;
handles.range2=handles.range;

guidata(hObject, handles);
handles=guidata(hObject);

displayI(hObject, eventdata, handles);

% --- Executes on button press in push_All.
function push_All_Callback(hObject, eventdata, handles)
% hObject    handle to push_All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabMan = handles.tabManager;
method=get(tabMan.Handles.TabA.SelectedTab,'title');
video=getappdata(0,'original');
vbck=single(zeros(size(video)));
fullFileName = fullfile(handles.path,'temp.mat');
fullFileName2 = fullfile(handles.path,'temp2.mat');

flag=get(handles.check_int,'Value');
flag2=get(handles.check_saveBG,'Value');
flag3=get(handles.check_overwrite,'Value');

if flag==1
    prompt={'first frame',...
        'last frame'};
    name='frame selection';
    numlines=1;
    
    defaultanswer={'1',num2str(size(video,3))};
    
    options.Resize='on';
    options.WindowStyle='normal';
    
    answer=str2double(inputdlg(prompt,name,numlines,defaultanswer,options));
    start=answer(1,1);
    stop=answer(2,1);
    
else
    start=1;
    stop=size(video,3);
end

switch method
    
    case '2D morp'
        try
            SE=handles.SE;
        catch
            string='SE not defined. Aborting operation!!';
            h=warndlg(string,'!! Warning !!');
            waitfor(h);
            return
        end
        vbck(:,:,start:stop)=imopen(video(:,:,start:stop),SE);
        vbck(:,:,start:stop)=gaussian2d(vbck(:,:,start:stop),7,3);
        
        video=video-vbck;
              
    case '2D fit'
        
        %get the needed variables
        if get(handles.check_mask,'Value')
            load(fullFileName,'masked');
            filtered=masked;
            
            filtered=single(filtered.*video);
            clear masked
        else
            load(fullFileName,'filtered');
            P=handles.sele;
        end
        count=1;
        wb=waitbar(0,'computing....');
        
        for k=start:stop
            
            timage=filtered(:,:,k);
            
            if get(handles.check_mask,'Value')
                clear P
                [P(:,2), P(:,1), P(:,3)]=find(timage);
                
                if length(P)>1000
                    nsub=round(length(P)/1000);
                    P=P(1:nsub:end,:);
                    
                end
                
            else
                for i=1:size(P,1)
                    P(i,3)=timage(P(i,2),P(i,1));
                end
            end
            
            
            handles.sele=P;
            
            guidata(hObject, handles);
            handles = guidata(hObject);
            
            if get(handles.radio_linear,'Value') == 1
                linearFit(hObject, eventdata, handles);
            end
            
            if get(handles.radio_2ndor,'Value') == 1
                ord2ndFit(hObject, eventdata, handles)
            end
            
            handles = guidata(hObject);
            
            vbck(:,:,k)=handles.background;
            
            
            dataa=diag(timage(P(:,2),P(:,1)));
            datab=diag(handles.background(P(:,2),P(:,1)));
            error(count)=immse(dataa,datab);
            count=count+1;
            waitbar(k/(stop-start));
        end
        
        close(wb)
        
        video=video-vbck;
        error=mean(error);
        
        if flag3
            filtered=filtered-vbck;
            save(fullFileName,'filtered','-append');
        end
        
        clear filtered
        guidata(hObject, handles);
        set(handles.text_MSE,'String',num2str(error));
        
        case '1D polish'
            
            xmin=handles.mindata;
            ymin=handles.mindata;
            
            %upload or create a logical mask and the data
            
            if get(handles.check_ax1c,'Value')
                range=caxis(handles.axes1);
                masked=video>range(1)&video<range(2);
                nanvideo=video;
                
            else
                load(fullFileName,'masked');
                nanvideo=single(masked.*video);
                
            end
            
            %remove lines with poor statistic
            
            if get(handles.radio_X,'Value')
                xlog=sum(masked,2); xlog=xlog>xmin;
                masked=masked.*xlog;
                
            elseif get(handles.radio_Y,'Value')
                ylog=sum(masked); ylog=ylog>ymin;
                masked=masked.*ylog;
                
            else
                xlog=sum(masked,2); xlog=xlog>xmin;
                ylog=sum(masked); ylog=ylog>ymin;
                masked=masked.*ylog.*xlog;
            end
                        
            nanvideo(masked==0)=NaN;
            clear masked xlog ylog
            
            %calculation
            
            if get(handles.radio_X,'Value')
                
                smean2d=nanmedian(nanvideo,2);
                nn = isnan(smean2d);
                n= nanmean(smean2d);
                z=nn.*n;
                smean2d(nn)=z(nn);
                video(:,:,start:stop)=video(:,:,start:stop)-smean2d(:,:,start:stop);              
                
                clear z nn n
                
            elseif get(handles.radio_Y,'Value')
                                
                smean2d=nanmedian(nanvideo);
                nn = isnan(smean2d);
                n= nanmean(smean2d);
                z=nn.*n;
                smean2d(nn)=z(nn);
                video(:,:,start:stop)=video(:,:,start:stop)-smean2d(:,:,start:stop); 
                
                clear z nn n
                
            else
                
                tol=str2double(get(handles.edit_tolerance,'String'));
                maxIter=str2double(get(handles.edit_maxIter,'String'));
                wb = waitbar(0,'computing...');
                re=single(zeros(size(video))); ce=single(zeros(size(video)));
                
                for k=start:stop
                
                [~, re(:,:,k), ce(:,:,k)]=median_polish(nanvideo(:,:,k),tol,maxIter);
                waitbar(k/(stop-start));
                
                end
                
                close(wb)
                
                %remove NaNs
                
                nn = isnan(re);
                n= nanmean(nanmean(re));
                z=nn.*n;
                re(nn)=z(nn);
                %re(nn)=0;
                nn = isnan(ce);
                n= nanmean(nanmean(ce));
                z=nn.*n;
                ce(nn)=z(nn);
                %ce(nn)=0;
                smean2d=re+ce;
                clear re ce z nn n
                
                video=video-smean2d;
                
            end
end

setappdata(0,'MySubtrVideo',video);

if flag2
    save(fullFileName2,'vbck');
end

clear vbck



handles.flagsubtr=1;
handles.range2=handles.range;

guidata(hObject, handles);
handles=guidata(hObject);

displayI(hObject, eventdata, handles);


% --- Executes on button press in push_SwitchAx.
function push_SwitchAx_Callback(hObject, eventdata, handles)
% hObject    handle to push_SwitchAx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.flagsubtr=0;
video=getappdata(0,'MySubtrVideo');
setappdata(0,'original',video);
% fullFileName = fullfile(handles.path,'temp.mat');
% save(fullFileName,'video','-append');
range=caxis(handles.axes2);
caxis(handles.axes1,range);
handles.range=range;

cla(handles.axes2,'reset')
 set(handles.axes2,'YTickLabel',[])
 set(handles.axes2,'XTickLabel',[])

if isfield(handles, 'himage2')
    handles = rmfield(handles,'himage2');
end 

cla(handles.axes4,'reset')
 set(handles.axes4,'YTickLabel',[])
 set(handles.axes4,'XTickLabel',[])
guidata(hObject, handles);

displayI(hObject, eventdata, handles);

% --- Executes on button press in push_reset.
function push_reset_Callback(hObject, eventdata, handles)
% hObject    handle to push_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.flagsubtr=0;
video=getappdata(0,'MySubtrVideo');
video=zeros(size(video));
setappdata(0,'MySubtrVideo',video);

cla(handles.axes2,'reset')
 set(handles.axes2,'YTickLabel',[])
 set(handles.axes2,'XTickLabel',[])

 if isfield(handles, 'himage2')
     handles = rmfield(handles,'himage2');
 end

cla(handles.axes4,'reset')
 set(handles.axes4,'YTickLabel',[])
 set(handles.axes4,'XTickLabel',[])
guidata(hObject, handles);

% --- Executes on button press in check_int.
function check_int_Callback(hObject, eventdata, handles)
% hObject    handle to check_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_int


% --- Executes on button press in push_SE.
function push_SE_Callback(hObject, eventdata, handles)
% hObject    handle to push_SE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    g=figure('Name','Make your structuring element','NumberTitle','off');
    ax=axes;
    range=handles.range;
    frame=handles.frame;
    video=getappdata(0,'original');
    video=video(:,:,frame);
    imagesc(video,'parent',ax);
    colormap(gray);
    caxis(range);
    axis image  
    h=imrect(ax);
    position = wait(h);
    SE=round(position(3:4));
    SEoption=get(handles.popupmenu1,'Value');
    
    switch SEoption
        
        case 1
            
            struel=strel('rectangle',SE);
            
        case 2
            
            struel=strel('disk',round(max(SE)/2),8);
            
        otherwise
            
            struel=strel('rectangle',SE);
    end
   
    handles.SE=struel;
    guidata(hObject, handles);
    close(g)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function contrast_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(0,'original');
frame=handles.frame;
data=data(:,:,frame);
activeaxes=handles.axes1;
h=gcbo;
rangename='range';
h_contrast_GUI=contrast_GUI(data,h,activeaxes,rangename);
guidata(hObject, handles);

% --------------------------------------------------------------------
function contrast_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(0,'MySubtrVideo');
frame=handles.frame;
data=data(:,:,frame);
activeaxes=handles.axes2;
h=gcbo;
rangename='range2';
h_contrast_GUI=contrast_GUI(data,h,activeaxes,rangename);
guidata(hObject, handles);


% --------------------------------------------------------------------
function contrast_link_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_link (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.range2=handles.range;
caxis(handles.axes2,handles.range);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pixel_i_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_i_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
impixelinfo(handles.axes1)

% --------------------------------------------------------------------
function pixel_i_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_i_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
impixelinfo(handles.axes2)


% --- Executes on button press in push_backg.
function push_backg_Callback(hObject, eventdata, handles)
% hObject    handle to push_backg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp2.mat');
try
    load(fullFileName);
catch
    string='Can not find a background to display!!';
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
    return
end
   
frame=handles.frame;
image=vbck(:,:,frame);
clear vbck
plot3d_GUI(image)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

if isfield(handles, 'path')
    fullFileName = fullfile(handles.path,'temp.mat');
    fullFileName2 = fullfile(handles.path,'temp2.mat');
    delete(fullFileName,fullFileName2)
end

delete(hObject);


% --- Executes on button press in push_blur.
function push_blur_Callback(hObject, eventdata, handles)
% hObject    handle to push_blur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
video=getappdata(0,'original');

frame=handles.frame;
range=caxis(handles.axes1);

filtered=gaussfGUI(frame,video,range);
save(fullFileName,'filtered','-append');


% --------------------------------------------------------------------
function display_general_Callback(hObject, eventdata, handles)
% hObject    handle to display_general (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function axes1_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to axes1_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'video');
setappdata(0,'original',video)

set_up(hObject, eventdata, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles);
guidata(hObject, handles);
% --------------------------------------------------------------------
function filtered_Callback(hObject, eventdata, handles)
% hObject    handle to filtered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'filtered');
setappdata(0,'original',filtered)

set_up(hObject, eventdata, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles)


% --- Executes on button press in push_updateENDsave.
function push_updateENDsave_Callback(hObject, eventdata, handles)
% hObject    handle to push_updateENDsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
fullFileName = fullfile(handles.path,'temp.mat');
save(fullFileName,'video','-append');

%-----!Fitting functions---------------------------------------

function linearFit(hObject, eventdata, handles)        
        
data=handles.sele;
xx=handles.xx; yy=handles.yy; 
 
C = [data(:,1) data(:,2) ones(size(data,1),1)] \ data(:,3); 
handles.background = single(C(1)*xx + C(2)*yy + C(3));
  

guidata(hObject, handles) 

function ord2ndFit(hObject, eventdata, handles)

data=handles.sele;
xx=handles.xx; yy=handles.yy; 

C = x2fx(data(:,1:2), 'purequadratic') \ data(:,3);
background = single(x2fx([xx(:) yy(:)], 'purequadratic') * C);
background = reshape(background, size(xx));
handles.background=background;
  
guidata(hObject, handles)


% --- Executes on button press in check_saveBG.
function check_saveBG_Callback(hObject, eventdata, handles)
% hObject    handle to check_saveBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_saveBG
status=get(hObject,'Value');

if status
    set(handles.push_backg,'Enable','on')
else
    set(handles.push_backg,'Enable','off')
end


% --- Executes on button press in check_overwrite.
function check_overwrite_Callback(hObject, eventdata, handles)
% hObject    handle to check_overwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_overwrite


% --- Executes on button press in push_Imask.
function push_Imask_Callback(hObject, eventdata, handles)
% hObject    handle to push_Imask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
frame=handles.frame;
data=video(:,:,frame);
activeaxes=handles.axes1;
h=gcbo;
rangename='range';
h_contrast_GUI=contrast_GUI(data,h,activeaxes,rangename);
uiwait(h_contrast_GUI);

%recover the range
levels=caxis(handles.axes1);
log1=video>levels(1);
log2=video<levels(2);
masked=log1&log2;

fullFileName = fullfile(handles.path,'temp.mat');
save(fullFileName,'masked','-append');

guidata(hObject, handles);

% --------------------------------------------------------------------
function masked_Callback(hObject, eventdata, handles)
% hObject    handle to masked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'masked');
video=getappdata(0,'original');
masked=single(masked.*video);
setappdata(0,'original',masked)

set_up(hObject, eventdata, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles) 


% --- Executes on button press in check_mask.
function check_mask_Callback(hObject, eventdata, handles)
% hObject    handle to check_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_mask


% --- Executes on button press in check_ax1c.
function check_ax1c_Callback(hObject, eventdata, handles)
% hObject    handle to check_ax1c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_ax1c



function edit_tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tolerance as text
%        str2double(get(hObject,'String')) returns contents of edit_tolerance as a double


% --- Executes during object creation, after setting all properties.
function edit_tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxIter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxIter as text
%        str2double(get(hObject,'String')) returns contents of edit_maxIter as a double


% --- Executes during object creation, after setting all properties.
function edit_maxIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_Smask.
function push_Smask_Callback(hObject, eventdata, handles)
% hObject    handle to push_Smask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
ksize=handles.ksize;
unders=handles.unders;

status=get(handles.auto_Smask,'Checked');
tf=strcmp(status,'on');

if tf
    mask=entropyMask(video,'auto',ksize,unders);
else
    
    mask=entropyMask(video,'sele',ksize,unders);
end

masked=mask;

fullFileName = fullfile(handles.path,'temp.mat');
save(fullFileName,'masked','-append');

guidata(hObject, handles);


% --- Executes on button press in push_plotHist2.
function push_plotHist2_Callback(hObject, eventdata, handles)
% hObject    handle to push_plotHist2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageData=getappdata(0,'MySubtrVideo');
frame=round(get(handles.slider1,'Value'));
imageData=imageData(:,:,frame);

%logical mask end values extraction
datarange=caxis(handles.axes2);
imageLog=imageData>datarange(1)&imageData<datarange(2);
dataset=imageData(imageLog);
%plot and set
axes(handles.axes4);
bins=min([50 ceil(sqrt(numel(dataset)))]);
histogram(dataset,bins);
%xlim([min(dataset) max(dataset)])
set(handles.axes4,'FontSize',6);
guidata(hObject, handles);

% --- Executes on button press in push_plotHist1.
function push_plotHist1_Callback(hObject, eventdata, handles)
% hObject    handle to push_plotHist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%extract the data
imageData=getappdata(0,'original');
frame=round(get(handles.slider1,'Value'));
imageData=imageData(:,:,frame);

%logical mask end values extraction
datarange=caxis(handles.axes1);
imageLog=imageData>datarange(1)&imageData<datarange(2);
dataset=imageData(imageLog);
%plot and set
axes(handles.axes3);
bins=min([50 ceil(sqrt(numel(dataset)))]);
histogram(dataset,bins);
%xlim([min(dataset) max(dataset)])
set(handles.axes3,'FontSize',6);
guidata(hObject, handles);

% --- Executes on button press in push_fit1.
function push_fit1_Callback(hObject, eventdata, handles)
% hObject    handle to push_fit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    hist_obj=findobj(handles.axes3,'Type','Histogram');
    
if isempty(hist_obj)
    string='Can not find a histogram to fit!!';
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
    return
end

xdat=double(hist_obj.BinEdges)';
xdat(end)=[];
ydat=double(hist_obj.BinCounts)';

%setup fit
op = fitoptions('gauss1', 'Lower', [0 -Inf 0],'Exclude',ydat==0);
gfit = fit(xdat,ydat,'gauss1',op);

%make up plot
delta=range(xdat)/500;
xhat=min(xdat):delta:max(xdat);
yhat=gfit(xhat);

%extract coefficients
coeff=coeffvalues(gfit);
mu=coeff(2);
sigma=coeff(3);

set(handles.text_med1,'String',num2str(mu));
set(handles.text_sigma1,'String',num2str(sigma));

%draw plot
axes(handles.axes3)
hold on
plot(handles.axes3,xhat,yhat,'r-','LineWidth',2);
hold off


% --- Executes on button press in push_Fit2.
function push_Fit2_Callback(hObject, eventdata, handles)
% hObject    handle to push_Fit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    hist_obj=findobj(handles.axes4,'Type','Histogram');
    
if isempty(hist_obj)
    string='Can not find a histogram to fit!!';
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
    return
end

xdat=double(hist_obj.BinEdges)';
xdat(end)=[];
ydat=double(hist_obj.BinCounts)';

%setup fit
op = fitoptions('gauss1', 'Lower', [0 -Inf 0],'Exclude',ydat==0);
gfit = fit(xdat,ydat,'gauss1',op);

%make up plot
delta=range(xdat)/500;
xhat=min(xdat):delta:max(xdat);
yhat=gfit(xhat);

%extract coefficients
coeff=coeffvalues(gfit);
mu=coeff(2);
sigma=coeff(3);

set(handles.text_med2,'String',num2str(mu));
set(handles.text_sigma2,'String',num2str(sigma));

%draw plot
axes(handles.axes4)
hold on
plot(handles.axes4,xhat,yhat,'r-','LineWidth',2);
hold off


% --------------------------------------------------------------------
function axes2_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to axes2_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function original2_Callback(hObject, eventdata, handles)
% hObject    handle to original2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'video');
setappdata(0,'MySubtrVideo',video)
handles.flagsubtr=1;

frame=round(get(handles.slider1,'Value'));
video=getappdata(0,'MySubtrVideo');
video=video(:,:,frame);
video=video(:);
handles.range2=[min(video) max(video)];
guidata(hObject, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles);
caxis(handles.axes2,handles.range2);
guidata(hObject, handles);

% --------------------------------------------------------------------
function filtered2_Callback(hObject, eventdata, handles)
% hObject    handle to filtered2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'filtered');
setappdata(0,'MySubtrVideo',filtered)
handles.flagsubtr=1;

frame=round(get(handles.slider1,'Value'));
video=getappdata(0,'MySubtrVideo');
video=video(:,:,frame);
video=video(:);
handles.range2=[min(video) max(video)];
guidata(hObject, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles);
caxis(handles.axes2,handles.range2);
guidata(hObject, handles);

% --------------------------------------------------------------------
function masked2_Callback(hObject, eventdata, handles)
% hObject    handle to masked2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullFileName = fullfile(handles.path,'temp.mat');
load(fullFileName,'masked');
setappdata(0,'MySubtrVideo',single(masked))
handles.flagsubtr=1;

frame=round(get(handles.slider1,'Value'));
video=getappdata(0,'MySubtrVideo');
video=video(:,:,frame);
video=video(:);
handles.range2=[min(video) max(video)];
caxis(handles.axes2,handles.range2);
guidata(hObject, handles);
handles = guidata(hObject); %recall handles

displayI(hObject, eventdata, handles);
caxis(handles.axes2,handles.range2);
guidata(hObject, handles);

% --------------------------------------------------------------------
function save_tiff_Callback(hObject, eventdata, handles)
% hObject    handle to save_tiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
mat2tiff(video);


% --------------------------------------------------------------------
function mode_Smask_Callback(hObject, eventdata, handles)
% hObject    handle to mode_Smask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function auto_Smask_Callback(hObject, eventdata, handles)
% hObject    handle to auto_Smask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status=get(hObject,'Checked');
tf=strcmp(status,'on');
if tf==0
    set(hObject,'Checked','on')
    set(handles.sele_Smask,'Checked','off');
end
% --------------------------------------------------------------------
function sele_Smask_Callback(hObject, eventdata, handles)
% hObject    handle to sele_Smask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status=get(hObject,'Checked');
tf=strcmp(status,'on');
if tf==0
    set(hObject,'Checked','on')
    set(handles.auto_Smask,'Checked','off');      
end


% --- Executes on button press in push_eval.
function push_eval_Callback(hObject, eventdata, handles)
% hObject    handle to push_eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'flagsubtr')==1 && handles.flagsubtr==0
    string='No data displayed in axes 2. Aborting!!';
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
    return
end

video=getappdata(0,'original');
subtr=getappdata(0,'MySubtrVideo');

nframe1=size(video,3); nframe2=size(subtr,3);

%make some checks and handle errors

if not(isequal(nframe1, nframe2))
    string=sprintf('Not matching number of frames! %d VS %d',nframe1,nframe2);
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
end

if isfield(handles, 'flagsubtr')==1 && handles.flagsubtr==0
    string='No data displayed in axes 2. Aborting!!';
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
    return
end

datalim1=caxis(handles.axes1); contrast1=range(datalim1);
datalim2=caxis(handles.axes2); contrast2=range(datalim2);

if not(isequal(contrast1, contrast2))
    string=sprintf('Not matching contrast! %g VS %g',contrast1,contrast2);
    h=warndlg(string,'!! Warning !!');
    waitfor(h);
end

%setup data and fit

op = fitoptions('gauss1', 'Lower', [0 -Inf 0]);

vidLog1=video>datalim1(1)&video<datalim1(2);
vidLog2=subtr>datalim2(1)&subtr<datalim2(2);
wb=waitbar(0,'Computing');
count=1;

sens=handles.sens;

for k=1:sens:nframe1
    tdata1=video(:,:,k); imLog1=vidLog1(:,:,k);
    tdata2=subtr(:,:,k); imLog2=vidLog2(:,:,k);
    
    data1=double(tdata1(imLog1));
    data2=double(tdata2(imLog2));
    
    [count1 bins1]=histcounts(data1,50);
    [count2 bins2]=histcounts(data2,50);
    
    %lets fit it
    op.exclude=count1==0;
    gfit = fit(bins1(1:end-1)',count1','gauss1',op);
    coeff=coeffvalues(gfit);
    sigma1(count)=coeff(3);
    
    op.exclude=count2==0;
    gfit = fit(bins2(1:end-1)',count2','gauss1',op);
    coeff=coeffvalues(gfit);
    sigma2(count)=coeff(3);
    count=count+1;
    waitbar(k/nframe1)
end

close(wb)

figure('Name','Flattening result','NumberTitle','Off')

plot([1:sens:nframe1],sigma1,'-or','LineWidth',2)
title('Sigma versus frames')

hold on
plot([1:sens:nframe1],sigma2,'-xb','LineWidth',2)

text1=num2str(median(sigma1)); text1=['data ' text1];
text2=num2str(median(sigma2)); text2=['prev ' text2];

text(gca,'string',text1,'units','normalized','position',[0.05 0.9],'color','r');
text(gca,'string',text2,'units','normalized','position',[0.05 0.85],'color','b');

[h,p] = ttest2(sigma1,sigma2);

if p>0.05
    text3=['p= ' num2str(p)];
elseif p<0.05 && p>0.01
    text3='*p< 0.05';
elseif p<0.01 && p>0.001
    text3='**p< 0.01';
else
    text3='***p< 0.001';
end

text(gca,'string',text3,'units','normalized','position',[0.80 0.05],'color','b');

hold off


% --------------------------------------------------------------------
function f1by1_Callback(hObject, eventdata, handles)
% hObject    handle to f1by1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sens=1;
b=get(handles.mode_Eval,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function f1by5_Callback(hObject, eventdata, handles)
% hObject    handle to f1by5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sens=5;
b=get(handles.mode_Eval,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function f1by10_Callback(hObject, eventdata, handles)
% hObject    handle to f1by10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sens=10;
b=get(handles.mode_Eval,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function f1by20_Callback(hObject, eventdata, handles)
% hObject    handle to f1by20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sens=20;
b=get(handles.mode_Eval,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function mode_Eval_Callback(hObject, eventdata, handles)
% hObject    handle to mode_Eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function conf_Smask_Callback(hObject, eventdata, handles)
% hObject    handle to conf_Smask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
frame=str2double(get(handles.edit_frame,'String'));
idata=video(:,:,frame);
[handles.ksize, handles.unders]=Entropy_menu(idata);
guidata(hObject,handles);


% --------------------------------------------------------------------
function plus1px_line_Callback(hObject, eventdata, handles)
% hObject    handle to plus1px_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mindata=1;
b=get(handles.med_exclusion,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function plus5px_line_Callback(hObject, eventdata, handles)
% hObject    handle to plus5px_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mindata=5;
b=get(handles.med_exclusion,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function plus10px_line_Callback(hObject, eventdata, handles)
% hObject    handle to plus10px_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mindata=10;
b=get(handles.med_exclusion,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function plus25px_line_Callback(hObject, eventdata, handles)
% hObject    handle to plus25px_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mindata=25;
b=get(handles.med_exclusion,'Children');
set(b,'Checked','Off')
set(hObject,'Checked','On')
guidata(hObject,handles);

% --------------------------------------------------------------------
function custom_1Dexclusion_Callback(hObject, eventdata, handles)
% hObject    handle to custom_1Dexclusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

b=get(handles.med_exclusion,'Children');
set(b,'Checked','Off')

guidata(hObject,handles);

% --------------------------------------------------------------------
function med_exclusion_Callback(hObject, eventdata, handles)
% hObject    handle to med_exclusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function profile_Callback(hObject, eventdata, handles)
% hObject    handle to profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function prof_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to prof_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
fastprofiler;

% --------------------------------------------------------------------
function prof_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to prof_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2)
fastprofiler;


% --------------------------------------------------------------------
function stat_video_Callback(hObject, eventdata, handles)
% hObject    handle to stat_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function stat_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to stat_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
videoStatB(video);

% --------------------------------------------------------------------
function stat_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to stat_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subtr=getappdata(0,'MySubtrVideo');
videoStatB(subtr);


% --------------------------------------------------------------------
function menu_back2viewer_Callback(hObject, eventdata, handles)
% hObject    handle to menu_back2viewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video=getappdata(0,'original');
myhandles=guidata(handles.phandle);

if isfield(handles,'phandle')
    viewer_GUI('setup',handles.phandle,[],myhandles,video);
    close(handles.figure1)
end
