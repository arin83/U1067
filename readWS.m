function varName=readWS

h=figure('Name','Chose workspace variable','NumberTitle','off','CloseRequestFcn',@closefunction,'Units','normalized','Position',[0.4 0.2 0.2 0.5]);
set(h, 'MenuBar', 'None')

vars = evalin('base','who');
varName=[];
newName=[];

List = uicontrol(gcf,'Style', 'listbox', ...
    'String', vars, ...
    'Units','normalized',...
    'Position', [0.1 0.1 0.7 0.8], ...
    'Callback', @yourCallback1);

PushButton = uicontrol(gcf,'Style', 'pushbutton', ...
    'String', 'DONE', ...
    'Units','normalized',...
    'Position', [0.1 0.02 0.12 0.05], ...
    'Callback', @yourCallback2);



    function yourCallback1(ObjH, EventData)
        newName=vars{get(ObjH,'Value')};
        varName=newName;
    end

    function yourCallback2(hObject,eventdata)
        delete(h);
    end

    function closefunction(hObject,eventdata)
        % This callback is executed if the user closes the gui
        % Assign Output
        varName=newName;
        delete(h);
    end
waitfor(h);   
end

