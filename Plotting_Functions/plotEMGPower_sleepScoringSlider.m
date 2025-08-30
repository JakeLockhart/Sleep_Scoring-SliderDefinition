function p2 = plotEMGPower_sleepScoringSlider(ax, fiberdata)

    %Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

    % load the necessary data
    % load(procDataFileID)
    %[animalID,fileDate,fileID] = GetFileInfo_FP(procDataFileID); % this only if we want the file name ID in the tittle of the figure (optional)

    % EMG data for plotting 
    % EMG = ProcData.data.EMG.emg;

    %Make the plot 
    % ax2 = subplot(7,1,2); %Just leaving seven as original bur probably this might change 
    % p2 = plot((1:length(EMG))/ProcData.notes.dsFs,EMG,'color','k','LineWidth',1);
    p2 = plot(ax, (1:length(fiberdata.EMG.emg))/fiberdata.dsFs,fiberdata.EMG.emg,'color','k','LineWidth',1);
    ylabel(ax, 'EMG Power (V^2)')
    xlim(ax, [0, fiberdata.trialDuration_sec])
    legend(ax, p2, 'EMG Power', Location='eastoutside')
    set(ax,'TickLength',[0,0])
    set(ax,'Xticklabel',[])
    set(ax,'box','off')
    axis(ax, 'tight')

    %optional
    set(ax,'TickLength',[0,0])
    set(ax,'Xticklabel',[])
    set(ax,'box','off')
    axis(ax, 'tight')
end
