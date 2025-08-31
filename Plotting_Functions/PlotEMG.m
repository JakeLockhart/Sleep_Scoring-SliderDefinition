function PlotEMG(ax, Data)
    % <Documentation>
        % PlotWhiskerAngle()
        %   Created by: jsl5865 & jaf6480
        % Description:
        %   Pre-process and create a plot of the EMG data. To be used in UI_SleepScoring().
        %   
    % <End Documentation>

    % Initialization

    % Create Plot
        plot(ax, (1:length(Data.EMG.emg))/Data.dsFs,Data.EMG.emg, ...
            'color','k', ...
            'LineWidth',1 ...
            );

    % Plot Labels
        ylabel(ax, 'EMG Power (V^2)')
        legend(ax, 'EMG Power')
        ax.Legend.AutoUpdate = 'off';

        set(ax, 'box', 'off')

end