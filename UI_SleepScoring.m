function SegmentedSleepStates = UI_SleepScoring(Data)
    % <Documentation>
        % SleepScoring()
        %   Interactive UI app for manually scoring sleep states with multimodal data.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   SegmentedSleepStates = UI_SleepScoring(Data)
        %   
        % Description:
        %   This function provides a graphical user interface (GUI) to inspect and define sleep
        %       states based on multimodal physiological data (EEG, EMG, Force, ECOG, Whisker, 
        %       Pupil, etc.).
        %   Additional sleep states can be added by simply appending to the ArousalStateList 
        %       variable. Currently the following states are provided as default:
        %           - Awake
        %           - Rapid Eye Movement (REM)
        %           - Non-Rapid Eye Movement (NREM)
        %   To define sleep states, use the mouse to drag the red x-line to the end of an arousal
        %       state. When a region is defined the GUI is updated with a sleep state based on the
        %       button (or key) pressed which is shown via both a color and a dotted x-line.
        %   500 second intervals are displayed to improve accuracy. The scroll wheel on a mouse
        %       is used to control the interval displayed by adjusting the x-limit of the plotted
        %       data.
        %           - Scroll ↑ to advance through data
        %           - Scroll ↓ to rewind through data
        %   Keyboard shortcuts:
        %       - 'r' used to reset x-limits to display entire sleep data series. Simply adjust the
        %         scroll wheel to re-adjust the x-limits   
        %   Note that the input to this function must be in the form of Data.(Sensor). Currently the
        %       following sensors can be input within the Data structure. The order does not matter, 
        %       neither does excluding some sensor types. Each of these modalities have a corresponding
        %       plotting function called in the helper functions section of this code. To add an 
        %       additional modality, the PlottingFunctions variable must be updated with the data type
        %       and the corresponding plotting function.
        %           - EEG
        %           - EMG
        %           - Force
        %           - ECOG
        %           - Whisker
        %           - Pupil
        %   
        % Input:
        %   Data - A structure containing one or more physiological signals. Each field should 
        %          correspond to a modality (e.g., EEG, EMG, ECoG, etc.) and must include relevant 
        %          time and signal data.        
        %   
        % Output:
        %   SegementedSleepStates - A structure containing manually defined interavals for
        %                           each arousal state. One field per arousal state containing
        %                           arrays of [start, end] indices of each segement of the 
        %                           region.
        %   
    % <End Documentation>

    %% Initialization
        ArousalStateList = {"Awake", "REM", "NREM"};
        ModalityList = {'ECOG', 'EMG', 'Force', 'Pupil', 'Spectogram', 'Whisker'};

        SelectedModalities = listdlg("ListString", ModalityList, ...
                                     "SelectionMode", "multiple", ...
                                     "ListSize", [250, 100] ...
                                    );

        Colors = hsv(numel(ArousalStateList));
        ColorsHSV = rgb2hsv(Colors);
        ColorsHSV(:,2) = ColorsHSV(:,2) * 0.4;
        ColorsHSV(:,3) = 0.9;
        ColorMap = hsv2rgb(ColorsHSV);

        PlottingFunctions = containers.Map(ModalityList, ...
                                           {@Plot_ECOG, @Plot_EMG, @Plot_Force, @Plot_Pupil, @Plot_Spectogram, @Plot_Whisker} ...
                                          );

        Fields = ModalityList(SelectedModalities);
        ReferenceIndex = 1;
        ActiveIndex = 1;
        MaxIndex = Data.trialDuration_sec;
        SpanIndices = 500; 
        CurrentSpan = SpanIndices/2;

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
                    ActiveFunction(ax(i), Data);
                end
            
                xlim(ax(i), [1, SpanIndices]);

                if length(fieldnames(Data)) < 3
                    YData = get(ax(i).Children, 'YData');
                    
                    if iscell(YData)
                        YData = cell2mat(YData(:));
                    end

                    YMin = min(YData);
                    YMax = max(YData);
                    Padding = 0.1*(YMax - YMin);
                    
                    ylim(ax(i), [YMin-Padding, YMax+Padding]);
                end
            end

        %% Controls
            %% Define Region Interval (Slider)
                hold(ax(:), 'on')
                Slider = xline(ax(1), ReferenceIndex, 'r', 'LineWidth', 3, 'HitTest', 'on', 'PickableParts', 'all');
                Tolerance = 10;
                ActiveDrag = false;

                Window.WindowButtonMotionFcn = @SliderMotion;
                Window.WindowButtonDownFcn = @StartMotion;
                Window.WindowButtonUpFcn = @EndMotion;
                Window.WindowScrollWheelFcn = @ScrollThroughData;

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
        %% Plotting functions - {@Plot_ECOG, @Plot_EMG, @Plot_Force, @Plot_Pupil, @Plot_Spectogram, @Plot_Whisker}
                function Plot_ECOG(ax, Data)
                    plotECOG_sleepScoringSlider(ax, Data);
                end

                function Plot_EMG(ax, Data)
                    plotEMGPower_sleepScoringSlider(ax, Data);
                end

                function Plot_Force(ax, Data)
                    plotForceSensor_sleepScoringSlider(ax, Data);
                end

                function Plot_Pupil(ax, Data)
                    plotPupilDiameter_sleepScoringSlider(ax, Data);
                end

                function Plot_Spectogram(ax, Data)
                    plotSpectogramECOG_sleepScoringSlider(ax, Data);
                end

                function Plot_Whisker(ax, Data)
                    plotWhiskerAngle_sleepScoringSlider(ax, Data);
                end

        %% UI Controls
            % Keyboard shortcuts
                function KeyPressHandler(~, event)
                    switch event.Key
                        case 'escape'    % Saves regions and close window
                            CloseWindow();
                        case 'r'
                            ReviewScoring(); 
                        otherwise
                            Key = str2double(event.Key);
                            if ~isnan(Key) && 1 <= Key && Key <= length(ArousalStateList)
                                DefineSleepRegion(ArousalStateList{Key}, ColorMap(Key, :));
                            end  
                    end
                end

                function CloseWindow()
                    if isvalid(Window)
                        uiresume(Window)
                        delete(Window)
                    end
                end

                function ReviewScoring
                    xlim(ax(:), [1, MaxIndex]);
                end

            % Scroll wheel to move through data
                function ScrollThroughData(~, event)
                    SpanStep = 60;
                    if event.VerticalScrollCount > 0
                        CurrentSpan = max(1 + SpanIndices/2, CurrentSpan - SpanStep);
                    else
                        CurrentSpan = min(MaxIndex - SpanIndices/2, CurrentSpan + SpanStep);
                    end

                    Min_x = round(CurrentSpan - SpanIndices/2);
                    Max_x = round(CurrentSpan + SpanIndices/2);
                    Min_x = max(1, Min_x);
                    Max_x = min(MaxIndex, Max_x);
                    for k = 1:length(ax)
                        xlim(ax(k), [Min_x, Max_x])
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