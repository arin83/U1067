function mask=entropyMask(varargin)

tol=0.01;
video=varargin{1};
nf=size(video,3);

if nargin == 1
    mode='auto';
    l_ker=17;
    unders=0.5;
elseif nargin == 2
    mode=varargin{2};
    l_ker=17;
    unders=0.5;
else
    mode=varargin{2};
    l_ker=varargin{3};
    unders=varargin{4};
    %make the number odd, necessary for entrpyfilt function
    idx = mod(l_ker,2)==0;
    l_ker(idx)=l_ker(idx)+1;
    l_ker=max([l_ker, 5]);
end

%setup needed variables
def_ker=ones(l_ker);

l_ker2=l_ker*unders;
idx = mod(l_ker2,2)<1;
l_ker2=floor(l_ker2);
l_ker2(idx)=l_ker2(idx)+1;
l_ker2=max([l_ker2, 5]);

sizefilt=round(0.05*(mean([size(video,1), size(video,2)])));

%check the time needed to process the video
tic
timage=mat2gray(video(:,:,1));
J=uint8(255*mat2gray(entropyfilt(timage,def_ker)));
thres= graythresh(J);
BW = imbinarize(J,thres);
BW = bwareaopen(BW,sizefilt);
BW=not(BW);
mytime=toc;
mytime=mytime*nf;

%ask to resize 

if mytime>30
    
    msg=sprintf('The total expected time is: %.2f sec.', mytime);
    answer = questdlg(msg, 'Resize data', ...
        'Downsample data','Proceed anyway','Proceed anyway');
    
    switch answer
        case 'Downsample data'
            video=imresize(video,unders);
            def_ker=ones(l_ker2); 
            sizefilt=round(0.05*(mean([size(video,1), size(video,2)])));
    end
end

%calculate the first frame
timage=mat2gray(video(:,:,1));
mask= logical(zeros(size(video)));

J=uint8(255*mat2gray(entropyfilt(timage,def_ker)));
thres= graythresh(J);
BW = imbinarize(J,thres);
BW=not(BW);
BW = bwareaopen(BW,sizefilt);

%             stats = regionprops(BW,'Area');
%             [~, idxArea]=max(extractfield(stats,'Area'));
%             BW2 = bwlabel(BW);
%             mask(:,:,1)=BW2==idxArea;
if strcmp(mode,'auto')
    mask(:,:,1)=BW;
    
elseif strcmp(mode,'sele')
    h=figure('Name','Chose background/foreground. Press return to finish','NumberTitle','off');
    imagesc(BW); axis image;
    BW2=bwselect;
    mask(:,:,1)=BW2;
    close(h)
end
%loop it
h = waitbar(0,'processing the video');

for k=2:nf
    
    timage=mat2gray(double(video(:,:,k)));
    J=uint8(255*mat2gray(entropyfilt(timage,def_ker)));
    thres= graythresh(J);
    BW = imbinarize(J,thres);
    BW=not(BW);
    BW = bwareaopen(BW,sizefilt);
    
    
    %     BW2 = bwlabel(BW);
    %     template=mask(:,:,k-1);
    %
    %     for i=1:max(BW2(:))
    %         obj(:,:,i)=BW2==i;
    %     end
    %
    %
    %
    %     template=repmat(template,[1 1 max(BW2(:))]);
    %     [~, idx]=max(jaccard(template,obj));
    %     mask(:,:,k)=BW2==idx;
    %     clear obj
    if strcmp(mode,'auto')
        mask(:,:,k)=BW;
        
    elseif strcmp(mode,'sele')
        
        BW2 = bwlabel(BW);
        template=mask(:,:,k-1);
        
        for i=1:max(BW2(:))
            obj(:,:,i)=BW2==i;
        end
        
        template=repmat(template,[1 1 max(BW2(:))]);
        scores=squeeze(jaccard(template,obj));
        [scores ord_scores]=sort(scores,'descend');
        scores=find(scores);
        scores=ord_scores(scores);
        sumscore=0;
        
        for j=1:numel(scores)
            
            tmask=BW2==scores(j);
            tmask=mask(:,:,k)|tmask;
            scoreprime=sumscore;
            sumscore=jaccard(template(:,:,1),tmask);
            d=sumscore-scoreprime;
          
            if d<tol
                break
            else
                mask(:,:,k)=tmask;
            end
        end
        clear obj
    end
    waitbar(k/nf)
end

if exist('answer','var')
    if strcmp(answer,'Downsample data')
        mask=imresize(mask,1/unders);
    end
end

close(h)