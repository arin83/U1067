function varargout = profile_GUI(varargin)
% PROFILE_GUI MATLAB code for profile_GUI.fig
%      PROFILE_GUI, by itself, creates a new PROFILE_GUI or raises the existing
%      singleton*.
%
%      H = PROFILE_GUI returns the handle to a new PROFILE_GUI or the handle to
%      the existing singleton*.
%
%      PROFILE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROFILE_GUI.M with the given input arguments.
%
%      PROFILE_GUI('Property','Value',...) creates a new PROFILE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before profile_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to profile_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help profile_GUI

% Last Modified by GUIDE v2.5 06-Apr-2019 16:48:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @profile_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @profile_GUI_OutputFcn, ...
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


% --- Executes just before profile_GUI is made visible.
function profile_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to profile_GUI (see VARARGIN)

% Choose default command line output for profile_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

switch nargin
    
    case 4
        handles.dpix=1;
        handles.myaxis=varargin{1};
        handles.myline=[];
        data=getimage(handles.myaxis);
        
        dpix=handles.dpix;
        
        %retrive the data
        
        set(handles.text3,'String','Distance (pxls)','ForegroundColor','white');
        
        
        
        handles.ax=gca;
        set(handles.ax,'XColor','white','YColor','white');
        
    case 5
        handles.dpix=1;
        handles.myline=varargin{1};
        handles.myaxis=varargin{2};
        data=getimage(handles.myaxis);
        hlin=handles.myline;
        dpix=handles.dpix;
        pos = hlin.getPosition();
        x=pos(:,1); y=pos(:,2);
        %retrive the data
        
        [xp yp c(:,2) lx ly] = improfile(data,x,y);
        dist=sqrt((yp(end)-yp(1))^2+(xp(end)-xp(1))^2)*dpix;
        ipix=dist/numel(xp);
        c(:,1)=[ipix:ipix:dist];
        set(handles.text3,'String','Distance (pxls)','ForegroundColor','white');
        
        handles.axes1;
        
        handles.ax=gca;
        plot(handles.ax,c(:,1),c(:,2),'LineWidth',2,'Color',getColor(hlin));
        set(handles.ax,'XColor','white','YColor','white');
        xlim(handles.ax,[-dist/40 dist+dist/40])
        
    case 6
        handles.dpix=varargin{1};
        handles.myline=varargin{2};
        handles.myaxis=varargin{3};
        data=getimage(handles.myaxis);
        hlin=handles.myline;
        dpix=handles.dpix;
        pos = hlin.getPosition();
        x=pos(:,1); y=pos(:,2);
        %retrive the data
        
        [xp yp c(:,2) lx ly] = improfile(data,x,y);
        dist=sqrt((yp(end)-yp(1))^2+(xp(end)-xp(1))^2)*dpix;
        ipix=dist/numel(xp);
        c(:,1)=[ipix:ipix:dist];
        set(handles.text3,'String','Distance (nm)','ForegroundColor','white');
        
        handles.axes1;
        
        handles.ax=gca;
        plot(handles.ax,c(:,1),c(:,2),'LineWidth',2,'Color',getColor(hlin));
        set(handles.ax,'XColor','white','YColor','white');
        xlim(handles.ax,[-dist/40 dist+dist/40])
end

if nargin>3
    hfig = ancestor(handles.myaxis,'figure','toplevel'); 
    name=get(hfig,'Name');
    if ~isempty(name)
        set(handles.figure1,'Name',['profile: ' name]);
    else
        nfig=get(hfig,'Number');
        name=['Figure ' num2str(nfig)];
        set(handles.figure1,'Name',['profile: ' name]);
    end
end

