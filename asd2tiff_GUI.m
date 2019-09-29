function varargout = asd2tiff_GUI(varargin)
% ASD2TIFF_GUI MATLAB code for asd2tiff_GUI.fig
%      ASD2TIFF_GUI, by itself, creates a new ASD2TIFF_GUI or raises the existing
%      singleton*.
%
%      H = ASD2TIFF_GUI returns the handle to a new ASD2TIFF_GUI or the handle to
%      the existing singleton*.
%
%      ASD2TIFF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASD2TIFF_GUI.M with the given input arguments.
%
%      ASD2TIFF_GUI('Property','Value',...) creates a new ASD2TIFF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before asd2tiff_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to asd2tiff_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help asd2tiff_GUI

% Last Modified by GUIDE v2.5 01-Mar-2019 16:04:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @asd2tiff_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @asd2tiff_GUI_OutputFcn, ...
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


% --- Executes just before asd2tiff_GUI is made visible.
function asd2tiff_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to asd2tiff_GUI (see VARARGIN)

% Choose default command line output for asd2tiff_GUI
handles.output = hObject;
handles.multiviewers=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes asd2tiff_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = asd2tiff_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%retrive the selected file name and the folder

contents = cellstr(get(hObject,'String')); 
filename=contents{get(hObject,'Value')};

if isfield(handles, 'folder')
    folder_name=handles.folder;
else
    msg = 'Please select a folder!!.';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    return
end

%check if the user want to display the video, and which channel

flag=get(handles.check_viewer,'Value');

whichCh1=get(handles.radio_ch1,'Value');
whichCh2=get(handles.radio_ch2,'Value');

if whichCh1
    channel=1;
elseif whichCh2
    channel=2;
else
    channel=12;
end

if flag
    
    switch channel
        
        case 1
            filename1=['Ch1 ' filename];
            filepath = fullfile(folder_name,filename);
            [video, header]=loadASD(filepath);
            if handles.multiviewers==0
                if isfield(handles,'vCh1')&&ishandle(handles.vCh1)
                    myhandles=guidata(handles.vCh1);
                    viewer_GUI('cleanup',handles.vCh1,[],myhandles);
                    myhandles=guidata(handles.vCh1); %refres myhandles
                    setappdata(myhandles.hfig,'info',header)
                    viewer_GUI('setup',handles.vCh1,[],myhandles,video);
                    set(handles.vCh1,'Name',filename1)
                else
                    handles.vCh1=viewer_GUI(video,filename1,header);
                end
            else
            handles.vCh1=viewer_GUI(video,filename1,header);
            end
        case 2
            
            filename2=['Ch2 ' filename];
            filepath = fullfile(folder_name,filename);
            [~, header, video]=loadASD(filepath);          
         
             if handles.multiviewers==0
                if isfield(handles,'vCh2')&&ishandle(handles.vCh2)
                    %refresh channel 2 window
                    myhandles=guidata(handles.vCh2);
                    viewer_GUI('cleanup',handles.vCh2,[],myhandles);
                    myhandles=guidata(handles.vCh2); %refres myhandles
                    setappdata(myhandles.hfig,'info',header)
                    viewer_GUI('setup',handles.vCh2,[],myhandles,video);
                    set(handles.vCh2,'Name',filename2)
                    
                else
                    handles.vCh2=viewer_GUI(video,filename2,header);
                end
            else
            handles.vCh2=viewer_GUI(video,filename2,header);
             end
            
        case 12
            filename1=['Ch1 ' filename];
            filename2=['Ch2 ' filename];
            filepath = fullfile(folder_name,filename);
            [video1, header, video2]=loadASD(filepath);
            if handles.multiviewers==0
                if isfield(handles,'vCh1')&&ishandle(handles.vCh1)...
                       &&isfield(handles,'vCh2')&&ishandle(handles.vCh2) 
                    %refresh channel 2 window
                    myhandles=guidata(handles.vCh2);
                    viewer_GUI('cleanup',handles.vCh2,[],myhandles);
                    myhandles=guidata(handles.vCh2); %refres myhandles
                    setappdata(myhandles.hfig,'info',header)
                    viewer_GUI('setup',handles.vCh2,[],myhandles,video2);
                    set(handles.vCh2,'Name',filename2)
                    
                    %refresh channel 1 window
                     myhandles=guidata(handles.vCh1);
                    viewer_GUI('cleanup',handles.vCh1,[],myhandles);
                    myhandles=guidata(handles.vCh1); %refres myhandles
                    setappdata(myhandles.hfig,'info',header)
                    viewer_GUI('setup',handles.vCh1,[],myhandles,video1);
                    set(handles.vCh1,'Name',filename1)
                    
                else
                    handles.vCh1=viewer_GUI(video1,filename1,header);
                    %             data=guidata(h1);
                    guidata(hObject,handles);
                    handles=guidata(hObject);
                    
                    %handles=guidata(hObject);
                    handles.vCh2=viewer_GUI(video2,filename2,header);
                end
            else
                handles.vCh1=viewer_GUI(video1,filename1,header);
                %             data=guidata(h1);
                guidata(hObject,handles);
                handles=guidata(hObject);
                
                %handles=guidata(hObject);
                handles.vCh2=viewer_GUI(video2,filename2,header);
            end
    end
    guidata(hObject,handles);
