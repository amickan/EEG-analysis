%%% Interference phase - ERPs - Permutation test for median split

%% Loading data 

subjects = [301:302, 304:308, 310:326, 328, 329]; % subjects that should be included in grand average
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\'); % directory with all preprocessed files 

% some global settings for plotting later on 
set(groot,'DefaultFigureColormap',jet);

cfg = [];
cfg.baseline = [-0.2 0];

Condition1 = cell(1,length(subjects));
Condition2 = cell(1,length(subjects));

for i = 1:length(subjects)
    % condition 1 for each participant
    filename1 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData\', num2str(subjects(i)), '_Pic1_mediansplit_high_1');
    dummy = load(filename1);
    Condition1{i} = ft_timelockanalysis(cfg, dummy.up1);
    Condition1{i} = ft_timelockbaseline(cfg, Condition1{i});
    clear dummy
    % condition 2 for each participant
    filename2 = strcat('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\PreprocessedData\', num2str(subjects(i)), '_Pic1_mediansplit_low_1');
    dummy2 = load(filename2);
    Condition2{i} = ft_timelockanalysis(cfg, dummy2.low1);
    Condition2{i} = ft_timelockbaseline(cfg, Condition2{i});
    clear dummy2
end

%% Permutation test 

% Create neighbourhood structure
cfg_neighb                  = [];
cfg_neighb.method           = 'triangulation';        
cfg_neighb.channel          = 'EEG';
cfg_neighb.layout           = 'EEG1010.lay';
cfg_neighb.feedback         = 'yes';
%cfg_neighb.neighbourdist    = 0.15; % higher number: more is linked!
neighbours                  = ft_prepare_neighbours(cfg_neighb, Condition1{1});

% Stats settings
cfg                     = [];
cfg.method              = 'montecarlo';       
cfg.channel             = {'EEG'};     
cfg.latency             = [0.35 1]; %[0.2 0.35];      % [0.35 1];
cfg.statistic           = 'ft_statfun_depsamplesT';         % within design
cfg.correctm            = 'cluster';
cfg.clusteralpha        = 0.05;                             % alpha level of the sample-specific test statistic that will be used for thresholding
cfg.clusterstatistic    = 'maxsum';                         % test statistic that will be evaluated under the permutation distribution. 
%cfg.minnbchan          = 2;                                % minimum number of neighborhood channels that is required for a selected sample to be included in the clustering algorithm (default=0).
cfg.neighbours          = neighbours;   
cfg.tail                = 0;                                % -1, 1 or 0 (default = 0); one-sided or two-sided test
cfg.clustertail         = 0;
cfg.alpha               = 0.05;                            % alpha level of the permutation test
cfg.numrandomization    = 2000;                              % number of draws from the permutation distribution
cfg.correcttail         = 'prob';

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

[stat]                  = ft_timelockstatistics(cfg, Condition1{:}, Condition2{:});

%% Permutation test results 

% calculate difference between conditions per subject 
cfg                 = [];
cfg.operation       = 'subtract';
cfg.parameter       = 'avg';
raweffect           = cell(1,length(subjects));
for i = 1:length(subjects)
    raweffect{i} = ft_math(cfg,Condition1{i},Condition2{i});
end

% grand average over participants difference scores
cfg                 = [];
raw                 = ft_timelockgrandaverage(cfg, raweffect{:});

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
        disp(['Positive cluster number ', num2str(i), ' has a p value of ', num2str(signclusters(i))])
        select = ismember(stat.posclusterslabelmat, pos_signif_clust(i));
        pos2 = ismember (stat.posclusterslabelmat, pos_signif_clust(i));
        [foundx,foundy] = find(select);
        % pos_int2 = all(pos2(:, min(foundy):max(foundy)),2); % no channels are significant over the total sign. time period....
        % find(pos_int2) % see upper comment
        starttime = stat.time(min(foundy));
        endtime = stat.time(max(foundy));
        
        %%% Topoplot for the cluster 
        figure;
        %colormap(redblue);
        %colorbar('eastoutside');
        cfg = [];
        cfg.xlim=[starttime endtime];  % in seconds!
        cfg.zlim = [-3 3];
        cfg.layout = 'EEG1010.lay';
        ft_topoplotER(cfg, raw);
        
        disp(['Positive cluster ', num2str(i), ' starts at ', num2str(starttime), ' s and ends at ', num2str(endtime), ' s'])
        disp(['the following ', num2str(length(unique(foundx'))),' channels are included in this significant cluster:  ', num2str(unique(foundx'))])
        disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
    end
end

if numberofsignclustersneg > 0
    for i = 1:length(signclustersneg)
        disp(['Negative cluster number ', num2str(i), ' has a p value of ', num2str(signclustersneg(i))])
        selectneg = ismember(stat.negclusterslabelmat, neg_signif_clust(i));
        pos2 = ismember (stat.negclusterslabelmat, neg_signif_clust(i));
        [foundx,foundy] = find(selectneg);
        % pos_int2 = all(pos2(:, min(foundy):max(foundy)),2); % no channels are significant over the total sign. time period....
        % find(pos_int2) % see upper comment
        starttime = stat.time(min(foundy));
        endtime = stat.time(max(foundy));
        
        %%% Topoplot for the cluster 
        figure;
        %colormap(redblue);
        colorbar('eastoutside');
        cfg = [];
        cfg.xlim=[starttime endtime];  % in seconds!
        cfg.zlim = [-2 2];
        cfg.layout = 'EEG1010.lay';
        ft_topoplotER(cfg, raw);
        
        disp(['Negative cluster ', num2str(i), ' starts at ', num2str(starttime), ' s and ends at ', num2str(endtime), ' s'])
        disp(['the following ', num2str(length(unique(foundx'))),' channels are included in this significant cluster:  ', num2str(unique(foundx'))])
        disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
    end
end