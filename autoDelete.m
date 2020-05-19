%this function will find and delete frames with poor correlation in respect to the other

%frames present in the video

%if option =1 it will interacts with the user and enquiry for a correlation threshold,

%otherwise assumes mean-2.5*sigma



function [cleanVideo dFrames]=autoDelete(video, option)

%reshape properly the data for statistics, and comput correlation matrix
%and entropy

video2d=reshape(video,[],size(video,3));
cc=corrcoef(video2d);
cc(isnan(cc))=-1;

videomat=mat2gray(video);

for k=1:size(video,3)
    E(k)=(entropy(videomat(:,:,k)));
end

clear videomat
%create averaging coefficients for the oblivion effect

oe=0.02;
space=oe:-oe/size(video,3):0;

if size(video2d,2) > size(space,2)
    space=[space'; zeros(size(video2d,2)-length(space),1)];
    %space=space+10;
else
    space=space(1:size(video2d,2))';
end

%make the coefficients in the matrix

 spaceB=circulant(space);
 spaceB=tril(spaceB);
 space2B=spaceB';
 spaceB=spaceB+space2B;
 

 %clean from empty frames

 logE=E<0.1;
 logEa=repmat(logE,size(cc,1),1);
 logEb=logEa';
 logE=logEa|logEb;
 

h = fspecial('average', 5);

space = cc;
BW = im2bw(space,0.5);
BW = bwareaopen(BW, round(size(video,3)/10));
BW=not(BW);
%spaceB=zeros(size(cc));    %make 0 outside the ROI area - 4debugging
space(BW)=spaceB(BW);
space = roifilt2(h, space, not(BW));
%space=ones(size(cc));   %for debugging remove coefficeints

space=space - diag(diag(space));
space(logE)=0;

%compute thresholds and scores
score=cc.*space;
score=sum(score)./sum(space);
score(isnan(score))=0;
mScore=median(score);
stdScore=mad(score,1);
mE=median(E);
stdE=mad(E,1);

%plot the stuff
h(1)=figure('Name','Auto-deletion Correlation','NumberTitle','off');

subplot(1,2,1)
f(1)=imagesc(cc);
axis image
colorbar
title('Correlation matrix','Color','r','Fontweight','bold')

subplot(1,2,2)
f(2)=imagesc(space);
axis image
colorbar
title('Weighting factors','Color','r','Fontweight','bold')

%fixed threshold

fBound(1)=mScore-7*stdScore;
fBound(2)=0.03;
fBound=max(fBound);

fBound(2)=0.19;
fBound=min(fBound);

%figures

h(2)=figure('Name','Auto-deletion Scores','NumberTitle','off');

s(1)=subplot(2,1,1);

hold on 
p(1)=plot(score);
limx=get(gca,'xlim') ;
set(gca,'ylim',[mScore-9*stdScore mScore+5*stdScore])
msg=sprintf('MAD_Sc %6.4f; MeanSc %6.4f',stdScore, mScore);
text(0.35,0.9,msg,'Units','normalized', 'FontSize',7);
line(limx,[mScore mScore],'color','k','linestyle',':')
line(limx,[mScore-4*stdScore mScore-4*stdScore],'color','g','linestyle',':')
line(limx,[mScore+4*stdScore mScore+4*stdScore],'color','g','linestyle',':')
line(limx,[fBound fBound],'color','r','linestyle',':')
hold off

title('Avg score','Color','r','Fontweight','bold')
ylabel('Corr-Score','FontSize',8)

s(2)=subplot(2,1,2);

hold on 
p(2)=plot(E);
limx=get(gca,'xlim') ;
set(gca,'ylim',[mE-9*stdE mE+7*stdE])
msg=sprintf('MAD_E %6.4f; MeanE %6.4f',stdE, mE);
text(0.35,0.9,msg,'Units','normalized', 'FontSize',7);
line(limx,[mE mE],'color','k','linestyle',':')
line(limx,[mE-7*stdE mE-7*stdE],'color','g','linestyle',':')
line(limx,[mE+7*stdE mE+7*stdE],'color','g','linestyle',':')

hold off

title('Frame Entropy','Color','r','Fontweight','bold')
xlabel('Frame #','FontSize',8)
ylabel('Entropy','FontSize',8)

linkaxes([s(1),s(2)],'x');


%set default baundery for movable threshold

lBound=mScore-4*stdScore;

%interacting with the user
if nargin==2 && option==1
    
    prompt={'Chose an appropriate Corr-Score threshold'};
    name='Lower bounday';
    numlines=1;
    
    defaultanswer={num2str(lBound)};
    
    options.Resize='on';
    options.WindowStyle='normal';
    
    answer=inputdlg(prompt,name,numlines,defaultanswer,options);
    lBound=str2double(answer(1,1));
end

%find the first list to be deleted - below fixed threshold
del1=score<=fBound;
del1=find(del1);

%find the first list to be deleted - below movable thresholdd
del2a=score<lBound & score>fBound;
del2b=E<mE-6*stdE|E>mE+6*stdE;
del2=del2a&del2b;
del2=find(del2);

figure(h(2))
axes(s(1))
hold on
plot(del1,score(del1),'o','MarkerSize',10,'Color','r')

axes(s(2))
hold on
plot(del2,E(del2),'o','MarkerSize',10,'Color','r')

del=[del1 del2];
dFrames=video(:,:,del);

disp('Deleted')
disp(del)

%clean the video

cleanVideo=video;
cleanVideo(:,:,flipud(del))=[];





