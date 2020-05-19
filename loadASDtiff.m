function tiffdata = loadASDtiff(varargin)
% Adapted from YoonOh Tak by AM


if nargin==1
    path=varargin{1};
elseif nargin==0
    [file,directory] = uigetfile('*.tif','Select your TIFF video');
    path = fullfile(directory, file);
end


s = warning('off', 'all'); % To ignore unknown TIFF tag.

% Frame number
tiff = Tiff(path, 'r');
frame = 0;

%read how many frames

while true
    frame = frame + 1;
    if tiff.lastDirectory(), break; end
    tiff.nextDirectory();
end

k_struct = 0;
tiff.setDirectory(1);

%get file header

n1 = tiff.getTag('ImageWidth');
m1 = tiff.getTag('ImageLength');
spp1 = tiff.getTag('SamplesPerPixel');
sf1 = tiff.getTag('SampleFormat');

Xres=tiff.getTag('XResolution');
Yres=tiff.getTag('YResolution');

if tiff.getTag('ResolutionUnit')
   Xres=Xres*10000;Yres=Yres*10000; 
end

try
    AcqTime=tiff.getTag('XMP');
catch
    AcqTime=0;
end

if AcqTime==0
    
    try
        AcqTime=tiff.getTag('DateTime');
    catch
        AcqTime=0;
    end
       
end



Xrange=round((n1/Xres)*10^11);
Yrange=round((m1/Yres)*10^11);

try
    sample=tiff.getTag('Artist');
catch
    sample='Unkown';
end

try
    microscope=tiff.getTag('Make');
catch
    microscope='Unkown';
end

try
    cantilever=tiff.getTag('Model');
catch
    cantilever='Unkown';
end

try
    comment=tiff.getTag('ImageDescription');
catch
    comment='Unkown';
end


header=struct('Xpixel',n1,'Ypixel',m1,'date','???','time','???',...
    'sample',sample,'Xrange',Xrange,'Yrange',Yrange,'microscope',microscope,...
    'cantilever',cantilever,'comment',comment,'AcqTime',AcqTime);

 if sf1~=3
     msg='not expected data format. This function expect IEEE floating point format tiff.';
     error(msg)
 end
 
bpp1 = tiff.getTag('BitsPerSample');



if bpp1==8 || bpp1==16
    msg='Not expected bits per sample. This function expect 32 bit data.';
    error(msg)
elseif bpp1==64
    msg='Bist per sample are 64. Data will be saved in 32 bit format.';
    worning(msg)
end

%write the images


if spp1 == 1
    oimg = zeros(m1, n1, frame, 'single'); % 1-channel
    for kf = 1:frame
        tiff.setDirectory(kf);
        oimg(:, :, kf) = tiff.read();
    end
    Ch1_data=oimg;
    Ch2_data=[];
else
    oimg = zeros(m1, n1, spp1, frame, 'single'); % multichannel
    for kf = 1:frame
        tiff.setDirectory(kf);
        oimg(:, :, :, kf) = tiff.read();
    end
        
        Ch1_data(:,:,:)=oimg(:,:,1,:);
        Ch2_data(:,:,:)=oimg(:,:,2,:);
end



tiff.close();

warning(s);


tiffdata={header, Ch1_data, Ch2_data};