end
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_convert.
function push_convert_Callback(hObject, eventdata, handles)
% hObject    handle to push_convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
whichCh1=get(handles.radio_ch1,'Value');
whichCh2=get(handles.radio_ch2,'Value');

if whichCh1
    channel=1;
elseif whichCh2
    channel=2;
else
    channel=12;
end


whichlist=get(handles.radio_dire,'Value');

if whichlist
    asdfiles = cellstr(get(handles.listbox1,'String'));
else
    asdfiles = cellstr(get(handles.listbox2,'String'));
end

check=cell2mat(strfind(asdfiles,'.asd'));

if isempty(check)
    msg = 'No ASD file found. Batch processing aborted!!.';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg) 
    return
end

if isfield(handles, 'folder')
    folder_name=handles.folder;
else
    msg = 'Please select a folder!!.';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    return
end

msg=batchasd4GUI(folder_name,asdfiles,channel);
set(handles.text_mssg,'string',msg,'ForegroundColor','k')



% --- Executes on button press in pushb_add.
function pushb_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushb_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox1,'String')); 
newFile=contents{get(handles.listbox1,'Value')};
oldList=cellstr(get(handles.listbox2,'String')); %read what is already present

check0=find(strcmp(oldList,'Listbox'));
check=find(strcmp(oldList,char(newFile)));

if ~isempty(check0)
    oldList(check0)=[];
    set(handles.listbox2,'String',oldList);
end

fileList=oldList; fileList{end+1}=newFile;

if ~isempty(check)
    msg1 = char(newFile);
    msg2 = " already added in the list!!!";
    msg =strcat(msg1,msg2);
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg) 
    return
end

set(handles.listbox2,'String',fileList);
PlayList=get(handles.listbox2,'String');
set(handles.listbox2,'Value',numel(PlayList));

if numel(PlayList)>0
    set(handles.push_remove,'enable','on');
end

% --- Executes on button press in push_remove.
function push_remove_Callback(hObject, eventdata, handles)
% hObject    handle to push_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox2,'String'));

if numel(contents)==0
    msg = '!!All files already deleted!!';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    set(hObject,'enable','off');
    return
end
    
sele=get(handles.listbox2,'Value');

if sele>1
    set(handles.listbox2,'Value',sele-1);
end

contents(sele)=[];
set(handles.listbox2,'String',contents);

% --------------------------------------------------------------------
function menu_load_Callback(hObject, eventdata, handles)
% hObject    handle to menu_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_settings_Callback(hObject, eventdata, handles)
% hObject    handle to menu_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in push_clear.
function push_clear_Callback(hObject, eventdata, handles)
% hObject    handle to push_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name=handles.folder;
set(handles.text_mssg,'string',folder_name,'ForegroundColor','k')


% --- Executes on button press in check_viewer.
function check_viewer_Callback(hObject, eventdata, handles)
% hObject    handle to check_viewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_viewer


% --------------------------------------------------------------------
function menu_loadASD_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadASD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%maybe can be implemented in a function

folder_name=uigetdir;

if folder_name==0
    msg = '!!No folder selected!!';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    return
end

txt='/*.asd';
path=strcat(folder_name,txt);
asdfiles=dir(path);
nfiles = length(asdfiles);

if nfiles==0
    msg = '!!No ASD file found in the selected folder!!';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    return
end

fileList= extractfield(asdfiles,'name');
set(handles.listbox1,'String',fileList);
set(handles.text_mssg,'string',folder_name,'ForegroundColor','k')
handles.folder=folder_name;
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_loadTIFF_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadTIFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_loadALL_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadALL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_batch.
function push_batch_Callback(hObject, eventdata, handles)
% hObject    handle to push_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_actions_Callback(hObject, eventdata, handles)
% hObject    handle to menu_actions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_info.
function push_info_Callback(hObject, eventdata, handles)
% hObject    handle to push_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.listbox1,'String')); 
filename=contents{get(handles.listbox1,'Value')};



if isfield(handles, 'folder')
    folder_name=handles.folder;
else
    msg = 'Please select a folder!!.';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    return
end

if ~contains(filename,'.asd')
    msg = 'No .asd file selected.';
    set(handles.text_mssg,'string',msg,'ForegroundColor','r')
    warning(msg)
    return
end

filepath = fullfile(folder_name,filename);
header=loadASDh(filepath);

clear fake
info_GUI(header, filename);




% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
 keyPressed = eventdata.Key;
 
switch keyPressed
     
    case 'i'
    % set focus to the button
     uicontrol(handles.push_info);
     % call the callback
     push_info_Callback(handles.push_info,[],handles);
 end


% --------------------------------------------------------------------
function ctxmenu_multi_Callback(hObject, eventdata, handles)
% hObject    handle to ctxmenu_multi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.multiviewers=1;
set(handles.ctxmenu_single,'Checked','off')
set(hObject,'Checked','on')
guidata(hObject, handles);
% --------------------------------------------------------------------
function ctxmenu_single_Callback(hObject, eventdata, handles)
% hObject    handle to ctxmenu_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.multiviewers=0;
set(handles.ctxmenu_multi,'Checked','off')
set(hObject,'Checked','on')
guidata(hObject, handles);
% --------------------------------------------------------------------
function viewer_options_Callback(hObject, eventdata, handles)
% hObject    handle to viewer_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
