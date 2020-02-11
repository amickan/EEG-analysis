%%% Analysis script oscillations - combined both rounds %%%

% read in subjects
subjects = [301:308, 310:326, 328, 329]; % subjects that should be included in grand average
% some global settings for plotting later on 
set(groot,'DefaultFigureColormap',jet);

% frequency decomposition settings
cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'EEG';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.pad          = 'nextpow2';
%cfg.baseline     = [-0.5 0];
cfg.foi          = 2:1:30;                           % analysis 4 to 30 Hz in steps of 1 Hz 
cfg.t_ftimwin    = 3 ./ cfg.foi;                     % ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
cfg.toi          = -0.5:0.01:1.5;                    % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)

Condition1 = cell(1,length(subjects));
for i = 1:length(subjects)
    % condition 1 first round for each participant
    filename1 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_firsthalf\', num2str(subjects(i)), '_data_clean_cond1');
    dummy = load(filename1);
    % condition 1 second round for each participant
    filename2 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_secondhalf\', num2str(subjects(i)), '_data_clean_2_cond1');
    dummy2 = load(filename2);
    % append data of the two rounds 
    dummy3 = ft_appenddata([], dummy.data_finaltestcond1, dummy2.data_cond1);
    %dummy2.data_cond1.trial = [dummy.data_finaltestcond1.trial, dummy2.data_cond1.trial];
    %dummy2.data_cond1.time = [dummy.data_finaltestcond1.time, dummy2.data_cond1.time];
    %dummy2.data_cond1.sampleinfo =[dummy.data_finaltestcond1.sampleinfo, dummy2.data_cond1.sampleinfo];
    Condition1{i} = ft_freqanalysis(cfg, dummy3);
    %Condition1{i} = ft_freqbaseline(cfg, Condition1{i});
    clear dummy
    clear dummy2
    clear dummy3
end

Condition2 = cell(1,length(subjects));
for i = 1:length(subjects)
    % condition 1 for each participant
    filename = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_firsthalf\', num2str(subjects(i)), '_data_clean_cond2');
    dummy = load(filename);
    filename2 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_secondhalf\', num2str(subjects(i)), '_data_clean_2_cond2');
    dummy2 = load(filename2);
    % append data of the two rounds 
    dummy4 = ft_appenddata([], dummy.data_finaltestcond2, dummy2.data_cond2);
    %dummy.data_cond2.trial = [dummy.data_cond2.trial, dummy2.data_finaltestcond2.trial];
    %dummy.data_cond2.time = [dummy.data_cond2.time, dummy2.data_finaltestcond2.time];
    %dummy.data_cond2.sampleinfo = [dummy.data_cond2.sampleinfo; dummy2.data_finaltestcond2.sampleinfo];
    Condition2{i} = ft_freqanalysis(cfg, dummy4);
    %Condition2{i} = ft_freqbaseline(cfg, Condition2{i});
    clear dummy
    clear dummy2
    clear dummy4
end

% grand average over the two conditions, for plotting
cfg = [];
cfg.keepindividual='yes';
cond1 = ft_freqgrandaverage(cfg, Condition1{:});
cond2 = ft_freqgrandaverage(cfg, Condition2{:});

% compute the difference between conditions
% a positive difference reflects more induced power for the interfered
% compared to the not interfered items
diff = cond1;
diff.powspctrm = (cond1.powspctrm - cond2.powspctrm) ./ ((cond1.powspctrm + cond2.powspctrm)/2);

%% create an effect structure which reflects the differences between conditions relative to the average activity in both conditions 
% the effect that results is thus free from noise, higher signal to noise
% ratio than when comparing the two conditions directly 
% this effect is also what we plot 
eff = Condition2;
% loop
for i = 1:length(subjects)
    eff{i}.powspctrm = (Condition1{i}.powspctrm - Condition2{i}.powspctrm) ./ ((Condition1{i}.powspctrm + Condition2{i}.powspctrm)/2);
end

% grand average for weighted effect
cfg = [];
cfg.keepindividual='yes';
effect = ft_freqgrandaverage(cfg, eff{:});

null = cond1;
null.powspctrm = zeros(size(cond1.powspctrm));

% Create neighbourhood structure
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\');
cfg_neighb                  = [];
cfg_neighb.method           = 'distance';        
cfg_neighb.channel          = 'EEG';
cfg_neighb.layout           = 'EEG1010.lay';
cfg_neighb.feedback         = 'yes';
cfg_neighb.neighbourdist    = 0.15; % higher number: more is linked!
neighbours                  = ft_prepare_neighbours(cfg_neighb, Condition1{1});

% Permutation test
cfg = [];
cfg.channel          = {'EEG'};
cfg.latency          = [0 1];
cfg.method           = 'montecarlo';
cfg.frequency        = [10 20];                                       %[10 20]; for beta 4 7
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.correcttail      = 'prob';
cfg.alpha            = 0.05;
cfg.numrandomization = 2000;
cfg.neighbours          = neighbours; 
%cfg.avgovertime = 'yes';
%cfg.avgoverfreq = 'yes';

