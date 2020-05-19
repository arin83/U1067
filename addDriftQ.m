function video2=addDriftQ(outQdrift,video)

%extract relevant data and reorganize
offset(:,2)=outQdrift(:,2);
offset(:,1)=outQdrift(:,3);
offset=cumsum(offset);

if isa(video,'uint8')
    video2=zeros(size(video,1)*3,size(video,2)*3,size(video,3),'uint8');
else
    
    video2=zeros(size(video,1)*3,size(video,2)*3,size(video,3),'single');
end

for k=1:size(video,3)
    video2(1*size(video,1)+offset(k,1):2*size(video,1)+offset(k,1)-1,1*size(video,2)+offset(k,2):2*size(video,2)+offset(k,2)-1,k)=video(:,:,k);
end
 
%video2=single(videoUnion(video2));