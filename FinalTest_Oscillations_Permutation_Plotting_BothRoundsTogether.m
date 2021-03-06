%%% Final test - Oscillations - Analysis and plotting script - combined both rounds because no interaction between rounds %%%

%% load data 
subjects        = [301:308, 310:326, 328, 329];     % subjects that should be included in grand average
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\');    % directory with all preprocessed files 

% some global settings for plotting later on 
set(groot,'DefaultFigureColormap',jet);

% frequency decomposition settings
cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'EEG';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.pad          = 'nextpow2';
cfg.foi          = 2:1:30;                           % analysis 4 to 30 Hz in steps of 1 Hz 
cfg.t_ftimwin    = 3 ./ cfg.foi;                     % ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
cfg.toi          = -0.5:0.01:1.5;                    % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)

% initiate empty cell arrays per condition for subject averages 
Condition1      = cell(1,length(subjects));
Condition2      = cell(1,length(subjects));

for i = 1:length(subjects)
    % condition 1 first round for each participant
    filename1 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_firsthalf_new\', num2str(subjects(i)), '_data_clean_1_cond1_witherrors_long');
    dummy = load(filename1);
    % condition 1 second round for each participant
    filename2 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_secondhalf\', num2str(subjects(i)), '_data_clean_2_cond1_witherrors_long');
    dummy2 = load(filename2);
    % append data of the two rounds 
    dummy3 = ft_appenddata([], dummy.data_cond12, dummy2.data_cond12);
    % manually appending data
    %dummy2.data_cond1.trial = [dummy.data_finaltestcond1.trial, dummy2.data_cond1.trial];
    %dummy2.data_cond1.time = [dummy.data_finaltestcond1.time, dummy2.data_cond1.time];
    %dummy2.data_cond1.sampleinfo =[dummy.data_finaltestcond1.sampleinfo, dummy2.data_cond1.sampleinfo];
    Condition1{i} = ft_freqanalysis(cfg, dummy3);
    clear dummy
    clear dummy2
    clear dummy3
    
    % condition 2 first round for each participant
    filename3 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_firsthalf_new\', num2str(subjects(i)), '_data_clean_1_cond2_witherrors_long');
    dummy4 = load(filename3);
    % condition 2 second round for each participant
    filename4 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData_secondhalf\', num2str(subjects(i)), '_data_clean_2_cond2_witherrors_long');
    dummy5 = load(filename4);
    % append data of the two rounds 
    dummy6 = ft_appenddata([], dummy4.data_cond22, dummy5.data_cond22);
    % manual appending
    %dummy.data_cond2.trial = [dummy.data_cond2.trial, dummy2.data_finaltestcond2.trial];
    %dummy.data_cond2.time = [dummy.data_cond2.time, dummy2.data_finaltestcond2.time];
    %dummy.data_cond2.sampleinfo = [dummy.data_cond2.sampleinfo; dummy2.data_finaltestcond2.sampleinfo];
    Condition2{i} = ft_freqanalysis(cfg, dummy6);
    clear dummy4
    clear dummy5
    clear dummy6
    
    disp(subjects(i));
end

%% Calculate the relative differences between conditions per subject 
% relative to the average activity in both conditions 
% the effect that results is thus free from noise, higher signal to noise
% ratio than when comparing the two conditions directly  

eff = Condition2;
for i = 1:length(subjects)
    eff{i}.powspctrm = (Condition1{i}.powspctrm - Condition2{i}.powspctrm) ./ ((Condition1{i}.powspctrm + Condition2{i}.powspctrm)/2);
end

%% grand average the difference 
cfg = [];
cfg.keepindividual='yes';
effect = ft_freqgrandaverage(cfg, eff{:});

% create a null structure against which to compare the difference between
% conditions
null = effect;
null.powspctrm = zeros(size(effect.powspctrm));

%% Permutation test 

% Create neighbourhood structure
cfg_neighb                  = [];
cfg_neighb.method           = 'triangulation';        
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
cfg.frequency        = [4 7];                                       %[10 20]; for beta 4 7
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

