function PlotSpectrogram(ax, Data)
    % <Documentation>
        % PlotSpectrogram()
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
        cortical_LHnormS = Data.SpecData.cortical_LH.normS.*100;
        T = Data.SpecData.cortical_LH.T;
        F = Data.SpecData.cortical_LH.F;

    % Create Plot
        Semilog_ImageSC(ax, T,F,cortical_LHnormS,'y')

    % Plot Labels
        c6 = colorbar(ax);

        ylabel(c6,'\DeltaP/P (%)')
        clim(ax, [-100,100])
        ylabel(ax, 'Frequency (Hz)')
        yticks(ax, [1 4 8 15 30 100])
        yyaxis(ax, 'right')
        ylabel(ax, 'ECOG')

        set(ax, 'Yticklabel', [])
        set(ax,'box','off')


    function Semilog_ImageSC(ax, x,y,C,logaxis)
        imagesc(ax, 'XData', x, 'YData', y, 'CData', C);
        set(ax, 'Layer', 'top');

        if strcmp(logaxis,'y') == 1
            set(ax,'YScale','log');
        elseif strcmp(logaxis,'x') == 1
            set(ax,'XScale','log');
        elseif strcmp(logaxis,'xy') == 1
            set(ax,'XScale','log');
            set(ax,'YScale','log');
        end
        
    end
end