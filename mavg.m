function avg=mavg(video)

nFrames=size(video,3);
prompt = {'moving average n'};
navg=str2double(inputdlg(prompt));

avg=movmean(video,navg,3);


