%this function will calculate the rough drift of your image stack , frame by frame. 
%The output is a nx4 matrix, where n is the
%number of frames. The first column indicates the frame number, the second
%and third the x and y displacement and the fourth the mean (x and y)
%correlation. Different correlation metrics are available. Input arguments:
%methods (1=zero-mean normalized cross correlation, 2=normalized
%cross-correlation, 3=2D cross-correlation. Default=1 ), sr = search range in pixel
%(maximum sr corrspond to frame size, defoult is frame size/2), sf = scaling factor of the image for
%subpixel resolution (>1, default=1) by bicubic interpolation, detrend = option to remove background
%offsets)



function drift=QdriftV(video,method,sr,sf,detrend)

%project the data in 1D in x and y

vX=squeeze(mean(video,1));
vY=squeeze(mean(video,2));

%check for optional variables, if they do not exist set deafualt settings

if exist('method','var')==0
    method=1;
end

if exist('sr','var')==0
    sr=round(size(video,1)/100);
end

if exist('sf','var')==0
    sf=1;
end

if exist('detrend','var')==0
    detrend=0;
end

%method=4;
%removing possible offests by subtracting the mean to each frame

%average intensity excluding 0s (sum(vX~0,1) is a count of non zero values
%per row) -> for alignment videos including a 0s frame

 mX=sum(vX,1)./sum(vX~=0,1);
 mY=sum(vY,1)./sum(vY~=0,1);
 mX=repmat(mX,size(vX,1),1);
 mY=repmat(mY,size(vY,1),1);
 
 vX=vX-mX;
 vY=vY-mY;

count=2;

%countD=1;

lengthV=size(video,3);


%resizing for subpixel resolution

tolerance=3*sf; %acceptable mismatch between two correlation evaluation in pixel/sf

vX=imresize(vX, [size(vX,1)*sf size(vX,2)]);
vY=imresize(vY, [size(vY,1)*sf size(vY,2)]);

%flattening the projection data

 if detrend==1
     
     %
     
     BGvX=movmean(vX,round(size(vX,1)/2),1);
     vX=vX-BGvX;
     %
     
     BGvY=movmean(vY,round(size(vY,1)/2),1);
     vY=vY-BGvY;
     
 end

%initializing variables

conX=ones(lengthV,1);
conY=ones(lengthV,1);
Rxm=ones(lengthV,1);
Rym=ones(lengthV,1);
dX=zeros(lengthV,1);
dY=zeros(lengthV,1);
t=zeros(lengthV,1);
Rx=zeros(size(video,2)*sf,lengthV);
Ry=zeros(size(video,1)*sf,lengthV);

discrepancy=[0 0];

%calculation
tic
dt=1;

%define the correlation function to be used

switch method
    
    case 1
        
        mainFun=@ccorZNCC; %zero-mean normalized CC
        
    case 2
        
        mainFun=@ccorNCC;  %normalized cross correlation
        
    case 3
        
        mainFun=@ccorCC;  %2D correlation
        
    case 4
        
        mainFun=@ccorZNCCv3; %variaton of zero-maen ZNCC
