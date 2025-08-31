# Sleep_Scoring-SliderDefinition
This repository is designed to update the Drew Lab sleep scoring pipeline. Rather than defining sleep state using binned intervals, use a dynamic slider to more efficiently define arousal state regions.

**Update Notes**
- This update to the sleep scoring script is designed to improve efficiency during sleep scoring. Instead of defining 5 second intervals of a 15 minute recording session, this script allows users to define variable length regions of sleep data by using a slider to segment sleep states. 
- Users can define which data modalities will be displayed during sleep scoring in the event of a damaged sensor or to prevent bias during scoring. This is done via a list dialoge which opens prior to the creation of the figure window.
- Creating new sleep states is can be done by adding a MatLab acceptable string to the ArousalStateList variable. 

**Data Modalities**
- The following data modalities are used in the original script and are currently supported.
    - Force: 
    - EMG: 
    - WhiskerAngle: 
    - PupilDiameter: 
    - ECOG: 
    - Spectrogram: 

**User Interface**
- The UI figure displays 500 seconds of each data modality. The display region can be adjusted with the scroll wheel on a mouse in increments of 60 seconds.
- Pressing the 'r' key displays the full dataset of each modality.
- After segmenting the dataset, pressing the 'escape' key or closing the window will save a structure containing each arousal state. The segmented regions are defined based on cell arrays composed of 2x1 arrays in the form of [First Indice, Final Indice] for each segment of an arousal state.

**Patching Into Previous Sleep Scoring Script**