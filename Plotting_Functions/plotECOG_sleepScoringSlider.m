function p5 = plotECOG_sleepScoringSlider(ax, fiberdata)

    %Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

    % load the necessary data
    %[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional));

    % ECOG data
    EEG_LH =fiberdata.cortical_LH.corticalSignal;
    % remove some extra data
    EEG_LH(1:fiberdata.dsFs) = EEG_LH(fiberdata.dsFs+1:fiberdata.dsFs*2);
    EEG_LH = medfilt1(EEG_LH,3);

    %Make the plot 
    % ax5 = subplot(7,1,5); %Just leaving seven as original bur probably this might change 
    p5 = plot(ax, (1:length(EEG_LH))/fiberdata.dsFs,EEG_LH,'color',[0.9137 0.4118 0.1725],'LineWidth',1);
    xlim(ax, [0,fiberdata.trialDuration_sec])
    ylabel(ax, 'ECoG (uV)')
    legend(ax, 'ECoG', Location='eastoutside')
    axis(ax, 'tight')

    %optional
    set(ax,'TickLength',[0,0])
    set(ax,'Xticklabel',[])
    set(ax,'box','off')

end
