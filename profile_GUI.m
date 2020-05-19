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

% Last Modified by GUIDE v2.5 14-May-2020 15:18:29

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
        
        set(handles.text_u,'String','[pxls]','ForegroundColor','white');
        
        
        
        handles.ax=gca;
       
        
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
        set(handles.text_u,'String','[pxls]','ForegroundColor','white');
        
        handles.axes1;
        
        handles.ax=gca;
        h_plot=plot(handles.ax,c(:,1),c(:,2),'LineWidth',2,'Color',getColor(hlin));
        %set a tag for easy retrival
        set(h_plot,'tag','my_cross')
        
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
        set(handles.text_u,'String','[nm]','ForegroundColor','white');
        
        handles.axes1;
        
        handles.ax=gca;
        h_plot=plot(handles.ax,c(:,1),c(:,2),'LineWidth',2,'Color',getColor(hlin));
          %set a tag for easy retrival
        set(h_plot,'tag','my_cross')
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

%set up fields for storing the X and Y measurements
handles.x_measured=[];
handles.y_measured=[];
handles.isXorY=[];

set(handles.ax,'XColor','white','YColor','white','FontSize',8);
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
        h=plot(c(:,1),c(:,2),'LineWidth',2);
        set(h,'tag','my_cross')
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

%clear and reset the axis
handles.x_measured=[];
handles.y_measured=[];
set(handles.text9,'String',num2str(00))
set(handles.text10,'String',num2str(00))
handles.isXorY=[];

%This will delete the line from which the crosssection come as well in the
%viewer_GUI

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
h = findobj(ax,'Type','line','tag','my_cross');

if numel(h)==1
    ydata=get(h,'Ydata') ;
    xdata=get(h,'Xdata') ;
    mycolor=get(h,'Color');
else
    for k=1:numel(h)
        name{k}=['Line ' num2str(k)];
    end
    choice=listboxchoice(name,h);
    hc=h(choice);
    mycolor=get(hc,'Color');
    ydata=get(hc,'Ydata') ;
    xdata=get(hc,'Xdata') ;
end


bfig=figure;
set(bfig,'Name','Click n data point for  linear offset adjustment, press return when over','NumberTitle','off');

ax2=axes;
plot(ax2,xdata,ydata,'-','LineWidth', 2,'Color',mycolor);
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

%delete the un-flattened line

delete(h(choice));

hold(ax2,'on')
plot(ax2,xdata((xgraph(1):xgraph(end))),yOffset(xgraph(1):xgraph(end)),'--')
hold(ax2,'off')

% uiwait(msgbox('Close this message box to continue','Instructions!'))
% delete(bfig)
ydata2=ydata-yOffset;

hold(ax,'on')
plot(ax,xdata,ydata2,'LineWidth',2,'Color',mycolor,'tag','my_cross')
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
h = findobj(ax,'Type','line','tag','my_cross');

if isempty(h)
    return
end

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
h = findobj(ax,'Type','line','tag','my_cross');

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

%clean everything

push_delmeasure_Callback(hObject, eventdata, handles)

%check if vertical or horizontal line

if (get(handles.radio_X,'Value'))==1
    option=1;
elseif (get(handles.radio_Y,'Value'))==1
    option=2;
end

%get axis handel and x,y limits to draw lines

ax=handles.ax;
hlim=get(ax,'XLim');
vlim=get(ax,'YLim');

%draw the two lines and give default positions and highlight area

