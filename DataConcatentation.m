function FinalSleepData = DataConcatentation(FileDirectory)
    % <Documentation>
        % DataConcatentation()
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

    % Give me an output that is the of the following form:
        % FinalSleepData = struct(
        %                           EMG
        %                           Force
        %                           ECOG.t
        %                               .f
        %                               .spectrum
        %                        )

    AnalogData = io_main(FileDirectory);
    EcogData = ecogprocess(AnalogData.analog.info.analogfreq, AnalogData.analog.data.raw_ECoG);
    EcogData.t = EcogData.t_axis;
    EcogData.f = EcogData.f_axis;
    EcogData.spectrum = EcogData.log_norm_spectrum;

    FinalSleepData.EMG = AnalogData.analog.data.raw_EMG;
    FinalSleepData.Force = AnalogData.analog.data.raw_Force;
    FinalSleepData.ECOG.t = EcogData.t;
    FinalSleepData.ECOG.f = EcogData.f;
    FinalSleepData.ECOG.spectrum = EcogData.log_norm_spectrum;

end