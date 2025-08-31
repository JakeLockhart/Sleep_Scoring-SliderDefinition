function PlotPupilDiameter(ax, Data)
    % <Documentation>
        % PlotWhiskerAngle()
        %   Created by: jsl5865 & jaf6480
        % Description:
        %   Pre-process and create a plot of the pupil diameter data. To be used in UI_SleepScoring().
        %   
    % <End Documentation>

    % Initialization
        filteredpupildiameter = Data.Pupil.zDiameter;

    % Create Plot
        plot(ax, (1:length(filteredpupildiameter))/Data.dsFs,filteredpupildiameter, ...
            'color', [0.6 0 0], ... 
            'LineWidth',1 ...
            );

    % Plot Labels
        ylabel(ax, 'Diameter (Z)')
        legend(ax,'Pupil Diameter')
        ax.Legend.AutoUpdate = 'off';

        set(ax,'box','off')

end