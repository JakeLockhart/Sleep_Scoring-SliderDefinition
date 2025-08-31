function PlotECOG(ax, Data)
    % <Documentation>
        % PlotWhiskerAngle()
        %   Created by: jsl5865 & jaf6480
        % Description:
        %   Pre-process and create a plot of the whisker data. To be used in UI_SleepScoring().
        %   
    % <End Documentation>

    % Initialization
        EEG_LH = Data.cortical_LH.corticalSignal;
        EEG_LH(1:Data.dsFs) = EEG_LH(Data.dsFs+1:Data.dsFs*2);
        EEG_LH = medfilt1(EEG_LH,3);

    % Create Plot
        plot(ax, (1:length(EEG_LH))/Data.dsFs,EEG_LH, ...
            'color',[0.9137 0.4118 0.1725], ...
            'LineWidth',1 ...
            );

    % Plot Labels
        ylabel(ax, 'ECoG (uV)')
        legend(ax, 'ECOG')
        ax.Legend.AutoUpdate = 'off';

        set(ax, 'box', 'off')

end