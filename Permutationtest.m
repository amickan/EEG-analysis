% Loading all preprocessed data 

subjects = [301:308, 310:326, 328, 329]; % subjects that should be included in grand average
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\'); % directory with all preprocessed files 
cfg = [];
cfg.keeptrials='yes';
cfg.baseline = 'yes';
cfg.baselinewindow = [-0.2 0];

for i = 1:length(subjects)
    % condition 1 for each participant
    filename1 = strcat('PreprocessedData\', num2str(subjects(i)), '_data_clean_cond1');
    dummy = load(filename1);
    Condition1{i} = ft_timelockanalysis(cfg, dummy.data_finaltestcond1);
    Condition1{i} = ft_timelockbaseline(cfg, Condition1{i});
    % condition 2 for each participant
    filename2 = strcat('PreprocessedData\', num2str(subjects(i)), '_data_clean_cond2');
    dummy2 = load(filename2);
    Condition2{i} = ft_timelockanalysis(cfg, dummy2.data_finaltestcond2);
    Condition2{i} = ft_timelockbaseline(cfg, Condition2{i});
end

%% Neighbourhood definition
cfg_neighb                  = [];
cfg_neighb.method           = 'distance';        
cfg_neighb.channel          = 'EEG';
cfg_neighb.layout           = 'actiCAP_64ch_Standard2.mat';
cfg_neighb.feedback         = 'yes';
cfg_neighb.neighbourdist    = 0.15;                                         % higher number: more is linked!
neighbours                  = ft_prepare_neighbours(cfg_neighb, Condition1{1});

%% cluster based permutation test
% configuration settings
cfg                     = [];
cfg.channel             = 'EEG';        % cell-array with selected channel labels
cfg.latency             = [0 1];      % time interval over which the experimental conditions must be compared (in seconds)
cfg.method              = 'montecarlo'; % use the Monte Carlo Method to calculate the significance probability
cfg.statistic           = 'depsamplesT';
cfg.correctm            = 'cluster';
cfg.clusteralpha        = 0.05;         % alpha level of the sample-specific test statistic that will be used for thresholding
cfg.clusterstatistic    = 'maxsum';     % test statistic that will be evaluated under the permutation distribution. 
cfg.minnbchan           = 2;            % minimum number of neighborhood channels that is required for a selected sample to be included in the clustering algorithm (default=0).                                        
cfg.neighbours          = neighbours;   
cfg.tail                = 0;            % -1, 1 or 0 (default = 0); one-sided or two-sided test
cfg.clustertail         = 0;
cfg.alpha               = 0.05;        % alpha level of the permutation test
cfg.numrandomization    = 500;         % number of draws from the permutation distribution
cfg.correcttail         = 'prob';      % correcting for two-sided test

% Design matrix
subj                    = length(subjects);           
design                  = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design              = design;        % design matrix 
cfg.uvar                = 1;             % unit variable
cfg.ivar                = 2;             % number or list with indices indicating the independent variable(s) EDIT FOR WITHIN

[stat] = ft_timelockstatistics(cfg, Condition1{:}, Condition2{:});

%save stat_ERP stat;

%% plot the results

%use of timelock grand average
cfg                 = [];
cfg.channel         = 'all';
cfg.latency         = [0 1];
cfg.parameter       = 'avg';
cond1               = ft_timelockgrandaverage(cfg, Condition1{:});
cond2               = ft_timelockgrandaverage(cfg, Condition2{:});

% plots
cfg                 = [];
cfg.operation       = 'subtract';
cfg.parameter       = 'avg';
contrast            = ft_math(cfg, cond1, cond2);

figure;  
% define parameters for plotting
timestep            = 0.05;      %(in seconds)
sampling_rate       = 500; 
sample_count        = length(stat.time);
j                   = [0:timestep:1];   % Temporal endpoints (in seconds) of the ERP average computed in each subplot
m                   = [1:timestep*sampling_rate:sample_count];  % temporal endpoints in MEEG samples
% get relevant (significant) values
pos_cluster_pvals   = [stat.posclusters(:).prob];
pos_signif_clust    = find(pos_cluster_pvals < stat.cfg.alpha);
pos                 = ismember(stat.posclusterslabelmat, pos_signif_clust);

% First ensure the channels to have the same order in the average and in the statistical output.
% This might not be the case, because ft_math might shuffle the order  
[i1,i2]             = match_str(contrast.label, stat.label); 

% plot
for k = 1:10;
     subplot(4,5,k);   
     cfg = [];   
     cfg.xlim=[j(k) j(k+1)];   
     %cfg.zlim = [-5e-14 5e-14];   
     pos_int = zeros(numel(contrast.label),1);
     pos_int(i1) = all(pos(i2, m(k):m(k+1)), 2);
     cfg.highlight = 'on';
     cfg.highlightchannel = find(pos_int);       
     cfg.comment = 'xlim';   
     cfg.commentpos = 'title';   
     cfg.layout = 'actiCAP_64ch_Standard2.mat';
     ft_topoplotER(cfg, contrast);
end 
