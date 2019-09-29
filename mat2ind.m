function videoI=mat2ind(video,range,n)

%   MAT2IND Convert intensity image to indexed image.
%
%
%   N must be an integer between 1 and 65536.




if nargin < 3
    n=256;
end

video=mat2gray(video,range);
[videoI, map]= gray2ind(video, n);


