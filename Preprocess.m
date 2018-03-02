%%% EEG analysis script 14/11/2017 %%%
function Preprocess(pNumber)
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\') % this is where you have the EEG data stored 

    % define files for this participant
    vhdr = strcat(num2str(pNumber), '\Day3\EEG\',num2str(pNumber), '.vhdr');
    cond1out = strcat('PreprocessedData\', num2str(pNumber), '_data_clean_cond1');
    cond2out = strcat('PreprocessedData\', num2str(pNumber), '_data_clean_cond2');

    % defining settings for trial selection
    cfg = [];
    cfg.dataset     = vhdr;                         % raw data file name
    cfg.trialfun = 'ft_trialfun_allconditions';     % selecting only trials from the final test 
    cfg.trialdef.prestim    = 0.5;                  % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfg.trialdef.poststim   = 2;                    % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfg.markers = {'S208', 'S209'};                 % markers marking stimulus events in the final test

    % Define trials (in cfg.trl)
    cfg     = ft_definetrial(cfg);                  % fieldtrip function that specifies trials

    % rereferencing data
    cfg.reref = 'yes';                              % data will be rereferenced
    cfg.channel = 'EEG';                            % in this step only for the EEG channels
    cfg.implicitref = 'Ref';                        % the implicit (non-recorded) reference channel is added to the data representation
    cfg.refchannel = {'LinkMast', 'Ref'};           % the average of the implicit ref and 32 channels is used as the new reference

    % filtering data
    cfg.lpfilter = 'yes';                          % data will be lowpass filtered
    cfg.lpfreq = 40;                               % lowpass frequency in Hz
    cfg.hpfilter = 'no';                           % data will NOT be highpass filtered, as this was already done online

    % baseline correction
    cfg.demean = 'yes';
    cfg.baselinewindow = [-0.2 0];                 % data will be baseline corrected in a window from -200ms to stimulus onset

    % apply the set parameters on the data
    data_eeg = ft_preprocessing(cfg); 
    
    %% processing horizontal EOG
    cfgHEOG = [];                                    % initiate new, empty cfg for the horizontal EOG preprocessing 
    cfgHEOG.trialfun = 'ft_trialfun_allconditions';  % selecting only trials from the final test  
    cfgHEOG.markers = {'S208', 'S209'};                 % markers marking stimulus events in the final test
    cfgHEOG.dataset = vhdr;
    cfgHEOG.channel = {'EOGleft', 'EOGright'};       % horizontal EOG channels
    cfgHEOG.reref = 'yes';
    cfgHEOG.bpfilter = 'yes';
    cfgHEOG.bpfilttype = 'but';
    cfgHEOG.bpfreq = [1 15];
    cfgHEOG.bpfiltord = 4;
    cfgHEOG.refchannel = 'EOGleft';
    cfgHEOG.trialdef.prestim    = 0.5;                % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfgHEOG.trialdef.poststim   = 2;                  % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfgHEOG.demean = 'yes';
    cfgHEOG.baselinewindow = [-0.2 0];                % data will be baseline corrected in a window from -200ms to stimulus onset
    cfgHEOG = ft_definetrial(cfgHEOG);
    % apply the set parameters on the data
    data_HEOG = ft_preprocessing (cfgHEOG);
    data_HEOG.label{1} = 'EOGH';                      % rename newly created channel
    
    %checking that EOGleft was referenced to itself
    %figure
    %plot(data_HEOG.time{1}, data_HEOG.trial{1}(1,:));
    %hold on
    %plot(data_HEOG.time{1}, data_HEOG.trial{1}(2,:),'g'); 
    %legend({'EOGleft' 'EOGright'}); 

    %% processing vertical EOG
    cfgVEOG = [];
    cfgVEOG.trialfun = 'ft_trialfun_allconditions';  % selecting only trials from the final test  
    cfgVEOG.markers = {'S208', 'S209'};                 % markers marking stimulus events in the final test
    cfgVEOG.dataset = vhdr;
    cfgVEOG.channel = {'EOGabove', 'EOGbelow'};
    cfgVEOG.reref = 'yes';
    cfgVEOG.bpfilter = 'yes';
    cfgVEOG.bpfilttype = 'but';
    cfgVEOG.bpfreq = [1 15];
    cfgVEOG.bpfiltord = 4;
    cfgVEOG.refchannel = 'EOGabove';
    cfgVEOG.trialdef.prestim    = 0.5;                % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfgVEOG.trialdef.poststim   = 2;                  % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfgVEOG.demean = 'yes';
    cfgVEOG.baselinewindow = [-0.2 0];                % data will be baseline corrected in a window from -200ms to stimulus onset
    cfgVEOG = ft_definetrial(cfgVEOG);
    data_VEOG = ft_preprocessing (cfgVEOG);
    data_VEOG.label(1) = {'EOGV'};                   % rename newly created channel

    %checking that EOGabove was referenced to itself
    %figure
    %plot(data_VEOG.time{1}, data_VEOG.trial{1}(1,:));
    %hold on
    %plot(data_VEOG.time{1}, data_VEOG.trial{1}(2,:),'g'); 
    %legend({'EOGabove' 'EOGbelow'}); 

    %% processing Lips
    cfgLips = [];
    cfgLips.trialfun = 'ft_trialfun_allconditions';  % selecting only trials from the final test  
    cfgLips.markers = {'S208', 'S209'};                 % markers marking stimulus events in the final test
    cfgLips.dataset = vhdr;
    cfgLips.channel = {'LipUp', 'LipLow'};
    cfgLips.reref = 'yes';
    cfgLips.bpfilter = 'yes';
    cfgLips.bpfilttype = 'but';
    cfgLips.bpfreq = [110 140];
    cfgLips.bpfiltord = 8;
    cfgLips.refchannel = 'LipUp';
    cfgLips.trialdef.prestim    = 0.5;                % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfgLips.trialdef.poststim   = 2;                  % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfgLips.demean = 'yes';
    cfgLips.baselinewindow = [-0.2 0];                % data will be baseline corrected in a window from -200ms to stimulus onset
    cfgLips = ft_definetrial(cfgLips);
    data_lips = ft_preprocessing (cfgLips);
    data_lips.label{1} = 'LIPS';                      % rename newly created channelcfg.dataset = vhdr ;

    %checking that LipUp was referenced to itself
    %figure
    %plot(data_lips.time{1}, data_lips.trial{1}(1,:));
    %hold on
    %plot(data_lips.time{1}, data_lips.trial{1}(2,:),'g'); 
    %legend({'LipUp' 'LipLow'}); 

    %% Combining all the preprocessed data into one dataset
    cfg = [];
    data_all = ft_appenddata(cfg, data_eeg, data_HEOG, data_VEOG, data_lips);

    %% Artifact rejection 
    % automatic artifact rejection
    % Threshold artifact detection: trials with amplitudes above or below
    % +-100m or with a difference between min and max of more than 150mV
    cfg                               = [];
    cfg.continuous                    = 'no';
    cfg.artfctdef.threshold.channel   = (1:56);  % only non-EOG channels
    cfg.artfctdef.threshold.bpfilter  = 'yes';
    cfg.artfctdef.threshold.bpfreq    = [0.3 30];
    cfg.artfctdef.threshold.bpfiltord = 4;
    cfg.artfctdef.threshold.range     = 150;
    cfg.artfctdef.threshold.min       = -100; 
    cfg.artfctdef.threshold.max       = 100;
    cfg.trl                           = data_all.cfg.previous{1,1}.trl
    [cfg, artifact_threshold] = ft_artifact_threshold(cfg, data_all);

    % Clips - flat electrodes / trials 
    %cfg.artfctdef.clip.pretim        = 0.000;  %pre-artifact rejection-interval in seconds
    %cfg.artfctdef.clip.psttim        = 0.000;  %post-artifact rejection-interval in seconds
    cfg.artfctdef.clip.channel = (1:56);
    cfg.artfctdef.clip.timethreshold = 0.05; %minimum duration in seconds of a datasegment with consecutive identical samples to be considered as 'clipped'
    cfg.artfctdef.clip.amplthreshold = 0; %minimum amplitude difference in consecutive samples to be considered as 'clipped' (default = 0)
    [cfg, artifact_clip] = ft_artifact_clip(cfg, data_all);

    % Eye-blinks - somehow this finds a huge amount fo artifacts, something is
    % wrong with settings
    cfg.artfctdef.eog.channel = [58,60]; % only HEOG and VEOG
    cfg.artfctdef.eog.cutoff      = 6;
    cfg.artfctdef.eog.trlpadding  = 0; %0.5?
    cfg.artfctdef.eog.artpadding  = 0.1;
    cfg.artfctdef.eog.fltpadding  = 0; %0.1
    [cfg, artifact_eog] = ft_artifact_eog(cfg, data_all);

    % manual artifact rejection by visual inspection of each trial
    cfg.viewmode         = 'vertical';
    cfg.selectmode       = 'markartifact';
    cfg                  = ft_databrowser(cfg, data_all);                       % double click on segments to mark them as artefacts, then at the end exist the box by clicking 'q' or the X
    cfg.artfctdef.reject = 'complete';                                          % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
    data_clean     = ft_rejectartifact(cfg, data_all); 

    %% Cut data in two conditions and save datasets seperately 
    cfg = [];
    cfg.dataset      = vhdr;
    cfg.headerfile   = vhdr;                    % this needs to be specified, otherwise it doesn't work
    % trial selection criteria general
    cfg.trialfun = 'correctonly_trialfun';      % this is to only select correct trials 
    cfg.trialdef.prestim    = 0.5;              % time before marker in seconds
    cfg.trialdef.poststim   = 2;                % time after marker in seconds
    cfg.marker2 = 'S205';                       % correct / incorrect response marker 
    
    % trial selection crtieria for condition 1
    cfg.marker1 = 'S208';                       % for the markers that only have two numbers you need to insert a space
    cfg_finaltestcond1    = ft_definetrial(cfg);
    
    % trial selection crtieria for condition 2
    cfg.marker1 = 'S209';
    cfg_finaltestcond2    = ft_definetrial(cfg);

    %cut the trials out of the continuous data segment 
    data_finaltestcond1 = ft_redefinetrial(cfg_finaltestcond1, data_clean);
    data_finaltestcond2    = ft_redefinetrial(cfg_finaltestcond2, data_clean);
    save(cond1out, 'data_finaltestcond1');
    save(cond2out, 'data_finaltestcond2');

    % document how many trials were kept for later analysis
    c1 = length(data_finaltestcond1.trial);
    c2 = length(data_finaltestcond2.trial);
    
    % save trial information in txt
    fid = fopen('TrialCount_PostPreprocessing.txt','a');
    formatSpec = '%d\t%d\t%d\n';
    fprintf(fid,formatSpec,pNumber,c1,c2);
    
    % calculating average for this pp 
    cfg = [];
    cfg.keeptrials='yes';
    cond1 = ft_timelockanalysis(cfg, data_finaltestcond1);
    cond2 = ft_timelockanalysis(cfg, data_finaltestcond2);
    % plotting average
    cfg = [];
    cfg.layout = 'actiCAP_64ch_Standard2.mat';
    cfg.interactive = 'yes';
    %cfg.showoutline = 'yes';
    cfg.showlabels = 'yes'; 
    %cfg.colorbar = 'yes';
    cfg.fontsize = 6; 
    %cfg.ylim = [-10 10];
    ft_multiplotER(cfg, cond1, cond2);
    
    % change this to your Github folder directory
    cd('U:\PhD\EXPERIMENT 2 - EEG\EEG-analysis');  