function FinalSleepData = DataConcatentation(FileDirectory)
    % <Documentation>
        % 250822_code update
        % This is temporary data feedstruct since Data input output (H.Lee) --> Figure plot (Julio) --> User interface (Jake)
        % The issue was raw ECoG data is not useful and spectral analysis of ECoG give t axis while hql5715 did not provide time axis for raw data set.
        % Therfore at the temporary UI made by Jake mismatched
        % 250823_ update, perhaps its better to H.Lee to follow Fiber datastructure rather than integrating preprocessing step into current step
            % this function would be better for just UI development before Julio's engagement delayed by Lee's interpretation of Kevin's directory and data management
        % DataConcatentation()
        %   
        %   Created by: jsl5865
        %   Filled by : hql5715
        % Syntax:
        %   
        % Description:
        %   
        % Input: FileDirectory
        %   
        % Output: datastruct containing 
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
    FinalSleepData = struct(); % output
    sleepscore_rawData = io_main(FileDirectory);
    Analogfreq = str2double(sleepscore_rawData.analog.info.analogfreq(1:end-2));
        feedstruct(sleepscore_rawData.analog.data,'raw_ECoG')
% ECoG processing
        [raw_ECoG,goflag] = feedstruct(sleepscore_rawData.analog.data,'raw_ECoG');
        if goflag
            EcogData = ecogprocess(Analogfreq, raw_ECoG);
            FinalSleepData.EcogData.t = EcogData.t_axis;
            FinalSleepData.EcogData.f = EcogData.f_axis;
            FinalSleepData.EcogData.spectrum = EcogData.log_norm_spectrum;
        end
% EMG processing
        [raw_emg, goflag] = feedstruct(sleepscore_rawData.analog.data,'raw_EMG');
        if goflag
            FinalSleepData.raw_emg = raw_emg;
            FinalSleepData.raw_emg_t = maketimeaxis(size(raw_emg,2), Analogfreq);
        end
% Force processing
        [raw_force, goflag] = feedstruct(sleepscore_rawData.analog.data,'raw_Force');
        if goflag
            FinalSleepData.raw_force = raw_force;
            FinalSleepData.raw_force_t = maketimeaxis(size(raw_force,2), Analogfreq);
        end

end


function [output,existflag] = feedstruct(data_struct, fieldname)
    if isfield(data_struct, fieldname)
        output = data_struct.(fieldname);
        existflag = true;
    else
        fprintf('field "%s" does not exist.\n', fieldname)
        output = struct();
        existflag = false;
    end
end

function taxis = maketimeaxis(n_datapoints,frequency)
    tmax = (n_datapoints -1 ) / frequency;
    taxis = linspace(0,tmax,n_datapoints);
end