function [ax4,p4] = plotPupilDiameter_sleepScoringSlider(fiberdata)

%Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

% load the necessary data
%[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional));

% Pupil data
filteredpupildiameter = fiberdata.Pupil.zDiameter;

%Make the plot 
ax4 = subplot(7,1,4); %Just leaving seven as original bur probably this might change 
p4 = plot((1:length(filteredpupildiameter))/fiberdata.dsFs,filteredpupildiameter,'color', [0.6 0 0],'LineWidth',1);
legend(p4,'Pupil Diameter')
ylabel('Diameter (Z)')
xlim([0,fiberdata.trialDuration_sec])
axis tight

%optional
set(gca,'TickLength',[0,0])
set(gca,'Xticklabel',[])
set(gca,'box','off')

end
