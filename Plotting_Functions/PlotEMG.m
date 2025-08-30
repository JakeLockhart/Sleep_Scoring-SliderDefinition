function PlotEMG(ax, Data)
    % <Documentation>
        % PlotEMG()
        %   
        %   Created by: jsl5865
        %   
        % Syntax:
        %   
        % Description:
        %   
        % Input:
        %   
        % Output:
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