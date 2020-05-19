function mat2tiff(data, varargin)
%convert X-by-Y-by-T matrices in a multi-page TIFF 
%
%Inputs:
%   data = X-by-Y-by-T matrix corresponding to an X-Y-Time image sequence,
%   as output from the loadASD.m function

%   data2 = X-by-Y-by-T matrix corresponding to an X-Y-Time image sequence,
%   as output from the loadASD.m function
%   
%   header = structure (as output from loadASD.m function) specifying
%   image metadata
%
%   fullFileName = specify the full file location and name of your new .tif file
%   (e.g. C:\Documents\MATLAB\imaging\myVideo.tif)
%   or alternatively do not provide any input (i.e. type ">>mat2tiff(data)")
%   to place and save the file using the modal dialog box called by uiputfile

%Usage:
%    mat2tiff(data, data2, header, fullFileName) convert X-by-Y-by-T numeric matrix data 
%    (as from the loadASD.m function output) in a multi-page TIFF  
%    in single-precision floating-point format (32 bit). This files can be read
%    by imageJ/FIJI (if only one channel is present) or imageJ plugin bioimporter (for two
%    chennels data)
%    
% -------------------------------------------------------------------------
% By Arin Marchesi
% INSERM U1006
% Marseille, 13009
% 12-October-2017
% updated 11-February-2019
% written on MAtlab 2017a
% ------------------------------------------------------------------------

narginchk(1,4);

    classes = {'numeric'};
    attributes_data = {'size',[NaN,NaN,NaN]}; %make sure is a 3D matrix
    validateattributes(data,classes,attributes_data);
    data=single(data);


%if not provided build the path for the .tiff file
switch nargin

    case 1
        
    [filename, filepath]=uiputfile('*.tif','Save data as tiff');
    fullFileName = fullfile(filepath, filename);
    s=size(data,3);
    
    case 2
        
        if ischar(varargin{1})
            fullFileName=varargin{1};
           
        else
            header=varargin{1};
            validateattributes(header,{'struct'},{'nonempty'},2);
            [filename, filepath]=uiputfile('*.tif','Save data as tiff');
            fullFileName = fullfile(filepath, filename);
        end
    
    s=size(data,3);   
    
    case 3
        
    header=varargin{1};
    validateattributes(header,{'struct'},{'nonempty'},2);
    fullFileName=varargin{2};    
    validateattributes(fullFileName,{'char'},{'nonempty'},3);          
    s=size(data,3);
    
    case 4 
    data2=single(varargin{1}); 
    attributes_data= {'size',size(data)};
    validateattributes(data2,classes,attributes_data,2);
    
    header=varargin{2};
    validateattributes(header,{'struct'},{'nonempty'},3);
    
    fullFileName=varargin{3}; 
    validateattributes(fullFileName,{'char'},{'nonempty'},4);  
    
    %combine the 3D matrices in a 4D x-y-time-2 matrix
    data4d=cat(4,data,data2);
    data4d=permute(data4d,[1 2 4 3]);
    s=size(data4d,4);
end


%checking directory existence and extension name
[pathstr, filename, ext] = fileparts(fullFileName);
if ~isdir(pathstr)
	errorMessage1 = sprintf('Error: The following folder does not exist:\n%s', pathstr);
	uiwait(warndlg(errorMessage1));
	error('Error!! Wrong directory and/or file!');
end

if strcmpi(ext, '.tif')==0
    ext='.tif';
    fullFileName = fullfile(pathstr, strcat(filename, ext));
end


   t = Tiff(fullFileName, 'w');
   tagstruct.ImageLength = size(data, 1);
   tagstruct.ImageWidth = size(data, 2);
   tagstruct.Compression = Tiff.Compression.None;
   tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
   tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
   tagstruct.BitsPerSample =  32;
   
   
   if nargin==4
       tagstruct.SamplesPerPixel = 2;
   else %how many channels are in the image?
       tagstruct.SamplesPerPixel = 1;
   end
   
   tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
   tagstruct.Software='asd2tiff_GUI - Arin Marchesi';
   
   %checking for user-supplied metadata and updating
   if exist('header','var')
       tagstruct.ResolutionUnit=Tiff.ResolutionUnit.Centimeter;
       tagstruct.XResolution=(header.Xpixel/header.Xrange)*10^7;
       tagstruct.YResolution=(header.Ypixel/header.Yrange)*10^7;
       AcqTime=num2str(round(header.AcqTime));
       
       if contains(AcqTime,'ms x frame')
           AcqTime=AcqTime;
       else
           AcqTime=[AcqTime, ' ms x frame'];
       end
       
       tagstruct.DateTime=AcqTime;
              
       try
           tagstruct.ImageDescription=regexprep(header.comment,'\s+',' ');
       catch
           tagstruct.ImageDescription='no info';
       end
       
       
       if all(isfield(header,{'sample','microscope','cantilever'}))
           tagstruct.Artist=regexprep(header.sample,'\s+',' ');
           tagstruct.Make=regexprep(header.microscope,'\s+',' ');
           tagstruct.Model=regexprep(header.cantilever,'\s+',' ');
       end
       
       
   end
   
   h=waitbar(0,['converting to tiff....' filename]);
   h.Children.Title.Interpreter = 'none';
   
   for k=1:s
            
       t.setTag(tagstruct);
    
       
       if nargin==4
           t.write(data4d(:,:,:,k));
       else
           t.write(data(:,:,k));
       end
       
       t.writeDirectory();
       waitbar(k/s)
   end
   
   close(h);
   t.close();