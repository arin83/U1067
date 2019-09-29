function printCmap(map, range, varargin)


if nargin==3
    im=varargin{1};
    bar_width=size(im,1);
    bar_length=linspace(range(1), range(2), bar_width);
else
    bar_width=length(map);
    bar_length=linspace(range(1), range(2), length(map));
end

bar_width=round(bar_width/10);
delta=abs(max(range)-min(range));


bar_image=(fliplr(repmat(bar_length,bar_width,1)))';

if nargin==3
    bar_image=cat(2,bar_image,im);
end

h=figure;

set(h,'Name','Colormap viewer','NumberTitle','off');

imagesc(bar_image,range)
colormap(map)
axis image
set(gca,'xtick',[])
limx=get(gca,'ylim') ; ytickI=[limx(1) limx(2)/4 limx(2)/2 3*limx(2)/4 limx(2)];
set(gca,'ytick',ytickI,...
    'LineWidth',2)
 set(gca,...
'yTickLabel',round([1 3/4 1/2 1/4 0]*delta+min(range),1), 'TickDir', 'out');
set(gca,'Box','off','XColor','none')

ax1 = axes('Position',[0 0 1 1],'Visible','off');
axes(ax1) % sets ax1 to current axes

[filename,path] = uiputfile('*.eps','Save as eps');
filepath=fullfile(path,filename);

print(h,'-depsc', filepath)


