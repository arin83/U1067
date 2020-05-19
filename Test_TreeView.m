%% Treeview
%  Version : v1.1
%  Author  : E. Ogier
%  Release : 20th july 2016
%
%  Object  : test of TreeView object

function Test_TreeView(mydir,destination,extension)

if nargin<3
    extension='.asd';
end



% % Figure
Figure = ...
    figure('Name',        'Treeview',...
           'Color',       'w',...
           'NumberTitle', 'off',...
           'Toolbar',     'none',...
           'Menubar',     'none');           
          
 % Tree view position

        P = get(Figure,'Position');  
        set(Figure,'Position',[P(1) P(2) 350 P(4)]);
        P = get(Figure,'Position');  
        
             P(1) = 3;
                P(2) = 3;
                P(3) = P(3)-3;
                P(4) = P(4)-3;


where=strfind(mydir,'\');
where=where(end);
rootname=[mydir(where+1:end) ' root'];

% Tree view object
TV = TreeView('Figure',     Figure,...
    'Position',   P,... 
    'RootName',   rootname,...
    'Directory',  mydir,...
    'Extensions', {'.*'},...
    'SelectFcn',  @SelectFcn);

       
   
% Graphical create of treeview          
TV.create();

% Expansion of successive nodes
TV.expand();

% Figure resize function
set(Figure,'ResizeFcn',@ResizeFcn);

    % Figure resize function
    function ResizeFcn(~,~)
        
        P = get(Figure,'Position');        
             P(1) = 3;
                P(2) = 3;
                P(3) = P(3)-3;
                P(4) = P(4)-3;
        
        TV.resize(P);
    
   end

    % Treeview select function
    function SelectFcn(Selection)
        
        mysele=char(Selection(1));
        [pathstr,name,ext] = fileparts(mysele);
        
        %check if an asd file was selected and find the other in the
        %directory
        
        if strcmp(ext,extension)
            
            txt=['/*' extension];
            path=strcat(pathstr,txt);
            asdfiles=dir(path);
            fileList= extractfield(asdfiles,'name');
            pathList= extractfield(asdfiles,'folder');
            
            g1data=guidata(destination);
            
            set(g1data.listbox1,'String',fileList);
            g1data.pathList=pathList;
            %reset listbox previous selections
            set(g1data.listbox1,'Value',1);
            
         
            
            %set serching path and define selected files path
            set(g1data.text_mssg,'string',pathstr,'ForegroundColor','k')
            guidata(destination,g1data);                        
       
        end
            
    
        
        
        
    end

 
end
