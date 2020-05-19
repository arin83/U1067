% this function perform an alignment among two sequences using zero-mean
% normalized cross-correlation. Differently from xcorr function it uses 
% the convolution function to do so. Hence, the
% data do not need to be detrended or offset-adjusted(?).
%output correlaton and lagv mimick the output from xcorr function

function [correlation lagv]= ccorZNCC(sequence, kernel)

kernel=double(kernel);
sequence=double(sequence);

kernSize=numel(kernel);

%this first lines compute the mean of the image for each kernel position;

sequenceMean = conv2(sequence,ones(size(kernel))./kernSize,'same');

%the mean of the kernel - template
kernelMean = mean(kernel(:));

numerator = conv2(sequence,rot90(kernel-kernelMean,2),'same')-sequenceMean.*sum(kernel(:)-kernelMean);
%den1 = sqrt(myConv(sequence.^2,ones(size(kernel)))-sequenceMean.^2.*kernSize);
den1 = sqrt(conv2(sequence.^2,ones(size(kernel)),'same')-sequenceMean.^2.*kernSize);
den2 = sqrt(sum((kernel(:)-kernelMean).^2));
correlation = numerator./(den1.*den2);

%removing correlation with more then 25% padded edges

%  pad=floor(kernSize/4);
%  correlation(1:pad)=0;
%  correlation(end-pad:end)=0;

[maxVal,maxIdx] = max(correlation);
lagv=-floor((numel(kernel)-1)/2):1:length(sequence)-((round(numel(kernel)/2)));
%lag=maxIdx-round(numel(kernel)/2);

