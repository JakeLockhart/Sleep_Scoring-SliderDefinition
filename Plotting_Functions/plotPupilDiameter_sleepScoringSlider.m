function PlotPupilDiameter(ax, Data)
    % <Documentation>
        % PlotPupilDiameter()
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