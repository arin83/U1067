
function VolumeEst(video,z_scale,cf)


fig=figure('Name','Your video window');
imagesc(video,z_scale);axis image;
colormap gray
pixelSize=size(video);


h=helpdlg('select an area for computing bck noise, a flattened image is raccomanded','bck noise estimation');
uiwait(h)


cycle=1;
cyclecnt=1;




bck=imrect;
pos_bck=wait(bck);%weit until double-click in the area bck = position of your ROI
mask_bck=createMask(bck);%creating a mask for your ROI
bck_data=video(mask_bck);%apply the mask to your video to get ROI pixels

h=figure;

hold on

nBins=ceil(sqrt(length(bck_data)));
[yData xData]=hist(bck_data,nBins);
yData=yData';
xData=xData';
bar(xData,yData,1)

histfit(bck_data);
[mu_bck_data sigma_bck_data]=normfit2(bck_data);

threshold=mu_bck_data + 5*sigma_bck_data; %estimation of the threshold for the logical image

str=sprintf('threshold = %g',threshold);
title (str)

hold off
uiwait(h)

happy1=0;

my_title1='threshold assesment';
default1={num2str(threshold)};
n_lines=1;
options.WindowStyle='normal';


figure(fig)


p1=imrect;
posP1=wait(p1);%weir until double-click in the area posP1 = position of your ROI
maskp1=createMask(p1);%creating a mask for your ROI
p1data=video(maskp1);%apply the mask to your video to get ROI pixels


    
%[mu(cyclecnt,1), sigma(cyclecnt,1)] = normfit(p1data);
%the following is an ackwark way to create an image og your ROI
temp=video;
temp(~maskp1)=NaN;
temp(isnan(temp)) = 0;

while happy1==0

%the following to create a logical image wich show your particle in
%two-step filtering
binaryImage = temp > threshold;
binaryImage2 = bwareaopen(binaryImage, 20);
p1notv=video(~binaryImage & maskp1);
p1notv2=video(~binaryImage2 & maskp1);
p1v=video(binaryImage2 & maskp1);

%[mu(cyclecnt,2), sigma(cyclecnt,2)] = normfit(p1notv2);

str = sprintf('What am I doing Particle number %d', cyclecnt);
h=figure('Name',str);

subplot(2,2,1), hold on
title('2 steps - filtering'),
imshow(binaryImage2,'InitialMagnification','fit');

subplot(2,2,2), hold on
title('ROI histogram')
nBins=ceil(sqrt(length(p1data)));
[yData xData]=hist(p1data,nBins);
yData=yData';
xData=xData';

bar(xData,yData,1)
x_line=[threshold threshold];
y_line=[min(yData) max(yData)];
line(x_line,y_line, 'Color','r')

subplot(2,2,3), hold on
title('background histogram');
hist(p1notv2,(sqrt(length(p1notv2))));

subplot(2,2,4), hold on
title('detected signal histogram');
hist(p1v,(sqrt(length(p1notv2))));
hold off

default2={num2str(1)};
happy1=str2double(inputdlg('Please, confirm(1) or reject(0) the threshold',...
    my_title1,n_lines,default2,options));

if happy1==0
    prompt1 = {'Please, insert a new threshold of your choice'};
    threshold=str2double(inputdlg(prompt1,my_title1,n_lines,default1,options));
    default1={num2str(threshold)};
end

close(h)
end


h=figure;
subplot(1,2,1)

j=helpdlg('click on each white element you want analyze, double clk for lastone','element selection');
uiwait(j)

binaryImage2=bwselect(binaryImage2,4);
binaryImage2=bwlabel(binaryImage2,4);
subplot(1,2,2)
RGBbinaryImage2=label2rgb(binaryImage2);

imshow(RGBbinaryImage2)
uiwait(h)


%calculating the volume of the cap
measurements = regionprops((binaryImage2), video,'PixelValues','Area');


for k=1:numel(measurements)
    
    area(k) = measurements(k).Area;
    
    %subtract the background height to the pixels heights belonging to the
    %ROI
    
    pixel{k} = (measurements(k).PixelValues)-mu_bck_data;
    
    %maximum height is calculated from the 1% higher pixels mean
    
    pixel{k}=sort(pixel{k},'descend');
    fract=numel(pixel{k});
    alfa=fix(fract/100); 
    relMaxHeight(k)=(mean(pixel{k}(1:alfa)));
    
    %get only the pixels higher then half of the height and compute the
    %volume
    
    half_height(k)=relMaxHeight(k)/2;
    cap{k}=pixel{k}-half_height(k);
    cap{k}=cap{k}(cap{k}>0);
    cap_volume(k)=sum(cap{k})*cf^2;
end

cap_volume=cap_volume';

%calculating the surface of the cap

d_z=str2double(inputdlg('z-precision nm'));

for k=1:numel(measurements)
    
    count_per=1;
    
    while half_height(k)+(count_per-1)*d_z + mu_bck_data< max(pixel{k}) + mu_bck_data
        
        binaryImage4per=binaryImage2==k;
        Image4per=binaryImage4per.*video;
        binaryImage4per = Image4per > half_height(k)+(count_per-1)*d_z + mu_bck_data;
        
        
        per=regionprops((binaryImage4per), video,'Perimeter');
        
        %compute the perimeter for each z-slice
        perimeter(count_per)=(sum([per(:).Perimeter]))*d_z*cf;
        
        if count_per==1
            base=regionprops((binaryImage4per), video,'Area');
            area_base(k)=base.Area;
            area_base(k)=area_base(k)*cf^2;
        end
        
        
        count_per=count_per+1;
    end
    
    surf3d(k)=(area_base(k)+sum(perimeter))';
    
end

%export to excel your results

results(:,1)=surf3d;
results(:,2)=cap_volume;
[file,path] = uiputfile('*.xls','Save file');
filename=fullfile(path, file);
header={'Suface','Volume'};
xlswrite(filename,header)
xlswrite(filename,results,1,'a2')


figure

subplot(1,2,1)
plot(cap_volume,'*')
title('Volume')
xlabel('Clathrin ball')
ylabel('Volume in nm^3')

subplot(1,2,2)
plot(surf3d,'*')
title('Area')
xlabel('Clathrin ball')
ylabel('Area in nm^2')

