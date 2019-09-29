function header=loadASDh(fullFileName)

if nargin ==0
    [filename filepath]=uigetfile('*.asd','Select an asd file to be open');
    fullFileName = fullfile(filepath, filename);
end


%checking file/directory existence
[pathstr, filename, ext] = fileparts(fullFileName);
if ~isdir(pathstr)
	errorMessage1 = sprintf('Error: The following folder does not exist:\n%s', pathstr);
	uiwait(warndlg(errorMessage1));
	error('Error!! Wrong directory and/or file!');
end

if strcmpi(ext, '.asd')==0
    errorMessage2 = sprintf('Error: Wrong filename and/or extension for:\n%s', strcat(filename,ext));
	uiwait(warndlg(errorMessage2));
	error('Error!! Wrong directory and/or file!');
end


%reading the file version
fid=fopen(fullFileName,'r');
header.Version=fread(fid,1,'int');

if header.Version > 2
   vString=sprintf('Sorry, asd file version %d is currently not supported', header.Version);
   uiwait(warndlg(vString,'!! Warning !!'));
   error('Error!! non supported version!');
end

switch header.Version

    case 0
        
        frewind(fid);
        fseek(fid,8,'bof');
        header.HeaderSize=fread(fid,1,'int');
        header.fHeaderSize=fread(fid,1,'int');
        fseek(fid,4,'cof');
        header.offComment=fread(fid,1,'int');
        header.sizeComment=fread(fid,1,'int');
        header.Xpixel=fread(fid,1,'short');
        header.Ypixel=fread(fid,1,'short');
        header.Xrange=fread(fid,1,'short');
        header.Yrange=fread(fid,1,'short');        
        header.AcqTime=fread(fid,1,'float');
        header.ZpiezoCalib=fread(fid,1,'float');
        header.Zgain=fread(fid,1,'float');
        header.ADrangeCode=fread(fid,1,'int');
        
        switch header.ADrangeCode
            case 262144
            header.ADrange=10;
            case 65536
            header.ADrange=2;  
            case 131072
            header.ADrange=5; 
            otherwise                
            stringAD=sprintf('Unknown AD code %d', header.ADrangeCode);
            header.ADrange = str2double(inputdlg('Please provide AD range',stringAD));
        end
        
        header.ADresolution=fread(fid,1,'int');
        header.ADresolution=2^header.ADresolution;
        fseek(fid,39,'cof');
        header.nFrames=fread(fid,1,'int');
        
                                                                 
       case {1, 2}
        
        frewind(fid);
        fseek(fid,4,'bof');
        header.HeaderSize=fread(fid,1,'int');
        header.fHeaderSize=fread(fid,1,'int');
        fseek(fid,4,'cof');
        header.opeSize=fread(fid,1,'int');
        header.commSize=fread(fid,1,'int');
        fseek(fid,8,'cof');
        header.nFrames=fread(fid,1,'int');
        fseek(fid,12,'cof');
        header.Xpixel=fread(fid,1,'int');
        header.Ypixel=fread(fid,1,'int');
        header.Xrange=fread(fid,1,'int');
        header.Yrange=fread(fid,1,'int');
        fread(fid,1,'bool');
        fread(fid,1,'int');
        year=fread(fid,1,'int');
        month=fread(fid,1,'int');
        day=fread(fid,1,'int');
        header.date=mat2str([year month day]);
        hour=fread(fid,1,'int');
        minute=fread(fid,1,'int');
        sec=fread(fid,1,'int');
        header.time=mat2str([hour minute sec]);
        
        fseek(fid,8,'cof');
        header.AcqTime=fread(fid,1,'float');
        fseek(fid,28,'cof');
        header.ADrangeCode=fread(fid,1,'int');
        
        
        switch header.ADrangeCode
            case 262144
            header.ADrange=10;
            case 65536
            header.ADrange=2;  
            case 131072
            header.ADrange=5; 
            otherwise  
            stringAD=sprintf('Unknown AD code %d', header.ADrangeCode);
            header.ADrange = str2double(inputdlg('Please provide AD range',stringAD));
        end
        
        header.ADresolution=fread(fid,1,'int');
        header.ADresolution=2^header.ADresolution;
        fseek(fid,16,'cof');
        header.ZpiezoCalib=fread(fid,1,'float');
        header.Zgain=fread(fid,1,'float');
        fread(fid,header.opeSize,'char');
        header.comment=(char(fread(fid,header.commSize,'char')))';
end
        
        
        
        
        
        
        
        
        
        topo=zeros(header.Xpixel, header.Ypixel, header.nFrames);