guidata(hObject, handles);
% UIWAIT makes profile_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = profile_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_update.
function push_update_Callback(hObject, eventdata, handles)
% hObject    handle to push_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    data=getimage(handles.myaxis);
    hlin=handles.myline;
    dpix=handles.dpix;
    cla(handles.ax);
    set(handles.ax,'XColor','white','YColor','white');
    
    for k=1:numel(hlin)
        pos = hlin(k).getPosition();
        x=pos(:,1); y=pos(:,2);
        %retrive the data
        
        [xp yp c(:,2) lx ly] = improfile(data,x,y);
        dist=sqrt((yp(end)-yp(1))^2+(xp(end)-xp(1))^2)*dpix;
        ipix=dist/numel(xp);
        c(:,1)=[ipix:ipix:dist];
        
        handles.axes1;
        
        
        hold on
        plot(c(:,1),c(:,2),'LineWidth',2);
        xlim(handles.ax,'auto')
        hold off
        
        clear xp yp c lx ly
    end


% --- Executes on button press in toggle_grid.
function toggle_grid_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status=get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of toggle_grid
  if status==1
      set(hObject,'String','Grid ON','ForegroundColor','k','FontWeight','bold','BackgroundColor','g')
      ax=handles.ax;
      grid(ax,'on')
      ax.GridColor = [0.1, 0.1, 0.1];
  else
      set(hObject,'String','Grid OFF','ForegroundColor','k','FontWeight','bold','BackgroundColor','r')
      ax=handles.ax;
      grid(ax,'off')
  end
  


% --- Executes on button press in push_clear.
function push_clear_Callback(hObject, eventdata, handles)
% hObject    handle to push_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj(handles.ax,'Type','line');
cla(handles.ax)
set(handles.ax,'XColor','white','YColor','white');
delete(h);

hlin=handles.myline;
delete(hlin)
handles.myline=[];
guidata(hObject, handles);


% --- Executes on button press in push_baseline.
function push_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to push_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.ax;
%retrive the xy data
h = findobj(ax,'Type','line');

if numel(h)==1
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
    mycolor=get(h,'Color');
else
    for k=1:numel(h)
        name{k}=['Line ' num2str(k)];
    end
    choice=listboxchoice(name,h);
    h=h(choice);
    mycolor=get(h,'Color');
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
end


bfig=figure;
set(bfig,'Name','Click n data point for  linear offset adjustment, press return when over','NumberTitle','off');

ax2=axes;
plot(ax2,xdata,ydata,'-','LineWidth', 2);
[x,y] = ginput;

hold on
plot(ax2,x,y, 'k+', 'MarkerSize', 14, 'LineWidth', 3);
hold off

for k=1:numel(x)
    [~, xgraph(k)]=min((x(k)-xdata).^2);
end


xgraph(1)=1;
xgraph(end)=length(xdata);


count=0;

for k=1:(numel(x)-1)
    
    b = (y(end-count)-y(end-1-count))/(x(end-count)-x(end-1-count));
    q=y(end-count)-b*x(end-count);
    yOffset(xgraph(end-count-1):xgraph(end-count)) = xdata(xgraph(end-count-1):xgraph(end-count))*b+q;
    count=count+1;
    
end

%delete all the previous crap
h = findobj(ax,'Type','line');
delete(h);

hold(ax2,'on')
plot(ax2,xdata((xgraph(1):xgraph(end))),yOffset(xgraph(1):xgraph(end)),'--')
hold(ax2,'off')

% uiwait(msgbox('Close this message box to continue','Instructions!'))
% delete(bfig)
ydata2=ydata-yOffset;

hold(ax,'on')
plot(ax,xdata,ydata2,'LineWidth',2,'Color',mycolor)
xlim(handles.ax,'auto')
hold(ax,'off')


% --------------------------------------------------------------------
function menu_save1_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_save2ws_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save2ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.ax;
%retrive the xy data
h = findobj(ax,'Type','line');

if numel(h)==1
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
    
else
    for k=1:numel(h)
        name{k}=['Line ' num2str(k)];
    end
    choice=listboxchoice(name,h);
    h=h(choice);
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
end

mydata=[xdata',ydata'];
name = inputdlg('Variable name','Save to workspace');
assignin('base',name{1},mydata);
% --------------------------------------------------------------------
function menu_save2exc_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save2exc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.ax;
%retrive the xy data
h = findobj(ax,'Type','line');

if numel(h)==1
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
    
else
    for k=1:numel(h)
        name{k}=['Line ' num2str(k)];
    end
    choice=listboxchoice(name,h);
    h=h(choice);
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
end

