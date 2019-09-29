%batch brightness regularization and tiff conversion for asd2tiff_GUI
%
%Usage:
%
%    batchasd2tiff returns a new folder where all asd
%    files from a user-defined list were read in matlab using the 
%    loadASD function, intensity-regularized using the vnorm function
%    (trimmed mean option) and converted into tiff files using the 
%    mat2tiff function.
%    
% -------------------------------------------------------------------------
% By Arin Marchesi
% INSERM U1067
% Marseille, 13009
% 01-February-2019
% written on MAtlab 2017a
% ------------------------------------------------------------------------

function msg=batchasd4GUI(varargin)


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

cd(folder_name);
nfiles = length(asdfiles);

%create a name for the destination folder

outname1=datestr(datetime,30);
outname2='Converted_';
outname=strcat(outname2, outname1);

mkdir(folder_name, outname)
new_folder = fullfile(folder_name,outname);

%define the trimmed mean

outV=limits*2;

if isempty(outV)||outV>100 ||outV<0
    outV=10;
end


h=waitbar(0,'computing....','Name','Progression bar','Units','Normalized',...
    'OuterPosition',[0.1 0.8 0.25 0.12]);

switch channel
    
    case 1
        
        for ii=1:nfiles
            currentfilename = asdfiles{ii};
            f = fullfile(folder_name,currentfilename);
            f2= fullfile(new_folder,currentfilename);
            [mat3D, header] = loadASD(f);
            mat3D = vnorm(mat3D,0,outV);
            fnew=strrep(f2,'.asd','.tif');
            mat2tiff(mat3D, header, fnew);
            string=sprintf('Processed %d/%d',ii,nfiles);
            waitbar(ii/nfiles, h, string);
        end
        
        msg=[num2str(nfiles) ' files converted succesfully!Channel 1 only'];
        
    case 2
                       
        for ii=1:nfiles
            currentfilename = asdfiles{ii};
            f = fullfile(folder_name,currentfilename);
            f2= fullfile(new_folder,currentfilename);
            [~, header, mat3D] = loadASD(f);            
            mat3D = vnorm(mat3D,0,outV);
            fnew=strrep(f2,'.asd','.tif');
            mat2tiff(mat3D, header, fnew);
            string=sprintf('Processed %d/%d',ii,nfiles);
            waitbar(ii/nfiles, h, string);
        end
             
                             
        msg=[num2str(nfiles) ' files converted succesfully! Channel 2 only'];
    
        case 12
            
            for ii=1:nfiles
                currentfilename = asdfiles{ii};
                f = fullfile(folder_name,currentfilename);
                f2= fullfile(new_folder,currentfilename);
                [mat3Da, header, mat3Db] = loadASD(f);                
                mat3Da = vnorm(mat3Da,0,outV);
                mat3Db = vnorm(mat3Db,0,outV);
                fnew=strrep(f2,'.asd','.tif');
                mat2tiff(mat3Da, mat3Db, header, fnew);
                string=sprintf('Processed %d/%d',ii,nfiles);
                waitbar(ii/nfiles, h, string);
            end
        
        msg=[num2str(nfiles) ' files converted succesfully!Use bio-formats to import'];
       
end

close(h);
cd(current_folder);


