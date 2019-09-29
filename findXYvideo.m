function  drift=findXYvideo(video16)

if nargin==0
    [name,path]= uigetfile('*.tif','Please, load the aligned 8/16-bit video');
    video16=loadtiff(fullfile(path,name));
end

frame16 = imdilate(video16,ones(3,3)) > imerode(video16,ones(3,3));
nframe=size(video16,3);
drift=zeros(nframe,3);

for k=1:nframe
    s=regionprops(frame16(:,:,k),'BoundingBox');
    bb=s.BoundingBox;
    drift(k,:)=[k floor(bb(1)) floor(bb(2))];
end

if nargout==0
    XYtable(drift);
end
