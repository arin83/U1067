function [unionVideo]=videoUnion(driftVideo)

%this funcrion is used to minimize the canvas size around an image to it's
%smaller possible size


 %creating the intersection of all the slides
masked = imdilate(driftVideo,ones(3,3)) > imerode(driftVideo,ones(3,3));
maskedStk=sum(masked,3);
maskedStk(maskedStk>0)=1;
%extractin the bounding rectanfle from the union mask of all frames
stats=regionprops(maskedStk,'BoundingBox');
rect = floor(stats.BoundingBox);
    
unionVideo=driftVideo(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
    
unionVideo = im2single(unionVideo);

end