mydata=[xdata',ydata'];
T = array2table(mydata,...
    'VariableNames',{'distance','height'});

[file,path] = uiputfile('*.xlsx','Save data in excel');
fullpath=fullfile(path,file);
writetable(T,fullpath);


% --- Executes on button press in push_measure.
function push_measure_Callback(hObject, eventdata, handles)
% hObject    handle to push_measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radio_X,'Value'))==1
    option=1;
elseif (get(handles.radio_Y,'Value'))==1
    option=2;
else
    option=3;
end

ax=handles.ax;
l=imdistline(ax);
set(l,'tag','distline');
api = iptgetapi(l);
xax=get(gca,'XLim');
yax=get(gca,'YLim');

if option==2
    api.setPosition([max(xax)/2 min(yax)+(max(yax)-min(yax))*1/6;...
        max(xax)/2 min(yax)+(max(yax)-min(yax))*5/6])
end

fcn = costrainline('imline',...
    xax,yax,option);
api.setDragConstraintFcn(fcn);


% --- Executes on button press in push_delmeasure.
function push_delmeasure_Callback(hObject, eventdata, handles)
% hObject    handle to push_delmeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deleteme=findobj(handles.ax, 'tag', 'distline');
delete(deleteme);


% --------------------------------------------------------------------
function menu_save0_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_save2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_save2wsm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save2wsm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


h=findobj(handles.ax, 'tag', 'distline');

if ~isempty(h)
    if numel(h)==1
        pos=getPosition(h(1).ApplicationData.roiObjectReference);
        data = pdist(ans,'euclidean');
        
    else
        for k=1:numel(h)
            pos=getPosition(h(k).ApplicationData.roiObjectReference);
            data(k) = pdist(pos,'euclidean');
        end
        
    end
else
    return
end

data=data';
name = inputdlg('Variable name','Save to workspace');
assignin('base',name{1},data);

% --------------------------------------------------------------------
function menu_save2excm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save2excm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj(handles.ax, 'tag', 'distline');

if ~isempty(h)
    if numel(h)==1
        pos=getPosition(h(1).ApplicationData.roiObjectReference);
        data = pdist(ans,'euclidean');
        
    else
        for k=1:numel(h)
            pos=getPosition(h(k).ApplicationData.roiObjectReference);
            data(k) = pdist(pos,'euclidean');
        end
        
    end
else
    return
end

data=data';

T = array2table(data,...
    'VariableNames',{'distance(p2p)'});

[file,path] = uiputfile('*.xlsx','Save data in excel');
fullpath=fullfile(path,file);
writetable(T,fullpath);


% --- Executes on button press in push_add.
function push_add_Callback(hObject, eventdata, handles)
% hObject    handle to push_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data=getimage(handles.myaxis);
    hlin=imline(handles.myaxis);
    
    if ~isempty(handles.myline)
        handles.myline(end+1)=hlin;
    else
        handles.myline=hlin;
    end
    
    api = iptgetapi(hlin);
    fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),...
    get(gca,'YLim'));
    api.setPositionConstraintFcn(fcn);
    
    dpix=handles.dpix;
    pos = wait(hlin);
    x=pos(:,1); y=pos(:,2);
    %retrive the data
    
    [xp yp c(:,2) lx ly] = improfile(data,x,y);
    dist=sqrt((yp(end)-yp(1))^2+(xp(end)-xp(1))^2)*dpix;
    ipix=dist/numel(xp);
    c(:,1)=[ipix:ipix:dist];
    

    hold(handles.ax,'on')
    nl=plot(handles.ax, c(:,1),c(:,2),'LineWidth',2);    
    xlim(handles.ax,'auto')
    hold(handles.ax,'off')
    
    color_nl=get(nl,'Color'); setColor(hlin,color_nl);
    guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
hline=handles.myline;
delete(hline);
delete(hObject);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_calXY_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cal = str2double(inputdlg('units nm/pixels','XY calibration'));
if ~isnan(cal)
    handles.dpix=cal;
    set(handles.text3,'String','Distance (nm)','ForegroundColor','white');
end
guidata(hObject, handles);
