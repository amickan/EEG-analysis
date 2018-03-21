%% Loading all preprocessed data 

subjects = [301:308, 310:326, 328, 329]; % subjects that should be included in grand average
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\'); % directory with all preprocessed files 
%cd('/Volumes/wrkgrp/STD-Back-Up-Exp2-EEG') %
cfg = [];
%cfg.keeptrials='yes';
cfg.baseline = [-0.2 0];

Condition1 = cell(1,27);
Condition2 = cell(1,27);

for i = 1:length(subjects)
    % condition 1 for each participant
    filename1 = strcat('PreprocessedData/', num2str(subjects(i)), '_data_clean_cond1');
    dummy = load(filename1);
    Condition1{i} = ft_timelockanalysis(cfg, dummy.data_finaltestcond1);
    Condition1{i} = ft_timelockbaseline(cfg, Condition1{i});
    % condition 2 for each participant
    filename2 = strcat('PreprocessedData/', num2str(subjects(i)), '_data_clean_cond2');
    dummy2 = load(filename2);
    Condition2{i} = ft_timelockanalysis(cfg, dummy2.data_finaltestcond2);
    Condition2{i} = ft_timelockbaseline(cfg, Condition2{i});
end

% grand-average over subjects per condition 
cfg = [];
cfg.keepindividuals='yes';
cond1 = ft_timelockgrandaverage(cfg, Condition1{:});
cond2 = ft_timelockgrandaverage(cfg, Condition2{:});

%% different way of calculating average
%cfg = [];
%cfg.parameter = 'avg';
%cfg.operation = 'add';
%cond1sum = ft_math(cfg, Condition1{:});
%cond12sum = ft_math(cfg, Condition2{:});
%cfg = [];
%cfg.parameter = 'divide';
%cfg.scalar = 27;
%cond1 = ft_math(cfg, cond1sum.avg);
%cond2 = ft_math(cfg, cond2sum.avg);

% plotting average
cfg = [];
cfg.layout = 'actiCAP_64ch_Standard2.mat';
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
cfg.showlabels = 'yes'; 
cfg.fontsize = 6; 
%cfg.ylim = [-3e-13 3e-13];
ft_multiplotER(cfg, cond1, cond2);

% manual plot with some electrodes
fig = figure;

subplot(8,8,3);
plot ((cond1.time)*1000, cond1.avg(XXX,:), 'r', (cond1.time)*1000, cond2.avg(XXX,:), 'k');
title('AF3');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,4);
plot ((cond1.time)*1000, cond1.avg(36,:), 'r', (cond1.time)*1000, cond2.avg(36,:), 'k');
title('AFz');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,5);
plot ((cond1.time)*1000, cond1.avg(XXX,:), 'r', (cond1.time)*1000, cond2.avg(XXX,:), 'k');
title('AF4');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,17);
plot ((cond1.time)*1000, cond1.avg(26,:), 'r', (cond1.time)*1000, cond2.avg(26,:), 'k');
title('FC5');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,10);
plot ((cond1.time)*1000, cond1.avg(28,:), 'r', (cond1.time)*1000, cond2.avg(28,:), 'k');
title('F3');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,12);
plot ((cond1.time)*1000, cond1.avg(25,:), 'r', (cond1.time)*1000, cond2.avg(25,:), 'k');
title('Fz');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,14);
plot ((cond1.time)*1000, cond1.avg(2,:), 'r', (cond1.time)*1000, cond2.avg(2,:), 'k');
title('F4');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');


subplot(8,8,23);
plot ((cond1.time)*1000, cond1.avg(4,:), 'r', (cond1.time)*1000, cond2.avg(4,:), 'k');
title('FC6');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,33);
plot ((cond1.time)*1000, cond1.avg(18,:), 'r', (cond1.time)*1000, cond2.avg(18,:), 'k');
title('CP5');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,26);
plot ((cond1.time)*1000, cond1.avg(21,:), 'r', (cond1.time)*1000, cond2.avg(21,:), 'k');
title('C3');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,28);
plot ((cond1.time)*1000, cond1.avg(12,:), 'r', (cond1.time)*1000, cond2.avg(12,:), 'k');
title('Cz');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,30);
plot ((cond1.time)*1000, cond1.avg(5,:), 'r',(cond1.time)*1000, cond2.avg(5,:), 'k');
title('C4');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,39);
plot ((cond1.time)*1000, cond1.avg(8,:), 'r', (cond1.time)*1000, cond2.avg(8,:), 'k');
title('CP6');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,42);
plot ((cond1.time)*1000, cond1.avg(17,:), 'r', (cond1.time)*1000, cond2.avg(17,:), 'k');
title('P3');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,44);
plot ((cond1.time)*1000, cond1.avg(13,:), 'r', (cond1.time)*1000, cond2.avg(13,:), 'k');
title('Pz');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,46);
plot ((cond1.time)*1000, cond1.avg(11,:), 'r',(cond1.time)*1000, cond2.avg(11,:), 'k');
title('P4');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');


subplot(8,8,59);
plot ((cond1.time)*1000, cond1.avg(15,:), 'r', (cond1.time)*1000, cond2.avg(15,:), 'k');
title('O1');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,60);
plot ((cond1.time)*1000, cond1.avg(14,:), 'r', (cond1.time)*1000, cond2.avg(14,:), 'k');
title('Oz');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,61);
plot ((cond1.time)*1000, cond1.avg(10,:), 'r', (cond1.time)*1000, cond2.avg(10,:), 'k');
title('O2');
ylim([-10 10]);
xlim([-200 1200]); 
hold on
line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

h = get(gca,'Children');
v = [h(1) h(3)];
legend1 = legend(v,'Interference', 'No Interference');
set(legend1,...
    'Position',[0.817402439320025 0.207759699624531 0.0596115241601035 0.108208554452382]);