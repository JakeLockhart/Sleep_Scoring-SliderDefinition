function fibersleep_structarray = io_fiber(multisessionfolder_directory)
    % Written by H.Lee
    % This function is to load raw data from raw data struct which is overwritten at stage 2 processing
    % The raw_data struct contains labview collected anlog signal, timing matched with tdt fiber signal by crosscorrelation
    % input: folder directory contains multi session files end with _RawData.mat
    % output: struct array contains recording frequency and raw data
    proc_dir = dir(fullfile(multisessionfolder_directory,'*_ProcData.mat'));
    specA_path = '';
    %%
    

    n_session = numel(proc_dir);
    struct_blueprint = struct(...
        'fileid',[], ...
        'animalID',[], ...
        'sessionID',[], ...
        'analogSamplingRate',[], ...
        'whiskCamSamplingRate',[], ...
        'pupilCamSamplingRate',[], ...
        'trialDuration_sec',[],...
        'dsFs', [], ...
        'cortical_LH', [], ...
        'SpecData', [], ...
        'EMG', [], ...
        'forceSensor', [], ...
        'Pupil', [], ...
        'whiskerAngle', [], ...
        'procpath', [], ...
        'specApath', []);
    fibersleep_structarray = repmat(struct_blueprint,1,n_session);
    for session_idx = 1:n_session
        fileid = strsplit(proc_dir(session_idx).name,'_');
        fileid = strjoin(fileid(1:end-1),'_');
        proc_path = fullfile(proc_dir(session_idx).folder,proc_dir(session_idx).name);
            fprintf("\n %d/%d loading %s", session_idx, n_session, proc_dir(session_idx).name)
        specA_path = fullfile(proc_dir(session_idx).folder,[fileid,'_SpecDataA.mat']);
        fibersleep_structarray(session_idx).procpath = proc_path;
        fibersleep_structarray(session_idx).specApath = specA_path;

        tmp.loadstruct = load(proc_path);
        ProcData = tmp.loadstruct.ProcData;

        if isfile(specA_path)
            tmp.loadstruct = load(specA_path);
            specAdata = tmp.loadstruct.SpecData;
        else
            fprintf('\n No specDataA at specA_path %s', specA_path)
        end
        fibersleep_structarray(session_idx).fileid = fileid;
        fibersleep_structarray(session_idx).animalID = ProcData.notes.animalID;
        fibersleep_structarray(session_idx).sessionID = ProcData.notes.sessionID;
        % fprintf('\n Current session: %s',ProcData.notes.sessionID);
        fibersleep_structarray(session_idx).analogSamplingRate = ProcData.notes.analogSamplingRate;
        fibersleep_structarray(session_idx).whiskCamSamplingRate = ProcData.notes.whiskCamSamplingRate;
        fibersleep_structarray(session_idx).pupilCamSamplingRate = ProcData.notes.pupilCamSamplingRate;
        fibersleep_structarray(session_idx).trialDuration_sec = ProcData.notes.trialDuration_sec;
        fibersleep_structarray(session_idx).dsFs = ProcData.notes.dsFs;
        fibersleep_structarray(session_idx).cortical_LH = ProcData.data.cortical_LH;
        fibersleep_structarray(session_idx).SpecData = specAdata;
        fibersleep_structarray(session_idx).EMG = ProcData.data.EMG;
        fibersleep_structarray(session_idx).forceSensor = ProcData.data.forceSensor;
        fibersleep_structarray(session_idx).Pupil = ProcData.data.Pupil;
        fibersleep_structarray(session_idx).whiskerAngle = ProcData.data.whiskerAngle;
    end
end