end

        
        for k=1:1:lengthV
            
            if k+1>lengthV
                break
            end
            
            [Rx(:,count) lagx]=mainFun(vX(:,k),vX(:,k+dt));
            %[Rx(:,count) lagx]=xcorr(vX(:,k),vX(:,k+dt),40*sf,'coeff');
            
            %zeros crosscorrelation beyond searching range
            
            Rx(1:sr*sf,count)=0; Rx(end-sr*sf:end,count)=0;
            
            %find maximum
            [Rxm(count) im]=max(Rx(:,count));
            dX(count)=lagx(im);
            t(count)=k;
            
            [Ry(:,count) lagy]=mainFun(vY(:,k),vY(:,k+dt));
            %[Ry(:,count) lagy]=xcorr(vY(:,k),vY(:,k+dt),40*sf,'coeff');
            
            %zeros crosscorrelation beyond searching range
            
            Ry(1:sr*sf,count)=0; Ry(end-sr*sf:end,count)=0;
            
            %find maximum
            
            [Rym(count) im]=max(Ry(:,count));
            dY(count)=lagy(im);
            
            
            %control scheme for X (is the displacement between
            %frame k-1 and k+1 equal to the sum of the displacements between k-1 and
            %k and k and k+1?)
                       
            
            
            if k-1>0
                
                [Rx_1 lagx_1]=mainFun(vX(:,k-1),vX(:,k+1));
                %[Rx_1 lagx_1]=xcorr(vX(:,k-1),vX(:,k+dt),40*sf,'coeff');
                
                Rx_1(1:sr)=0; Rx_1(end-sr:end)=0;
                
                [~, im_1]=max(Rx_1);
                dX_1=lagx(im_1);
                devX=dX(count)+dX(count-1)-dX_1;
                
                conX(count)=abs(devX)<tolerance;
                
                if conX(count)==0
                    
                    discrepancy(1)=discrepancy(1)+1;
                    
                end
            end
            
            %control scheme for Y
            
            if k-1>0
                
                [Ry_1 lagy_1]=mainFun(vY(:,k-1),vY(:,k+dt));
                %[Ry_1 lagy_1]=xcorr(vY(:,k-1),vY(:,k+dt),40*sf,'coeff');
                
                Ry_1(1:sr)=0; Ry_1(end-sr:end)=0;
                
                [~, im_1]=max(Ry_1);
                dY_1=lagy(im_1);
                devY=dY(count)+dY(count-1)-dY_1;
                conY(count)=abs(devY)<tolerance;
                
                if conY(count)==0 && k+2*dt<lengthV
                    
                    discrepancy(2)=discrepancy(2)+1;

                end
            end
            
              
           count=count+1;
        end

toc

dX=dX/sf; dY=dY/sf;

%dX(lX)=fix(dX(lX)); dY(lY)=fix(dY(lY));

dX=round(dX); dY=round(dY);

%evaluation of the alignment

mismatchX=('Alignments mismatches found in X ');
msgX=[mismatchX, num2str(discrepancy(1))];
    disp(msgX)
    
mismatchY=('Alignments mismatches found in Y ');
msgY=[mismatchY, num2str(discrepancy(2))];
    disp(msgY)

    score=~(conX&conY);
    score=1-sum(score)/lengthV;
    disp(['Alignment score ', num2str(score)])
    
    if score < 0.95
        msgS=['Alignment was not optimal, scored ' num2str(score)];
        warndlg(msgS,'Alignment score');
    end
    
% figures for debugging

figure('Name','Alignment results 1','NumberTitle','off');

hold all

plot(Rxm,'color','r')
plot(Rym,'color','b')
title('Correlation coefficients in X (red) and Y (blue)')
ylabel('Correlation')
xlabel('Frame')


hold off

figure('Name','Alignment results 2','NumberTitle','off');

subplot(1,2,1)

hold all
plot(dX,'color','r')
plot(dY,'color','b')

title('Frame-by-frame shifts')
ylabel('Shifts in pixels')
xlabel('Frame')
legend('dX','dY')
hold off

subplot(1,2,2)

hold all
plot(conX+0.05,'r--o')
plot((conY+0.05)*-1,'b--o')

title('Frame-by-frame failures')
ylabel('Consensus')
xlabel('Frame')
legend('conX','conY')
hold off

figure('Name','Alignment results 3','NumberTitle','off');

subplot(1,2,1)
surf(Rx), shading flat
title('Correlation space X')
ylabel('Lags in pixels','Rotation',-50,'FontSize',8)
xlabel('Frame','Rotation',40,'FontSize',8)
zlabel('Correlation','FontSize',8)

subplot(1,2,2)
surf(Ry), shading flat
title('Correlation space Y')
ylabel('Lags in pixels','Rotation',-50,'FontSize',8)
xlabel('Frame','Rotation',40,'FontSize',8)
zlabel('Correlation','FontSize',8)

drift=[t'; dX'; dY';((Rxm+Rym)/2)']';