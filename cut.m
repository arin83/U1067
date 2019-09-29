function cutted=cut(video,position)

nFrame=size(video,3);
position=round([position(1) position(2) position(3)-1 position(4)-1]);

if nFrame==1
cutted=imcrop(video,position);
else

    if size(position,1)==1
        position=repmat(position,nFrame,1);


    prompt={'first frame',...
            'last frame'};
    name='frame selection';
    numlines=1;

    defaultanswer={'1',num2str(nFrame)};

    options.Resize='on';
    options.WindowStyle='normal';

    answer=str2double(inputdlg(prompt,name,numlines,defaultanswer,options));
    start=answer(1,1);
    stop=answer(2,1);

    counter=1;
   cutted=single(zeros(position(1,4)+1,position(1,3)+1,stop-start));

    h=waitbar(0,'computing....');

        for k=start:stop

        cutted(:,:,counter)=imcrop(video(:,:,k),position(counter,:));
        waitbar(counter/(stop-start))
        counter=counter+1;
        end
        
    else
        position=round(position);
        rect=max(position);
        
        %make sure that the size is constant
        
        size3=position(:,3);
        size3(size3>0)=rect(3);
        position(:,3)=size3;
        
        size4=position(:,4);
        size4(size4>0)=rect(4);
        position(:,4)=size4;
        
        
         cutted=single(zeros(max(position(:,4))+1,max(position(:,3))+1,nFrame-1));
         h=waitbar(0,'computing....');
        counter=1;
        
            for k=1:nFrame-1
                if position(k,3)==0 || isnan(position(k,3))
                    counter=counter+1;
                else
                cutted(:,:,counter)=imcrop(video(:,:,k),position(k,:));
                waitbar(counter/(nFrame-1))
                counter=counter+1;
                end
            end
    end
close(h)
end
