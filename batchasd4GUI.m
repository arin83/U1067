


function msg=batchasd4GUI(varargin)


%batchasd2tiff returns a new folder where all asd or mat files
%from a user-defined list were upload in matlab or read using the 
%loadASD function (.asd), intensity-regularized using the vnorm function
%(trimmed mean option) and converted into tiff files using the 
%mat2tiff function.

%function usage:
%(1) [message]=batchasd2tiff (listOFfiles,path) where 'listOFfile' is a cell
%string enumerating the files to be converted and 'path' is a character
%vector indicating the path. Output message will inform on the outcome of
%the operation.
%(2) [message]=batchasd2tiff (listOFfiles,path,channel) where 'listOFfile' is a cell
%string enumerating the files to be delated and 'path' is a character
%vector (or cell string) specifying the path(s). 'channel', specify which channel 
%shall be converted (e.g. 1,2, or both). Output message will inform on the outcome of
%the operation.   

% -------------------------------------------------------------------------
% By Arin Marchesi
% INSERM U1067
% Marseille, 13009
% 01-February-2019
% written on MAtlab 2017a
%
%Last update 19-May-2020
%Kanazawa University NanoLSI
%
% ------------------------------------------------------------------------

current_folder=pwd;

folder_name=varargin{1};
asdfiles=varargin{2};

if nargin>2
    channel=varargin{3};
else
    channel=1;
end

if nargin>3
    limits=varargin{4};
else
    limits=10;
end

%cd(folder_name);
nfiles = length(asdfiles);

%create a name for the destination folder

outname1=datestr(datetime,30);
outname2='Converted_';
outname=strcat(outname2, outname1);

desktop=winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop');

new_path=uigetdir(desktop,'Choose a folder');
new_folder = fullfile(new_path,outname);
mkdir(new_path, outname)

%define the trimmed mean

outV=limits*2;

if isempty(outV)||outV>100 ||outV<0
    outV=10;
end


h=waitbar(0,'computing....','Name','Progression bar','Units','Normalized',...
    'OuterPosition',[0.1 0.8 0.25 0.12]);

 errors=0;

switch channel
    
    case 1
        
        errors=0;
        
        for ii=1:nfiles
            currentfilename = asdfiles{ii};
            if iscellstr(folder_name)
                currentfolder=folder_name{ii};
            else
                currentfolder=folder_name;
            end
            f = fullfile(currentfolder,currentfilename);
            f2= fullfile(new_folder,currentfilename);
            
            if contains(currentfilename,'.asd')
                [mat3D, header] = loadASD(f);
                fnew=strrep(f2,'.asd','.tif');
            elseif contains(currentfilename,'.smat')
                load(f,'-mat')
                mat3D=AFMdata.ch1; header=AFMdata.header;
                fnew=strrep(f2,'.smat','.tif');
            else
                errors=errors+1;
                continue
            end
            
            mat3D = vnorm(mat3D,0,outV);
            
            mat2tiff(mat3D, header, fnew);
            string=sprintf('Processed %d/%d',ii,nfiles);
            waitbar(ii/nfiles, h, string);
        end
        
        msg=[num2str(errors) ' files failed to convert!Channel 1 only'];
        
    case 2
                       
        for ii=1:nfiles
            currentfilename = asdfiles{ii};
            if iscellstr(folder_name)
                currentfolder=folder_name{ii};
            else
                currentfolder=folder_name;
            end
            f = fullfile(currentfolder,currentfilename);
            f2= fullfile(new_folder,currentfilename);
            
            if contains(currentfilename,'.asd')
                [~, header, mat3D] = loadASD(f); 
                fnew=strrep(f2,'.asd','.tif');
            else                 
                errors=errors+1;
                continue
            end
                       
            mat3D = vnorm(mat3D,0,outV);
          
            mat2tiff(mat3D, header, fnew);
            string=sprintf('Processed %d/%d',ii,nfiles);
            waitbar(ii/nfiles, h, string);
        end
             
                             
        msg=[num2str(errors) ' files failed to convert!Channel 2 only'];
    
        case 12
            
            for ii=1:nfiles
                currentfilename = asdfiles{ii};
                if iscellstr(folder_name)
                    currentfolder=folder_name{ii};
                else
                    currentfolder=folder_name;
                end
                f = fullfile(currentfolder,currentfilename);
                f2= fullfile(new_folder,currentfilename);
                
                if contains(currentfilename,'.asd')
                    [mat3Da, header, mat3Db] = loadASD(f);         
                    fnew=strrep(f2,'.asd','.tif');
                else
                    errors=errors+1;
                    continue
                end
                
                      
                mat3Da = vnorm(mat3Da,0,outV);
                mat3Db = vnorm(mat3Db,0,outV);
               
                mat2tiff(mat3Da, mat3Db, header, fnew);
                string=sprintf('Processed %d/%d',ii,nfiles);
                waitbar(ii/nfiles, h, string);
            end
        
            msg=[num2str(errors) ' files failed to convert!Use bio-formats to import'];             
end

close(h);
cd(current_folder);


