function [ax3,p3] = plotWhiskerAngle_sleepScoringSlider(fiberdata)

%Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

% load the necessary data
%[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional)

% setup butterworth filter coefficients for a 1 Hz and 10 Hz lowpass based on the sampling rate
[z1,p1,k1] = butter(4,10/(fiberdata.dsFs/2),'low');
[sos1,g1] = zp2sos(z1,p1,k1);

% whisker angle data
filteredWhiskerAngle = filtfilt(sos1,g1,fiberdata.whiskerAngle);

%Make the plot 
ax3 = subplot(7,1,3); %Just leaving seven as original bur probably this might change 
p3 = plot((1:length(filteredWhiskerAngle))/fiberdata.dsFs,-filteredWhiskerAngle,'color',[0.8 0.1 0.4],'LineWidth',1);
ylabel('Angle (deg)')
xlim([0,fiberdata.trialDuration_sec])
legend(p3,'Whisker Angle')
axis tight

%optional
set(gca,'TickLength',[0,0])
set(gca,'Xticklabel',[])
set(gca,'box','off')

end