[stat]                 = ft_freqstatistics(cfg, effect, null);

%% Permutation test evaluation

% get relevant (significant) values
if isempty(stat.posclusters) == 0
    pos_cluster_pvals = [stat.posclusters(:).prob];
    pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha);
    pos = ismember(stat.posclusterslabelmat, pos_signif_clust);
    select = pos_cluster_pvals < stat.cfg.alpha;
    signclusters = pos_cluster_pvals(select);
    numberofsignclusters = length(signclusters);
    disp(['there are ', num2str(numberofsignclusters), ' significant positive clusters']);
else
    numberofsignclusters = 0;
end

if isempty(stat.negclusters) == 0
    neg_cluster_pvals = [stat.negclusters(:).prob];
    neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha);
    neg = ismember(stat.negclusterslabelmat, neg_signif_clust);
    selectneg = neg_cluster_pvals < stat.cfg.alpha;
    signclustersneg = neg_cluster_pvals(selectneg);
    numberofsignclustersneg = length(signclustersneg);
    disp(['there are ', num2str(numberofsignclustersneg), ' significant negative clusters']);
else 
    numberofsignclustersneg = 0;
end


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

%% Plotting 
effect2 = effect;
effect2.freq = round(effect.freq);  % to circumvent plotting problem with newest fieldtrip version, round frequencies 

% plot the relative difference between conditions
cfg                 = [];
cfg.parameter      = 'stat';
cfg.maskparameter  = 'mask';
cfg.maskalpha      = 0;
cfg.channel         = {'Fz','F1', 'F2' ,'Cz', 'FCz', 'CPz', 'Pz', 'CP1', 'CP2', 'P1', 'P2', 'C1', 'C2', 'FC1', 'FC2'};	
cfg.zlim            = [-3 3];
%cfg.zlim            = [-.18 .18]; %
%cfg.masknans        = 'yes';
figure 
%ft_singleplotTFR(cfg, effect2);
ft_singleplotTFR(cfg, stat);

% plotting the topography 
cfg                 = [];
cfg.xlim            = [0.51 1];
cfg.ylim            = [4 7];
cfg.zlim            = 'maxabs'; %[-.18 .18];
cfg.layout          = 'EEG1010.lay';
figure
ft_topoplotTFR(cfg, effect2);

cfg                 = [];
cfg.xlim            = [0.51 1];
cfg.ylim            = [4 7];
cfg.zlim            = [-2 2];%'maxabs';% [-.18 .18];
cfg.layout          = 'EEG1010.lay';
cfg.parameter       = 'stat';
figure
ft_topoplotTFR(cfg, stat);

cfg = [];
cfg.alpha  = 0.025;
cfg.parameter = 'stat';
%cfg.zlim   = [-4 4];
cfg.layout = 'EEG1010.lay';
ft_clusterplot(cfg, stat);

%% plot time course of theta power for both Conditions 
cfg = [];
cfg.keepindividual='no';
cond1 = ft_freqgrandaverage(cfg, Condition1{:});
cond2 = ft_freqgrandaverage(cfg, Condition2{:});

% calculate mean power over representative electrodes and 4-7 Hz
cond1.data = cond1.powspctrm([25,54,50,49,41,39,31,13,12,7,19,22,23,24,40],[4,5,6,7],:);
cond1.avg = mean(cond1.data, [1,2]);
cond2.data = cond2.powspctrm([25,54,50,49,41,39,31,13,12,7,19,22,23,24,40],[4,5,6,7],:);
cond2.avg = mean(cond2.data, [1,2]);
cond1.avgs = squeeze(cond1.avg);
cond2.avgs = squeeze(cond2.avg);

figure;
hold on;
plot((cond1.time)*1000, cond1.avgs,  'r', (cond2.time)*1000, cond2.avgs, 'k')
xlabel('Time (ms)');
ylabel('Absolute power (uV^2)');
ylim([8 15]);
xlim([0 1000]);
