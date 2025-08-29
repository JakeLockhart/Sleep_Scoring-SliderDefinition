function [ax2,p2] = plotEMGPower_sleepScoringSlider(fiberdata)

%Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

% load the necessary data
% load(procDataFileID)
%[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional)

% EMG data for plotting 
% EMG = ProcData.data.EMG.emg;

%Make the plot 
ax2 = subplot(7,1,2); %Just leaving seven as original bur probably this might change 
% p2 = plot((1:length(EMG))/ProcData.notes.dsFs,EMG,'color','k','LineWidth',1);
p2 = plot((1:length(fiberdata.EMG.emg))/fiberdata.dsFs,fiberdata.EMG.emg,'color','k','LineWidth',1);
ylabel('EMG Power (V^2)')
xlim([0, fiberdata.trialDuration_sec])
legend(p2, 'EMG Power', Location='eastoutside')
set(gca,'TickLength',[0,0])
set(gca,'Xticklabel',[])
set(gca,'box','off')
axis tight

%optional
set(gca,'TickLength',[0,0])
set(gca,'Xticklabel',[])
set(gca,'box','off')
axis tight
end
