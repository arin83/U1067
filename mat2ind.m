function videoI=mat2ind(video,range)

%   MAT2IND Convert intensity image to 8 bit indexed image.

range=double(range);


video=mat2gray(video,range);
videoI= im2uint8(video);


