function PlotWhiskerAngle(ax, Data)
    % <Documentation>
        % PlotWhiskerAngle()
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
        [z1,p1,k1] = butter(4,10/(Data.dsFs/2),'low');
        [sos1,g1] = zp2sos(z1,p1,k1);

        filteredWhiskerAngle = filtfilt(sos1,g1,Data.whiskerAngle);


    % Create Plot
        plot(ax, (1:length(filteredWhiskerAngle))/Data.dsFs,-filteredWhiskerAngle, ...
            'color',[0.8 0.1 0.4], ...
            'LineWidth',1 ...
            );

    % Plot Labels
        ylabel(ax, 'Angle (deg)')
        legend(ax, 'Whisker Angle')
        ax.Legend.AutoUpdate = 'off';

        set(ax,'box','off')

end