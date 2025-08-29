function [ax5,p5] = plotECOG_sleepScoringSlider(fiberdata)

%Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

% load the necessary data
%[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional));

% ECOG data
EEG_LH =fiberdata.cortical_LH.corticalSignal;
% remove some extra data
EEG_LH(1:fiberdata.dsFs) = EEG_LH(fiberdata.dsFs+1:fiberdata.dsFs*2);
EEG_LH = medfilt1(EEG_LH,3);

%Make the plot 
ax5 = subplot(7,1,5); %Just leaving seven as original bur probably this might change 
p5 = plot((1:length(EEG_LH))/fiberdata.dsFs,EEG_LH,'color',[0.9137 0.4118 0.1725],'LineWidth',1);
xlim([0,fiberdata.trialDuration_sec])
ylabel('ECoG (uV)')
legend(p5, 'ECoG')
axis tight

%optional
set(gca,'TickLength',[0,0])
set(gca,'Xticklabel',[])
set(gca,'box','off')

end
