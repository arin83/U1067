% this function perform an alignment among two sequences using 
% normalized cross-correlation (NCC). Differently from xcorr function it uses 
% convolution to do so. Hence, the data do not need to be detrended or offset-adjusted.

%this function might have mistakes in it's implementation


function [NCC lagv]= ccorCCv2(sequence, kernel)

kernel=double(kernel);
sequence=double(sequence);

kernSize=numel(kernel);

%NCC calculation


num= conv2(sequence,rot90(kernel,2),'same');
  den1=sqrt(conv2(sequence.^2,ones(size(kernel)),'same'));
  den2=sqrt(conv2(kernel.^2,ones(size(kernel)),'same'));
  NCC=num./(den1.*den2);

%NCC=num;
%  pad=floor(kernSize/4);
%  NCC(1:pad)=0;
%  NCC(end-pad:end)=0;


lagv=-floor((numel(kernel)-1)/2):1:length(sequence)-((round(numel(kernel)/2)));