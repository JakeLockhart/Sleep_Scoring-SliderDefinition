function PlotForce(ax, Data)
    % <Documentation>
        % PlotWhiskerAngle()
        %   Created by: jsl5865 & jaf6480
        % Description:
        %   Pre-process and create a plot of the force sensor data. To be used in UI_SleepScoring().
        %   
    % <End Documentation>

    % Initialization
        [z1,p1,k1] = butter(4,10/(Data.dsFs/2),'low');
        [sos1,g1] = zp2sos(z1,p1,k1);

        filtForceSensor = filtfilt(sos1,g1,Data.forceSensor);

    % Create Plot
        plot(ax, (1:length(filtForceSensor))/Data.dsFs,filtForceSensor, ...
            'Color',[0.0 0.5216 0.2431], ...
            'LineWidth',1 ...
            );

    % Plot Labels
        ylabel(ax, 'Force Sensor (V)')
        legend(ax, 'Force Sensor')
        ax.Legend.AutoUpdate = 'off';

        set(ax, 'box', 'off')

end