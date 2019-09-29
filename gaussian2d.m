function filtered=gaussian2d(video,dim,var)

filtered=zeros(size(video));
j=fspecial('gaussian',dim,var);

nFrame=size(video,3);
h=waitbar(0,'filtering....');

for k=1:nFrame
    
filtered(:,:,k)=imfilter(video(:,:,k),j,'replicate');
waitbar(k/nFrame)

end

close(h)