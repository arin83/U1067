function [subtracted] = vnorm(video, option, bound)
%brightness regularization in an image stack
%
%Inputs:
%   video =  X-by-Y-by-T matrix corresponding to an X-Y-Time image sequence,
%   as output from the loadASD.m function 
%   bound = highest and lowest % of data excluded from the mean calculation
%Usage:
%    subtracted=vnorm(video, option, bound) returns a X-by-Y-by-T matrix where to each 
%    2D X-by-Y matrices the mean value has been subtracted using trimmean (default 
%    option=0 or option=0)or the mean intensity from an user-defined ROI (option = 1). 
%    0's are excluded from computation as they might rparesent artificial values
%    arised in a previous procssing step.
% 
% -------------------------------------------------------------------------
% By Arin Marchesi
% INSERM U1006
% Marseille, 13009
% 12-October-2017
% written on MAtlab 2012a
% ------------------------------------------------------------------------

if nargin==1
    option=0; bound=0;
elseif nargin==2
    bound=0;
end

classes = {'numeric'};
attributes_video = {'size',[NaN,NaN,NaN]};
attributes_option = {'scalar','>',-1,'<',2};

validateattributes(video,classes,attributes_video)
validateattributes(option,classes,attributes_option)


if option==0 
    if bound==0
        dlg_prompt='Intensity outliers in %';
        dlg_title='Outliers to be excluded';
        outV=str2double(inputdlg(dlg_prompt,dlg_title))*2;
    else
        outV=bound;        
    end
    
    s=size(video,3);
    bck=zeros(size(video));
    h=waitbar(0,'normalizing data....');
    
    for k=1:s
        tvideo=video(:,:,k);
        tvideo(tvideo==0)=NaN;  %0's are excluded as they might have been...
        %artificially introduced during an alignment step
        select = ~isnan(tvideo);
        tvideo = tvideo(select);
        m=trimmean(tvideo(:),outV);
        bck(1:size(video,1),1:size(video,2),k)=m;
        waitbar(k/s)
    end
    
    close(h)
    
    subtracted=video-bck;
    
    
elseif option==1
    
    h=figure('Name','Difine a ROI','NumberTitle','off');
    
    bck=zeros(size(video));
    
    s=size(video,3);
    hax=axes('Units','normalized',...
        'Position',[0.1 0.1 0.8 0.8]);
    himage=imagesc(video(:,:,1));
    colormap gray
    axis image
    imcontrast
    rect=imrect(hax);
    pos=wait(rect);
    i=waitbar(0,'normalizing data....');
    
    
    for k=1:s
        tvideo=video(:,:,k);
        tvideo(tvideo==0)=NaN;
        mask=createMask(rect);
        measures=regionprops(mask,tvideo,'MeanIntensity');
        m=measures.MeanIntensity;
        bck(1:size(video,1),1:size(video,2),k)=m;
        waitbar(k/s)
    end
    
    
    close(h)
    close(i)
    subtracted=video-bck;
end

%usually in AFM negative heights are avoided, to meet this
%condition an offset is added to the video

% offset=min(subtracted(:));
% 
% subtracted=single(subtracted-offset);
%subtracted(isnan(subtracted))=offset;
end