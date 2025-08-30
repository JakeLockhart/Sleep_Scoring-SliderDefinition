function plotSpectogramECOG_sleepScoringSlider(ax, fiberdata)

    %The spectrogram plot is the last one of the figure and encompass ax6 and ax7

    %Input: procDataFileID is defined outside the function in a loop that goes through the four hours of recording

    animalID = fiberdata.animalID; % If figure title is required
    fileID = fiberdata.fileid; % If figure title is required
    % cortical and hippocampal spectrograms

    cortical_LHnormS = fiberdata.SpecData.cortical_LH.normS.*100;
    T = fiberdata.SpecData.cortical_LH.T;
    F = fiberdata.SpecData.cortical_LH.F;

    %Make the plot 
    % ax6 = subplot(7,1,[6,7]); %Just leaving seven as original bur probably this might change 
    Semilog_ImageSC(T,F,cortical_LHnormS,'y')
    axis(ax, 'xy')
    c6 = colorbar;
    ylabel(ax, c6,'\DeltaP/P (%)')
    caxis([-100,100])
    ylabel(ax, 'Frequency (Hz)')
    % set(gca,'Yticklabel','10^1')
    yticks(ax, [1 4 8 15 30 100])
    xlim(ax, [0,fiberdata.trialDuration_sec])
    xlabel(ax, 'Time (sec)')
    yyaxis(ax, 'right')
    ylabel(ax, 'ECOG')

    set(ax,'TickLength',[0,0])
    set(ax,'box','off')
    set(ax,'Yticklabel',[])

    end
    function [] = Semilog_ImageSC(x,y,C,logaxis)
    % 9/2018 Patrick Drew
    % make a surface at points x,y, of height 0 and with colors given by the matrix C
    % logaxis - which axis to plot logarithmically: 'x', 'y' or 'xy'
    surface(x,y,zeros(size(C)),(C),'LineStyle','none');
    q = gca;
    q.Layer = 'top'; % put the axes/ticks on the top layer
    if strcmp(logaxis,'y') == 1
        set(gca,'YScale','log');
    elseif strcmp(logaxis,'x') == 1
        set(gca,'XScale','log');
    elseif strcmp(logaxis,'xy') == 1
        set(gca,'XScale','log');
        set(gca,'YScale','log');
    end
    axis xy
    axis tight
end