%case vertical lines, measuring in X
if option==1
    
    %flag as X measurement
    handles.isXorY=1;
    
    xstart=(hlim(2)-hlim(1))/3;
    
    %highlight the are between the lines
    color_a=patch([xstart xstart*2 xstart*2 xstart],...
        [vlim(1) vlim(1) vlim(2) vlim(2)], [0.2 0.4 0.2], 'FaceAlpha',0.3, 'EdgeColor','none');
    
    %draw line on the left + hadnle
    hold on
    line_l(1)=line(ax,[xstart xstart],...
        vlim,'LineWidth',2,'Color','r','linestyle','--');
    line_l(2)=plot(xstart,vlim(2));
    hold off
    
    %store the data and handles for each left element, are needed later on
    %when dragging to update all the elements 'live'
    for k=1:2
        setappdata(line_l(k),'highlight',color_a)
        setappdata(line_l(k),'text',handles.text5)
        setappdata(line_l(k),'group',line_l)
    end
    
    %draw line on the right + hadnle
    hold on
    line_r(1)=line(ax,[xstart*2 xstart*2],...
        vlim,'LineWidth',2,'Color','r','linestyle','--');
    line_r(2)=plot(xstart*2,vlim(2));
    hold off
    
    for k=1:2
        setappdata(line_r(k),'highlight',color_a)
        setappdata(line_r(k),'text',handles.text5)
        setappdata(line_r(k),'group',line_r)
    end
            
    %resize the markers to make them big. They serves as an easy handle to
    %drag and drop
    set(line_l(2),'Marker','s','MarkerSize',12,'MarkerFaceColor','r')
    set(line_r(2),'Marker','s','MarkerSize',12,'MarkerFaceColor','r')    
    
    %make lines and handles on the lef and right draggable
    draggable(line_l,'h',[hlim(1)+1 hlim(2)-1],@update_area1,'endfcn',@calch)
    draggable(line_r,'h',[hlim(1)+1 hlim(2)-1],@update_area2,'endfcn',@calch)
   
    %case horizontal lines, measuring in Y
elseif option==2
    
%flag as Y measurement
    handles.isXorY=0;
    
    ystart=((vlim(2)-vlim(1))/3);
    
    color_a=patch([hlim(1) hlim(2) hlim(2) hlim(1)],...
        [ystart+vlim(1) ystart+vlim(1)  ystart*2++vlim(1) ystart*2++vlim(1)],...
        [0.2 0.4 0.2], 'FaceAlpha',0.3, 'EdgeColor','none');
    
    hold on
    line_l(1)=line(ax,hlim,...
        [ystart+vlim(1) ystart+vlim(1)],'LineWidth',2,'Color','r',...
        'linestyle','--');
    line_l(2)=plot(hlim(2),ystart+vlim(1));
    hold off
    
    for k=1:2
        setappdata(line_l(k),'highlight',color_a)
        setappdata(line_l(k),'text',handles.text5)
        setappdata(line_l(k),'group',line_l)
    end
    
    hold on
    line_r(1)=line(ax,hlim,...
        [2*ystart+vlim(1) 2*ystart+vlim(1)],'LineWidth',2,'Color','r',...
        'linestyle','--');
    line_r(2)=plot(hlim(2),2*ystart+vlim(1));
    hold off
    
    for k=1:2
    setappdata(line_r(k),'highlight',color_a)
    setappdata(line_r(k),'text',handles.text5)
    setappdata(line_r(k),'group',line_r)
    end
    
    set(line_l(2),'Marker','s','MarkerSize',12,'MarkerFaceColor','r')
    set(line_r(2),'Marker','s','MarkerSize',12,'MarkerFaceColor','r')
    
    % %save area handle
    
    
    %make them draggable
    delta=(vlim(2)-vlim(1))/50;
    draggable(line_l,'v',[vlim(1)+delta vlim(2)-delta],@update_area1,'endfcn',@calch)
    draggable(line_r,'v',[vlim(1)+delta vlim(2)-delta],@update_area2,'endfcn',@calch)
end

guidata(hObject, handles);

function update_area1(line_m)
 
flag=0;
pos=get(line_m,'Xdata');
ylimits=ylim(gca);
xlimits=xlim(gca);
group=getappdata(line_m,'group');

if (numel(pos))==1
    if pos~=xlimits(2)
        set(group(1),'xdata',[pos pos],'ydata',ylimits)
    else
        pos=get(line_m,'Ydata');
        set(group(1),'xdata',xlimits,'ydata',[pos pos])
        flag=1;
    end
    
else    
    if pos(1)~=pos(2)
        pos=get(line_m,'Ydata');
        set(group(2),'xdata',xlimits(2),'ydata',pos(1))
        flag=1;
    else
        set(group(2),'xdata',pos(1),'ydata',ylimits(2))
    end
end

h_area=getappdata(line_m,'highlight');
newVert=get(h_area,'Vertices'); 

if flag==0
    newVert([1 4],1)=pos(1);
else
    newVert([1 2],2)=pos(1);
end

set(h_area,'Vertices',newVert);

function update_area2(line_m)

flag=0;
pos=get(line_m,'Xdata');
ylimits=ylim(gca);
xlimits=xlim(gca);
group=getappdata(line_m,'group');

if (numel(pos))==1
    if pos~=xlimits(2)
        set(group(1),'xdata',[pos pos],'ydata',ylimits)
    else
        pos=get(line_m,'Ydata');
        set(group(1),'xdata',xlimits,'ydata',[pos pos])
        flag=1;
    end
    
