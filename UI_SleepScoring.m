function [SegmentedSleepStates, ax] = UI_SleepScoring(Data)
    % <Documentation>
        % SleepScoring()
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

    %% Initialization
        ArousalStateList = {"Awake", "REM", "NREM"};

        Colors = hsv(numel(ArousalStateList));
        ColorsHSV = rgb2hsv(Colors);
        ColorsHSV(:,2) = ColorsHSV(:,2) * 0.4;
        ColorsHSV(:,3) = 0.9;
        ColorMap = hsv2rgb(ColorsHSV);

        PlottingFunctions = containers.Map({'EEG', 'EMG', 'Force', 'ECOG', 'Whisker', 'Pupil'}, ...
                                           {@Plot_EEG, @Plot_EMG, @Plot_Force, @Plot_ECOG, @Plot_Whisker, @Plot_Pupil} ...
                                          );

        Fields = fieldnames(Data);
        ReferenceIndex = 1;
        ActiveIndex = 1;
        MaxIndex = length(Data.(Fields{1}));

        for i = 1:length(ArousalStateList)
            SegmentedSleepStates.(ArousalStateList{i}) = {};
        end

    %% Create UI Figure
        %% Define UI Layout
            Window = uifigure("Name", "Define Regions of Sleep");
            Window.WindowKeyPressFcn = @KeyPressHandler;
            
            MainLayout = uigridlayout(Window, [2,1]);
            MainLayout.RowHeight = {'1x', 'fit'};
            MainLayout.ColumnWidth = {'1x'};

        %% Data Panel - Display tiled data plots
            DataPanel = uipanel(MainLayout, "Title", sprintf('Sleep data including: %s', strjoin(Fields, ', ')));
            DataPanel.Layout.Row = 1;
            DataPanel.Layout.Column = 1;

            Tiles = tiledlayout(DataPanel, ...
                                "vertical", ...
                                'Padding', 'compact', ...
                                'TileSpacing', 'compact' ...
                               );

            ax = gobjects(length(Fields), 1);
            for i = 1:length(Fields)
                Field = Fields{i};
                ax(i) = nexttile(Tiles);
                
                if isKey(PlottingFunctions, Field)
                    ActiveFunction = PlottingFunctions(Field);
                    ActiveFunction(ax(i), Data.(Field));
                end
            end

        %% Controls
            %% Define Region Interval (Slider)
                hold(ax(:), 'on')
                Slider = xline(ax(1), ReferenceIndex, 'r', 'LineWidth', 3, 'HitTest', 'on', 'PickableParts', 'all');
                Tolerance = 10000;
                ActiveDrag = false;

                Window.WindowButtonMotionFcn = @SliderMotion;
                Window.WindowButtonDownFcn = @StartMotion;
                Window.WindowButtonUpFcn = @EndMotion;

            %% Define Sleep State for Current Interval
                StatePanel = uipanel(MainLayout, "Title", 'Define the current region');
                StatePanel.Layout.Row = 2;
                StatePanel.Layout.Column = 1;

                StatePanelLayout = uigridlayout(StatePanel, [1, length(ArousalStateList)]);
                StatePanelLayout.RowHeight = {'fit'};
                StatePanelLayout.ColumnWidth = repmat({'1x'}, 1, length(ArousalStateList));

                for i = 1:length(ArousalStateList)
                    Button = uibutton(StatePanelLayout, ...
                                      "Text", ArousalStateList{i}, ...
                                      'BackgroundColor', ColorMap(i,:), ...
                                      'ButtonPushedFcn', @(~, ~) DefineSleepRegion(ArousalStateList{i}, ColorMap(i,:)) ...
                                     );
                    Button.Layout.Row = 1;
                    Button.Layout.Column = i;
                end

    %% Wait for user to complete sleep scoring
        uiwait(Window);

    %% Helper Functions
        %% Plotting functions
            function Plot_EEG(ax,Data)
                plot(ax, Data);
            end

            function Plot_EMG(ax,Data)
                plot(ax, Data)
                axis(ax, 'tight')
                title(ax, 'Testing Force')
                xlabel(ax, 'time')
                ylabel(ax, 'power')
            end

            function Plot_Force(ax, Data)
                plot(ax, Data);
                axis(ax, 'tight')
                title(ax, 'Testing Force')
                xlabel(ax, 'time')
                ylabel(ax, 'power')
            end

            function Plot_ECOG(ax, Data)
                imagesc(ax, Data.t, Data.f, Data.spectrum);
                axis(ax, 'xy');
                colormap(ax, 'jet');
                colorbar(ax);
                xlabel(ax, 'Time')
                ylabel(ax, 'Frequency')
                title(ax, "ECoG")
            end
            
        %% UI Controls
            % Keyboard shortcuts
                function KeyPressHandler(~, event)
                    switch event.Key
                        case 'escape'    % Saves regions and close window
                            CloseWindow();
                    end
                end

                function CloseWindow()
                    if isvalid(Window)
                        uiresume(Window)
                        delete(Window)
                    end
                end

            % Button Commonds
                function DefineSleepRegion(State, Color)
                    ActiveIndex = round(Slider.Value);
                    ActiveIndex = max(1, min(MaxIndex, ActiveIndex));

                    Region = sort([ReferenceIndex, ActiveIndex]);
                    SegmentedSleepStates.(State){end+1} = Region;

                    for Plot = 1:length(ax)
                        fill(ax(Plot), ...
                             [Region(1), Region(2), Region(2), Region(1)], ...
                             [ax(Plot).YLim(1), ax(Plot).YLim(1), ax(Plot).YLim(2), ax(Plot).YLim(2)], ...
                             Color, ...
                             'FaceAlpha', 0.2, ...
                             'EdgeColor', 'none' ...    
                            );
                        xline(ax(Plot), ActiveIndex, '--k', 'LineWidth', 1);
                    end

                    ReferenceIndex = ActiveIndex;
                    Slider.Value = ReferenceIndex + 1;
                end

            % Xline motion 
                function SliderMotion(~,~)
                    CursorPosition = ax(1).CurrentPoint(1,1);
                    if ActiveDrag
                        CursorPosition = max(ReferenceIndex, min(MaxIndex, CursorPosition));
                        % Slider.Value = CursorPosition;
                        for j = 1:length(Slider)
                            Slider(j).Value = CursorPosition;
                        end
                    else
                        if abs(CursorPosition - Slider.Value) < Tolerance
                            Window.Pointer = 'right';
                        else
                            Window.Pointer = 'arrow';
                        end
                    end
                end

                function StartMotion(~,~)
                    CursorPosition = ax(1).CurrentPoint(1,1);
                    if abs(CursorPosition - Slider.Value) < Tolerance
                        ActiveDrag = true;
                    end
                end

                function EndMotion(~,~)
                    if ActiveDrag
                        ActiveDrag = false;
                    end
                end

        %% Callbacks

end