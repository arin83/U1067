function stabilized=correctDrift(video,cmap,range)

%aligned the video according to the clikked point in a reference image



numFrames=size(video,3);

%start and end frames to be corrected

prompt={'first frame',...
        'last frame','constant drift: (0)no, yes(1)','canvas relative'};
name='frame selection';
numlines=1;

defaultanswer={'1',num2str(numFrames),'0','3'};

options.Resize='on';
options.WindowStyle='normal';

answer=str2double(inputdlg(prompt,name,numlines,defaultanswer,options));
start=answer(1,1);
stop=answer(2,1);
constantDrift=answer(3,1);
canvas=answer(4,1);
%initialization

counter=0;
BW=video(:,:,start);
dim=size(BW);

stabilized=zeros(floor(dim(1)*canvas),floor(dim(2)*canvas),numFrames);
dimcanvas=size(stabilized);

offset = floor([(dimcanvas(1)-dim(1))/2 (dimcanvas(2)-dim(2))/2]);  


stabilized( (1:size(BW,1))+offset(1),...
(1:size(BW,2))+offset(2),: )=video;

dummyVideo = gaussfGUI(start,video,range,cmap);
BW=dummyVideo(:,:,start);
fakeI=zeros(size(BW));

h=figure('Name','Correct alignment...','NumberTitle','off'); % select your point

hsub1=subplot(1,2,1);
hsub2=subplot(1,2,2);

href=imagesc(BW,'parent',hsub1,range);

title(hsub1,'Chose your reference point','Color','r')

axis (hsub1,'image')
axis (hsub2,'image')

colormap(hsub1,cmap)


%plot some information
MyBox1 = uicontrol('style','text');
set(MyBox1,'String','Press ''z'' to activate zoom/pan')
set(MyBox1,'Units','normalized','Position',[0.1,0.1,0.8,0.1])

MyBox2 = uicontrol('style','text');
set(MyBox2,'String','Press ''e'' to define a new reference point')
set(MyBox2,'Units','normalized','Position',[0.1,0.1,0.8,0.05])

[xref, yref, key]=ginput(1);

if (key=='z')
    
    help=helpdlg('You can zoom in/out/pan',...
        'Alignment paused');
    hali=imagesc(fakeI,'parent',hsub2,range);
    colormap(hsub2,cmap)
    axis (hsub2,'image')
    linkaxes([hsub1,hsub2],'xy')
    uiwait(help)
    [xref, yref]=ginput(1);
    
end
text(xref, yref,'+','Color','r','HorizontalAlignment','center')

xdrift=zeros(size(video,3),1);
ydrift=zeros(size(video,3),1);

for k = (start+1):stop
    
    drift=video(:,:,k);
    dummyImage=dummyVideo(:,:,k);
               
    if ~exist('hali','var')||~ishandle(hali)
        hsub2=subplot(1,2,2);
        hali=imagesc(dummyImage,range);
        colormap(hsub2,cmap)
        axis image
    else
        hali.CData=dummyImage;
        %delete(findobj(hsub2,'Type','text','Color','r'))
    end
    
    title(hsub2,['Frame n ',int2str(k)])
        
    
    if constantDrift==1 && k>start+1
        xdrift(k)=xdrift(k-1);
        ydrift(k)=ydrift(k-1);
        text(xdrift(k), ydrift(k),'+','Color','r','HorizontalAlignment','center') 
    else
        
    [xdrift(k), ydrift(k), key]=ginput(1);
    
    if (key=='e')
        BW=dummyVideo(:,:,k-1);
        hsub1=subplot(1,2,1);
        
        imagesc(BW,range);
        
        title('Chose your new reference point','Color','r')
        
        axis image
        
        colormap(cmap)
               
       [xref, yref]=ginput(1);
        
        text(xref, yref,'+','Color','r','HorizontalAlignment','center')
        
        subplot(1,2,2);
        title(['Frame n ',int2str(k), ' continue'])
        [xdrift(k), ydrift(k)]=ginput(1);
    
    elseif (key=='z')
        help=helpdlg('You can zoom in/out/pan',...
            'Alignment paused');
        linkaxes([hsub1,hsub2],'xy')
        uiwait(help)        
        [xdrift(k), ydrift(k)]=ginput(1);
        
    end
    
    %text(xdrift(k), ydrift(k),'+','Color','r','HorizontalAlignment','center')
    xdrift(k)=round(xdrift(k)-xref)*-1;
    ydrift(k)=round(ydrift(k)-yref)*-1;
    
    end
   



    newImage= zeros([floor(size(BW,1)*canvas) floor(size(BW,2)*canvas)]);
    newImage((1:size(BW,1))+offset(1) +ydrift(k),(1:size(BW,2))+offset(2)+ xdrift(k))=drift;

 %   axis image
   
    counter=counter+1;
    stabilized(:,:,k)=newImage;
end

close(h)
stabilized = im2single(stabilized);
drift=[1:1:size(video,3)]';
drift(:,2:3)=[xdrift ydrift];
XYtable(drift);
%stabilized=videoUnion(stabilized);

end