else    
    if pos(1)~=pos(2)
        pos=get(line_m,'Ydata');
        set(group(2),'xdata',xlimits(2),'ydata',pos(1))
        flag=1;
    else
        set(group(2),'xdata',pos(1),'ydata',ylimits(2))
    end
end

h_area=getappdata(line_m,'highlight');
newVert=get(h_area,'Vertices'); 

if flag==0
    newVert([2 3],1)=pos(1);
else
    newVert([3 4],2)=pos(1);
end

set(h_area,'Vertices',newVert);

function calch(line_m)
h_area=getappdata(line_m,'highlight');
Vert=get(h_area,'Vertices');

if sum([Vert(1,2) Vert(4,2)]-ylim(gca))==0
    distance=abs(Vert(2,1)-Vert(1,1));

else
    distance=abs(Vert(4,2)-Vert(1,2));
   
end
%print out results
fprintf('Distance: %5.1f\n',distance)
h_text=getappdata(line_m,'text');
set(h_text,'String',num2str(distance))

%make it blink
for k=1:2
    set(h_text,'ForegroundColor','w')
    pause(0.2)
    set(h_text,'ForegroundColor','k')
    pause(0.2)
end

%save




% --- Executes on button press in push_delmeasure.
function push_delmeasure_Callback(hObject, eventdata, handles)
% hObject    handle to push_delmeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deleteme=findobj(handles.ax,'type', 'line','linestyle','--','color','r');
delete(deleteme);
deleteme=findobj(handles.ax,'MarkerFaceColor','r');
delete(deleteme);
deleteme=findobj(handles.ax,'type', 'patch');
delete(deleteme);


set(handles.text5,'String',num2str(000));



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

if ~isempty(handles.x_measured)||~isempty(handles.y_measured)
    
    measurements.X_measurements=handles.x_measured;
    measurements.Y_measurements=handles.y_measured;
    
    name = inputdlg('Variable name','Save to workspace');
    assignin('base',name{1},measurements);
end

% --------------------------------------------------------------------
function menu_save2excm_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save2excm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.x_measured)||~isempty(handles.y_measured)
    x_data=handles.x_measured;
    y_data=handles.y_measured;
    N=max(numel(handles.x_measured),numel(handles.y_measured));
    data=nan(N,2);
    data(1:numel(handles.x_measured),1)=x_data;
    data(1:numel(handles.y_measured),2)=y_data;
    
    T = array2table(data,...
        'VariableNames',{'x_measured','y_measured'});
    
    [file,path] = uiputfile('*.xlsx','Save data in excel');
    fullpath=fullfile(path,file);
    writetable(T,fullpath);
end


% --- Executes on button press in push_addxymeasured.
function push_add_Callback(hObject, eventdata, handles)
% hObject    handle to push_addxymeasured (see GCBO)
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
    
    color_nl=get(nl,'Color'); setColor(hlin,color_nl);set(nl,'tag','my_cross');
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
    set(handles.text_u,'String','[nm]','ForegroundColor','white');
end
guidata(hObject, handles);


% --- Executes on button press in push_addXYmeasured.
function push_addXYmeasured_Callback(hObject, eventdata, handles)
% hObject    handle to push_addXYmeasured (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current=str2num(get(handles.text5,'String'));

if current
    if ~isempty(handles.isXorY) && handles.isXorY==1
    mydata_x=handles.x_measured;
    mydata_x(end+1)=current;
    set(handles.text9,'String',num2str(numel(mydata_x)))
    handles.x_measured=mydata_x;
    color=get(handles.text9,'BackgroundColor');
    
    for k=1:2       
        set(handles.text9,'BackgroundColor','g')
        pause(0.2)
        set(handles.text9,'BackgroundColor',color)
        pause(0.2)
    end
    
    elseif ~isempty(handles.isXorY) && handles.isXorY==0
          mydata_y=handles.y_measured;
    mydata_y(end+1)=current;
    set(handles.text10,'String',num2str(numel(mydata_y)))
    handles.y_measured=mydata_y;
    color=get(handles.text10,'BackgroundColor');
    
    for k=1:2        
        set(handles.text10,'BackgroundColor','g')
        pause(0.2)
        set(handles.text10,'backgroundColor',color)
        pause(0.2)
    end
    else
        return
    end
    guidata(hObject, handles);
end  
