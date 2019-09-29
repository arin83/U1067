function video2=addDriftJ(offset,video)

video2=single(zeros(size(video,1)*3,size(video,2)*3,size(video,3)));

check=1:1:size(video,3);
offset=sortrows(offset);
lag=setdiff(check,offset(:,1));

if ~isempty(lag)&&numel(lag)==1
    insert=[lag 0 0];
    if lag-1>0 && lag<size(offset,1)
        offset=[offset(1:lag-1,:); insert; offset(lag:end,:)];
    elseif lag-1==0
        offset=[insert; offset(lag:end,:)];
    else
        offset=[offset(1:lag-1,:); insert];
    end
elseif numel(lag)>1
    message = 'Drifts can not be unambiguously matched to the frames';
    uiwait(warndlg(message));
    return
    
end

offset=offset(:,2:3);

for k=1:size(video,3)
    video2(size(video,1)+offset(k,2):2*size(video,1)+offset(k,2)-1,size(video,2)+offset(k,1):2*size(video,2)+offset(k,1)-1,k)=video(:,:,k);
end
 
video2=videoUnion(video2);