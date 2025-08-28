function sleepscore_rawdatastruct = io_fiber(multisessionfolder_directory)
    % Written by H.Lee
    % This function is to load raw data from raw data struct which is overwritten at stage 2 processing
    % The raw_data struct contains labview collected anlog signal, timing matched with tdt fiber signal by crosscorrelation
    % input: folder directory contains multi session files end with _RawData.mat
    % output: struct array contains recording frequency and raw data
    raw_dir = dir(fullfile(multisessionfolder_directory,'*_ProcData.mat'));
    n_session = numel(raw_dir);
    struct_blueprint = struct(...
        'fileid',[], ...
        'animalID',[], ...
        'sessionID',[], ...
        'analogSamplingRate',[], ...
        'whiskCamSamplingRate',[], ...
        'pupilCamSamplingRate',[], ...
        'cortical_LH', [], ...
        'EMG', [], ...
        'forceSensor', [], ...
        'pupilDiameter', [], ...
        'whiskerAngle', [], ...
        'filepath', []);
    sleepscore_rawdatastruct = repmat(struct_blueprint,1,n_session);
    for session_idx = 1:n_session
        fileid = strsplit(raw_dir(session_idx).name,'_');
        fileid = strjoin(fileid(1:end-1),'_');
        filepath = fullfile(raw_dir(session_idx).folder,raw_dir(session_idx).name);
            fprintf("\r %1d/%1d loading %s", session_idx, n_session, raw_dir(session_idx).name)
        sleepscore_rawdatastruct(session_idx).filepath = filepath;
        tmp.loadstruct = load(filepath);
        ProcData = tmp.loadstruct.ProcData;
        sleepscore_rawdatastruct(session_idx).fileid = fileid;
        sleepscore_rawdatastruct(session_idx).animalID = ProcData.notes.animalID;
        sleepscore_rawdatastruct(session_idx).sessionID = ProcData.notes.sessionID;
        sleepscore_rawdatastruct(session_idx).analogSamplingRate = ProcData.notes.analogSamplingRate;
        sleepscore_rawdatastruct(session_idx).whiskCamSamplingRate = ProcData.notes.whiskCamSamplingRate;
        sleepscore_rawdatastruct(session_idx).pupilCamSamplingRate = ProcData.notes.pupilCamSamplingRate;
        sleepscore_rawdatastruct(session_idx).cortical_LH = ProcData.data.cortical_LH;
        sleepscore_rawdatastruct(session_idx).EMG = ProcData.data.EMG;
        sleepscore_rawdatastruct(session_idx).forceSensor = ProcData.data.forceSensor;
        sleepscore_rawdatastruct(session_idx).pupilDiameter = ProcData.data.Pupil.Diameter;
        sleepscore_rawdatastruct(session_idx).whiskerAngle = ProcData.data.whiskerAngle;
    end
end
