function choice=listboxchoice(list,handleslist)

h=figure('Name','Chose variable','NumberTitle','off','CloseRequestFcn',@closefunction,'Units','normalized','Position',[0.4 0.2 0.2 0.5]);
set(h, 'MenuBar', 'None')
myvariable=0;

if nargin==2
    mycolors=get(handleslist,'Color');
    mylinew=get(handleslist,'LineWidth');
    myvariable=1;
end

mychoice=[];
choice=[];

List = uicontrol(gcf,'Style', 'listbox', ...
    'String', list, ...
    'Units','normalized',...
    'Position', [0.1 0.1 0.7 0.8], ...
    'Callback', @yourCallback1);

PushButton = uicontrol(gcf,'Style', 'pushbutton', ...
    'String', 'DONE', ...
    'Units','normalized',...
    'Position', [0.1 0.02 0.12 0.05], ...
    'Callback', @yourCallback2);



    function yourCallback1(ObjH, EventData)
        mychoice=get(ObjH,'Value');
        
        if myvariable==1
            for k=1:numel(list)
            set(handleslist(k),'LineStyle','-','Color',cell2mat(mycolors(k)),...
                'Linewidth', cell2mat(mylinew(k)));
            end
            myhandle=handleslist(mychoice);                        
            set(myhandle,'LineStyle',':','Color','black','Linewidth', 2);
            uistack(myhandle,'top');
        end
        
        choice=mychoice;
    end   

    function yourCallback2(hObject,eventdata)
        delete(h);
        if myvariable==1
            for k=1:numel(list)
                set(handleslist(k),'LineStyle','-','Color',cell2mat(mycolors(k)),...
                    'Linewidth', cell2mat(mylinew(k)));
            end
        end
    end

    function closefunction(hObject,eventdata)
        % This callback is executed if the user closes the gui
        % Assign Output
        choice=[];
       
        delete(h);
    end
waitfor(h);   
end

