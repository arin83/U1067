function [status]=modifyASDcomment(fullFileName,newcomment)

p=inputParser;

    function check=checkfile(path)
        
        [~,~,ext]=fileparts(path);
        if exist(path,'file')==2&&strcmp(ext,'.asd')
            check=true;
            
        else
            check=false;
            warning('File does not existe or is not an .asd format')
        end
    end

addRequired(p,'fullFileName',@checkfile)
addRequired(p,'newcomment',@(x)validateattributes(x,{'char'},{'nonempyt'}))

parse(p,fullFileName,newcomment)


comm_size=length(p.Results.newcomment);



fid=fopen(p.Results.fullFileName,'r+');

%make sure is the version 1 or 2, otherwise abort
header.Version=fread(fid,1,'int');

if header.Version==1||header.Version==2
    status=sprintf('.asd Version %d',header.Version);
else
    status=sprintf('Unsupported version, operation aborted...v%d',header.Version);
    return
end

%get comment size and operator to put the comment in the right place and
%write mew siz for operator

fseek(fid,16,'bof');
header.operator_size=fread(fid,1,'int');
header.comment_size=fread(fid,1,'int');
fseek(fid,8,'cof');
header.nF=fread(fid,1,'int');
fseek(fid,12,'cof');
header.X=fread(fid,1,'int');
header.Y=fread(fid,1,'int');

%write tje new comment size in the header
fseek(fid,20,'bof');
fwrite(fid,comm_size,'int');

%copy all the data before modification
fseek(fid,165+header.operator_size+header.comment_size,'bof');
header.fl1=fread(fid,1,'int');
header.fl2=fread(fid,4,'short');
header.fl3=fread(fid,2,'float');
header.fl4=fread(fid,1,'bool');
fseek(fid,4,'cof');
header.fl5=fread(fid,1,'short');
header.fl6=fread(fid,2,'int');

framedim=[header.X*header.Y*header.nF];

header.data1=fread(fid,framedim,'short');
header.data2=fread(fid,framedim,'short');

%write the new comment

fseek(fid,165+header.operator_size,'bof');
fwrite(fid,p.Results.newcomment,'char*1');
fwrite(fid,header.fl1,'int');
fwrite(fid,header.fl2,'short');
fwrite(fid,header.fl3,'float');
fwrite(fid,header.fl4,'bool');
fseek(fid,4,'cof');
fwrite(fid,header.fl5,'short');
fwrite(fid,header.fl6,'int');

fwrite(fid,header.data1,'short');
fwrite(fid,header.data2,'short');

%add again all the data
fclose(fid);

status=[status ', modification succesfull!'];
%


end

