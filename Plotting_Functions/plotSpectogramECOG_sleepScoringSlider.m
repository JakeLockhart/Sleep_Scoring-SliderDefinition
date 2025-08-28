function [ax6] = plotSpectogramECOG_sleepScoringSlider(procDataFileID)

%The spectrogram plot is the last one of the figure and encompass ax6 and ax7

%Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

% load the necessary data
load(procDataFileID)
[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional)

% cortical and hippocampal spectrograms
specDataFile = [animalID '_' fileID '_SpecDataA.mat'];
load(specDataFile,'-mat');
cortical_LHnormS = SpecData.cortical_LH.normS.*100;
T = SpecData.cortical_LH.T;
F = SpecData.cortical_LH.F;

%Make the plot 
ax6 = subplot(7,1,[6,7]); %Just leaving seven as original bur probably this might change 
Semilog_ImageSC(T,F,cortical_LHnormS,'y')
axis xy
c6 = colorbar;
ylabel(c6,'\DeltaP/P (%)')
caxis([-100,100])
ylabel('Frequency (Hz)')
% set(gca,'Yticklabel','10^1')
yticks([1 4 8 15 30 100])
xlim([0,ProcData.notes.trialDuration_sec])
xlabel('Time (sec)')
yyaxis right
ylabel('ECOG')

set(gca,'TickLength',[0,0])
set(gca,'box','off')
set(gca,'Yticklabel',[])

end
