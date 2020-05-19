function videoStat(video)


%calculate range for displaying

range(1)=mean2(video)-std2(video);

%create a quick brightness visualization


video=reshape(video,[],size(video,3));

% brightness 

bri=mean(video);
varBri=std(bri);

%normalized std. devietion coefficient


%display everything

h=figure('Name','Quick Video Statistics','NumberTitle','off','Units', 'Normalized', 'Position', [0.3, 0.4, 0.5, 0.2]);
colormap gray


hold on 
p(1)=plot(bri);
limx=get(gca,'xlim') ;
set(gca,'ylim',[min(bri) max(bri)])
msg=sprintf('Std %6.4f',varBri);
text(0.8,0.9,msg,'Units','normalized', 'FontSize',7);
line(limx,[mean(bri) mean(bri)],'color','r','linestyle',':')
hold off
title('Frame brightness','Color','r','Fontweight','bold')
ylabel('Pixel intensity','FontSize',10)
xlabel('Frame','FontSize',10)






