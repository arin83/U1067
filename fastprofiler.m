function  fastprofiler(dpix)

if nargin==0
    dpix=1;
    xtext='Distance (pixels)';
else
    xtext='Distance (nm)';
end


[xp yp c(:,2) lx ly] = improfile;
dist=sqrt((yp(end)-yp(1))^2+(xp(end)-xp(1))^2)*dpix;
ipix=dist/numel(xp);
c(:,1)=[ipix:ipix:dist];

hold on
lineh=plot([xp(1), xp(end)],[yp(1), yp(end)],'--w','LineWidth',2);
hold off

h=figure('Name','Proflie and measure','NumberTitle','off');
axes('position',[.1  .1  .7  .8])

plot(c(:,1),c(:,2),'LineWidth',2,'Color','r')
xlabel(xtext)
ylabel('Height (nm)')
title('Cross-section analisys')

PushButton = uicontrol(gcf,'Style', 'pushbutton', ...
  'String', 'Dist X', ...
  'Units','normalized',...
  'Position', [0.82 0.85 0.12 0.05], ...
  'Callback', @yourCallback1);

PushButton = uicontrol(gcf,'Style', 'pushbutton', ...
  'String', 'Dist Y', ...
  'Units','normalized',...
  'Position', [0.82 0.8 0.12 0.05], ...
  'Callback', @yourCallback2);

PushButton = uicontrol(gcf,'Style', 'pushbutton', ...
  'String', 'Clear', ...
  'Units','normalized',...
  'Position', [0.82 0.75 0.12 0.05], ...
  'Callback', @yourCallback3);

PushButton = uicontrol(gcf,'Style', 'togglebutton', ...
  'String', 'GRID', ...
  'Units','normalized',...
  'Position', [0.82 0.65 0.12 0.05], ...
  'Callback', @yourCallback4);


    function yourCallback1(ObjH, EventData)
% ObjH is the button handle
    l=imdistline(gca);
    api = iptgetapi(l);
    fcn = @(pos) [pos(1,1) min(pos(:,2)); pos(2,1) min(pos(:,2))];
    api.setDragConstraintFcn(fcn);   
    end

  function yourCallback2(ObjH, EventData)
% ObjH is the button handle
    l=imdistline(gca);
    api = iptgetapi(l);
    fcn = @(pos) [min(pos(:,1)) pos(1,2); min(pos(:,1)) pos(2,2)];
    api.setDragConstraintFcn(fcn);   
    end

    function yourCallback3(ObjH, EventData)
% ObjH is the button handle
    hold on 
    cla
    plot(c(:,1),c(:,2),'LineWidth',2,'Color','r')
    end

function yourCallback4(ObjH, EventData)
% ObjH is the button handle
  status=get(ObjH,'Value');
  
  if status==1
      set(ObjH,'String','Grid ON','ForegroundColor','k','FontWeight','bold','BackgroundColor','g')
      grid on
  else
      set(ObjH,'String','Grid OFF','ForegroundColor','k','FontWeight','bold','BackgroundColor','r')
      grid off
  end
  
end

uiwait(h)
delete(lineh)

end