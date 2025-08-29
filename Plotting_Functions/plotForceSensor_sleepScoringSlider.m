function [ax1,p1] = plotForceSensor_sleepScoringSlider(fiberdata)

%Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

% load the necessary data
%[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional)

% setup butterworth filter coefficients for a 1 Hz and 10 Hz lowpass based on the sampling rate
[z1,p1,k1] = butter(4,10/(fiberdata.dsFs/2),'low');
[sos1,g1] = zp2sos(z1,p1,k1);

% force sensor data for plotting 
filtForceSensor = filtfilt(sos1,g1,fiberdata.forceSensor);
%
%Make the plot 
ax1 = subplot(7,1,1); %Just leaving seven as original bur probably this might change 
p1 = plot((1:length(filtForceSensor))/fiberdata.dsFs,filtForceSensor,'Color',[0.0 0.5216 0.2431],'LineWidth',1);
title('Behavioral characterization and sleep scoring')
ylabel('Force Sensor (V)')
xlim([0,fiberdata.trialDuration_sec])
legend((p1),'Force Sensor', Location='eastoutside')

%optional
set(gca,'TickLength',[0,0])
set(gca,'Xticklabel',[])
set(gca,'box','off')
axis tight
end
