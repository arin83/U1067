
function [Ch1, header, Ch2]=loadASD(fullFileName)
%this function will convert .asd files in matlab 3d matrices
%Inputs:
%   fullFileName = specify the .asd file path and name
%   (e.g. C:\Documents\MATLAB\imaging\myVideo.asd)
%   or alternatively do not provide any input (i.e. type ">>Ch1=loadASD"
%   in the command window) to locate the file using the
%   modal dialog box called by uigetfile function
%
%Usage:
%   [Ch1 header Ch2]=loadASD(fullFileName) reads an .asd file (currently only
%    .asd versions 0 and 1 are supported) in matlab and extracts the data 
%    in X-by-Y-by-T matrices, where T is the number of frames present, and 
%    X and Y the x and y dimensions. If one output argument is provided
%    only channel 1 (Ch1) is extracted (usually Ch1graphy); with two output arguments Ch1 
%    and a structure array with file header informations; with three output 
%    arguments the channel 2 (Ch2) signal is retrived too.
% 
% -------------------------------------------------------------------------
% By Arin Marchesi
% INSERM U1006
% Marseille, 13009
% 12-October-2017
% written on MAtlab 2012a
%
%last version 14-April-2020 Matlab 2017a
% ------------------------------------------------------------------------

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

%reading the rest of the file
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
        
        
        %extracting Ch1graphy
        pos=header.HeaderSize+header.fHeaderSize+header.offComment+header.sizeComment;
        fseek(fid,pos,'bof');
        framedim=[header.Xpixel header.Ypixel];
        
        Ch1=zeros(header.Xpixel, header.Ypixel, header.nFrames,'single');
       
       
        for k=1:header.nFrames
            Ch1(:,:,k)=fread(fid,framedim,'short');
            fseek(fid,header.fHeaderSize,'cof');
        end
       
        
        if nargout==3
            
            testpos=ftell(fid);
            testsize=2*header.Xpixel*header.Ypixel*(header.nFrames-1);
            status=fseek(fid,testsize,'cof');
            
            
            if status==0
                
                fseek(fid,testpos,'bof');
                Ch2=zeros(header.Xpixel, header.Ypixel, header.nFrames,'single');
                
                for k=1:header.nFrames
                    Ch2(:,:,k)=fread(fid,framedim,'short');
                    fseek(fid,header.fHeaderSize,'cof');
                end
            else
                msg = 'Error occurred, Ch2/error signal probably not existing';
                uiwait(warndlg(msg,'!! Warning !!'));
                msg = 'Error occurred, Ch2 signal probably not existing';
                warndlg(msg,'!! Warning !!');
                Ch2=zeros(size(Ch1),'single');  %making a mock Ch2 to not have errors
                %in other functions calling asd2tiff and expecting a Ch2 as output
                
            end
            
        end
        
        fclose(fid);
        
    case {1,2}
        
        frewind(fid);
        fseek(fid,4,'bof');
        header.HeaderSize=fread(fid,1,'int');
        header.fHeaderSize=fread(fid,1,'int');
        fseek(fid,4,'cof');
        header.opeSize=fread(fid,1,'int');
        header.commSize=fread(fid,1,'int');
        header.Ch1type=fread(fid,1,'int');
        header.Ch2type=fread(fid,1,'int');
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
        header.comment=(fread(fid,header.commSize,'*char'))';
        %extracting Ch1graphy
        pos=header.HeaderSize+header.fHeaderSize;
        fseek(fid,pos,'bof');
        framedim=[header.Xpixel header.Ypixel];
        
        Ch1=zeros(header.Xpixel, header.Ypixel, header.nFrames,'single');
        
        
        for k=1:header.nFrames
            Ch1(:,:,k)=fread(fid,framedim,'short');
            %Ch1=reshape(D2Ch1,[header.Xpixel header.Ypixel header.nFrames]);
            fseek(fid,header.fHeaderSize,'cof');
        end
        
        
        if nargout==3
            
            testpos=ftell(fid);
            testsize=2*header.Xpixel*header.Ypixel*(header.nFrames-1);
            status=fseek(fid,testsize,'cof');
            
            
            if status==0
                
                fseek(fid,testpos,'bof');
                Ch2=zeros(header.Xpixel, header.Ypixel, header.nFrames,'single');
                
                for k=1:header.nFrames
                    Ch2(:,:,k)=fread(fid,framedim,'short');
                    fseek(fid,header.fHeaderSize,'cof');
                end
            else
                msg = 'Error occurred, Ch2 signal probably not existing';
                uiwait(warndlg(msg,'!! Warning !!'));
                Ch2=zeros(size(Ch1),'single');  %making a mock Ch2 to not have errors
                %in other functions calling asd2tiff and expecting a Ch2 as output
                
            end
            
        end
        fclose(fid);
end

%rearrange the data in the frame and extract Channel1 data

%if there is no informaton on channel types, assume Ch1 is topography and
%Ch2 is phase image

if ~isfield(header,'Ch1type')
    header.Ch1type=20564;
    header.Ch2type=21061;
end

switch header.Ch1type
    
    case 20564
        
        Ch1=Ch1.*-1;
        Ch1=permute(Ch1,[2 1 3]);
        Ch1=flipdim(Ch1,1);
        %reducing the data to 32-bit
        Ch1=single(Ch1);
        %scaling the data
        Ch1=Ch1*((header.ZpiezoCalib*header.ADrange)/header.ADresolution)*header.Zgain;
        
    otherwise
        
        Ch1=permute(Ch1,[2 1 3]);
        Ch1=flipdim(Ch1,1);
        %reducing the data to 32-bit
        Ch1=single(Ch1);
        %scaling the data
        Ch1=Ch1*(header.ADrange/header.ADresolution);
end

if nargout==3
    
    switch header.Ch2type
        
        case 20564
            
            Ch2=Ch2.*-1;
            Ch2=permute(Ch2,[2 1 3]);
            Ch2=flipdim(Ch2,1);
            %reducing the data to 32-bit
            Ch2=single(Ch2);
            %scaling the data
            Ch2=Ch2*((header.ZpiezoCalib*header.ADrange)/header.ADresolution)*header.Zgain;
            
        otherwise
            
            Ch2=permute(Ch2,[2 1 3]);
            Ch2=flipdim(Ch2,1);
            %reducing the data to 32-bit
            Ch2=single(Ch2);
            %scaling the data
            Ch2=Ch2*(header.ADrange/header.ADresolution);
    end
end

        %replave channels enumeration code with readable string
        
        switch header.Ch1type
            case 0
                header.Ch1type='none';
            case 20564
                header.Ch1type='topography';
            case 21061
                header.Ch1type='phase';
            otherwise
                stringCh=sprintf('Unknown channel code %d', header.Ch1type);
                header.Ch1type = inputdlg('Please provide Channel name',stringCh);
        end
        
        switch header.Ch2type
            case 0
                header.Ch2type='none';
            case 20564
                header.Ch2type='topography';
            case 21061
                header.Ch2type='phase';
            otherwise
                stringCh=sprintf('Unknown channel code %d', header.Ch2type);
                header.Ch2type = inputdlg('Please provide Channel name',stringCh);
        end


end