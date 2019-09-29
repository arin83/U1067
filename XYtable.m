function drift=XYtable(varargin)

h=figure('Name','XY drifts','NumberTitle','off','CloseRequestFcn',@closefunction,'Units','normalized','Position',[0.4 0.2 0.15 0.5]);
set(h, 'MenuBar', 'None')

if nargin==1
    if size(varargin{1},2)==3
        mydrift=varargin{1};
    else
        mydrift=zeros(varargin{1},3);
    end
else
    mydrift=zeros(30,3);
end

drift=[];

uit = uitable(h,...
    'Units','normalized',...
    'Position', [0.1 0.1 0.67 0.8],'KeyPressFcn',@myfun);


uit.Data = mydrift;
uit.ColumnName = {'Frame','X drift','Y drift'};
uit.ColumnEditable = true;

    function myfun(hObject,eventdata)
        import = importdata('-pastespecial');
        set(uit,'Data',import);
    end

PushButton = uicontrol(gcf,'Style', 'pushbutton', ...
    'String', 'DONE', ...
    'Units','normalized',...
    'Position', [0.1 0.02 0.15 0.05], ...
    'Callback', @yourCallback1);

PushButton2 = uicontrol(gcf,'Style', 'pushbutton', ...
    'String', 'IMPORT', ...
    'Units','normalized',...
    'Position', [0.30 0.02 0.2 0.05], ...
    'Callback', @yourCallback2);

PushButton3 = uicontrol(gcf,'Style', 'pushbutton', ...
    'String', 'SAVE', ...
    'Units','normalized',...
    'Position', [0.55 0.02 0.15 0.05], ...
    'Callback', @yourCallback3);

    function yourCallback1(hObject,eventdata)
        drift=uit.Data;
        delete(h);
       
    end

    function yourCallback2(hObject,eventdata)
        uiopen('load');
        uit.Data=drift;
        
        
    end

    function yourCallback3(hObject,eventdata)
        
        drift=uit.Data;
        uisave('drift');
        delete(h);
        
    end


    function closefunction(hObject,eventdata)
        % This callback is executed if the user closes the gui
        % Assign Output
        drift=[];
        delete(h);
    end
waitfor(h);   
end