% Design matrix - within subject design
subj                    = length(subjects);                % number of participants excluding the ones with too few trials
design                  = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design              = design;                           % design matrix EDIT FOR WITHIN
cfg.uvar                = 1;                                % unit variable
cfg.ivar                = 2;                                % number or list with indices indicating the independent variable(s) EDIT FOR WITHIN

%[stat]                  = ft_freqstatistics(cfg, Condition1{:}, Condition2{:});
[stat]                 = ft_freqstatistics(cfg, effect, null);

% get relevant (significant) values
pos_cluster_pvals = [stat.posclusters(:).prob];
pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha);
pos = ismember(stat.posclusterslabelmat, pos_signif_clust);

neg_cluster_pvals = [stat.negclusters(:).prob];
neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha);
neg = ismember(stat.negclusterslabelmat, neg_signif_clust);

select = pos_cluster_pvals < stat.cfg.alpha;
selectneg = neg_cluster_pvals < stat.cfg.alpha;
signclusters = pos_cluster_pvals(select);
signclustersneg = neg_cluster_pvals(selectneg);
numberofsignclusters = length(signclusters);
numberofsignclustersneg = length(signclustersneg);
disp(['there are ', num2str(numberofsignclusters), ' significant positive clusters']);
disp(['there are ', num2str(numberofsignclustersneg), ' significant negative clusters']);

if numberofsignclusters > 0
    for i = 1:length(signclusters)
        disp(['Positive cluster number ', num2str(i), ' has a p value of ', num2str(signclusters(i))]);
        [foundx,foundy,foundz] = ind2sub(size(pos),find(pos));
        startbin = stat.time(min(foundz));
        endbin = stat.time(max(foundz));
        disp(['Positive cluster ', num2str(i), ' starts at ', num2str(startbin), ' s and ends at ', num2str(endbin), ' s.'])
        disp(['Positive cluster ', num2str(i), ' has a cluster statistic of ', num2str(stat.posclusters(i).clusterstat), ' and a standard deviation of ',num2str(stat.posclusters(i).stddev),'.' ])
        disp(['The following frequencies are included in this significant cluster:  ', num2str(stat.freq(unique(foundy')))])
        disp(['The following ', num2str(length(unique(foundx'))),' channels are included in this significant cluster:  ', num2str(unique(foundx'))])
    end
end

if numberofsignclustersneg > 0
    for i = 1:length(signclustersneg)
        disp(['Negative cluster number ', num2str(i), ' has a p value of ', num2str(signclustersneg(i))]);
        [foundx,foundy,foundz] = ind2sub(size(neg),find(neg));
        startbin = stat.time(min(foundz));
        endbin = stat.time(max(foundz));
        disp(['Negative cluster ', num2str(i), ' starts at ', num2str(startbin), ' s and ends at ', num2str(endbin), ' s.'])
        disp(['Negative cluster ', num2str(i), ' has a cluster statistic of ', num2str(stat.negclusters(i).clusterstat), ' and a standard deviation of ',num2str(stat.negclusters(i).stddev),'.' ])
        disp(['The following frequencies are included in this significant cluster:  ', num2str(stat.freq(unique(foundy')))])
        disp(['The following ', num2str(length(unique(foundx'))),' channels are included in this significant cluster:  ', num2str(unique(foundx'))])
    end
end

%%% plotting 

% one channel
effect2 = effect;
effect2.freq = round(effect.freq);  % to circumvent plotting problem with newest fieldtrip version, round frequencies 
cfg = [];
%cfg.parameter = 'stat';
%cfg.maskparameter = 'mask';
%cfg.maskalpha = 0.2;
cfg.channel    = {'Cz', 'FCz', 'CPz', 'Pz', 'CP1', 'CP2', 'P1', 'P2', 'C1', 'C2', 'FC1', 'FC2'};	
cfg.zlim         = 'maxabs'; %[-.18 .18]; %
cfg.masknans = 'yes';
figure 
ft_singleplotTFR(cfg, effect2);
%ft_singleplotTFR(cfg, diff);
%ft_singleplotTFR(cfg, stat);

% plotting the topography 
cfg = [];
cfg.xlim = [0.51 1];
cfg.ylim = [4 7];
cfg.zlim = 'maxabs';% [-.1 .1];
cfg.layout = 'EEG1010.lay';
figure
ft_topoplotTFR(cfg, effect);

cfg = [];
cfg.xlim = [0.51 1];
cfg.ylim = [4 7];
cfg.zlim = [-2 2];%'maxabs';% [-.18 .18];
cfg.layout = 'EEG1010.lay';
cfg.parameter = 'stat';
figure
ft_topoplotTFR(cfg, stat);