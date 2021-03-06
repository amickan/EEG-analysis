%%%% Final test ERPs - grand average script %%%

%% load data 
subjects        = [301:308, 310:326, 328, 329];     % subjects that should be included in grand average
cd('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\');    % directory with all preprocessed files 

cfg                 = [];
cfg.keeptrials      = 'no';
cfg.baseline        = [-0.2 0];

% initiate empty cell arrays per condition for subject averages 
Condition1          = cell(1,length(subjects));
Condition2          = cell(1,length(subjects));

for i = 1:length(subjects)
    % condition 1 for each participant
    filename1 = strcat('PreprocessedData_secondhalf\', num2str(subjects(i)), '_data_clean_2_cond1_witherrors');
    %filename1 = strcat('PreprocessedData_firsthalf_new\', num2str(subjects(i)), '_data_clean_1_cond1_witherrors');
    dummy = load(filename1);
    %Condition1{i} = ft_timelockanalysis(cfg, dummy.data_cond12);
    Condition1{i} = ft_timelockanalysis(cfg, dummy.data_cond12);
    Condition1{i} = ft_timelockbaseline(cfg, Condition1{i});
    clear dummy filename1
    
    % condition 2 for each participant
    filename2 = strcat('PreprocessedData_secondhalf\', num2str(subjects(i)), '_data_clean_2_cond2_witherrors');
    %filename2 = strcat('PreprocessedData_firsthalf_new\', num2str(subjects(i)), '_data_clean_1_cond2_witherrors');
    dummy2 = load(filename2);
    %Condition2{i} = ft_timelockanalysis(cfg, dummy2.data_cond22);
    Condition2{i} = ft_timelockanalysis(cfg, dummy2.data_cond22);
    Condition2{i} = ft_timelockbaseline(cfg, Condition2{i});
    clear dummy2 filename2
    
    disp(subjects(i));
end

%% grand-average over subjects per condition 
cfg                     = [];
cfg.keepindividuals     = 'no';
cond1                   = ft_timelockgrandaverage(cfg, Condition1{:});
cond2                   = ft_timelockgrandaverage(cfg, Condition2{:});
clear Condition2 Condition1

% plotting average
% cfg = [];
% cfg.layout = 'actiCAP_64ch_Standard2.mat';
% cfg.interactive = 'yes';
% cfg.showoutline = 'yes';
% cfg.showlabels = 'yes'; 
% cfg.fontsize = 6; 
% %cfg.ylim = [-3e-13 3e-13];
% ft_multiplotER(cfg, cond1, cond2);

%% Plotting
fig = figure;
xLeft = -200;
xRight = 1000; 
yMin = -10;
yMax = 13;

subplot(8,8,3);
plot ((cond1.time)*1000, cond1.avg(57,:), 'r', (cond1.time)*1000, cond2.avg(57,:), 'k' ,'Linewidth', 1);
title('AF3');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,4);
plot ((cond1.time)*1000, cond1.avg(37,:), 'r', (cond1.time)*1000, cond2.avg(37,:), 'k','Linewidth', 1);
title('AFz');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,5);
plot ((cond1.time)*1000, cond1.avg(30,:), 'r', (cond1.time)*1000, cond2.avg(30,:), 'k','Linewidth', 1);
title('AF4');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');


subplot(8,8,10);
plot ((cond1.time)*1000, cond1.avg(54,:), 'r', (cond1.time)*1000, cond2.avg(54,:), 'k','Linewidth', 1);
title('F5');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,11);
plot ((cond1.time)*1000, cond1.avg(51,:), 'r', (cond1.time)*1000, cond2.avg(51,:), 'k','Linewidth', 1);
title('F1');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,12);
plot ((cond1.time)*1000, cond1.avg(25,:), 'r', (cond1.time)*1000, cond2.avg(25,:), 'k','Linewidth', 1);
title('Fz');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,13);
plot ((cond1.time)*1000, cond1.avg(32,:), 'r', (cond1.time)*1000, cond2.avg(32,:), 'k','Linewidth', 1);
title('F2');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,14);
plot ((cond1.time)*1000, cond1.avg(33,:), 'r', (cond1.time)*1000, cond2.avg(33,:), 'k','Linewidth', 1);
title('F6');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,17);
plot ((cond1.time)*1000, cond1.avg(26,:), 'r', (cond1.time)*1000, cond2.avg(26,:), 'k','Linewidth', 1);
title('FC5');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,18);
plot ((cond1.time)*1000, cond1.avg(52,:), 'r', (cond1.time)*1000, cond2.avg(52,:), 'k','Linewidth', 1);
title('FC3');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,19);
plot ((cond1.time)*1000, cond1.avg(22,:), 'r', (cond1.time)*1000, cond2.avg(22,:), 'k','Linewidth', 1);
title('FC1');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,20);
plot ((cond1.time)*1000, cond1.avg(23,:), 'r', (cond1.time)*1000, cond2.avg(23,:), 'k','Linewidth', 1);
title('FCZ');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,21);
plot ((cond1.time)*1000, cond1.avg(24,:), 'r', (cond1.time)*1000, cond2.avg(24,:), 'k','Linewidth', 1);
title('FC2');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,22);
plot ((cond1.time)*1000, cond1.avg(53,:), 'r', (cond1.time)*1000, cond2.avg(53,:), 'k','Linewidth', 1);
title('FC4');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,23);
plot ((cond1.time)*1000, cond1.avg(4,:), 'r', (cond1.time)*1000, cond2.avg(4,:), 'k','Linewidth', 1);
title('FC6');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,33);
plot ((cond1.time)*1000, cond1.avg(18,:), 'r', (cond1.time)*1000, cond2.avg(18,:), 'k','Linewidth', 1);
title('CP5');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,25);
plot ((cond1.time)*1000, cond1.avg(48,:), 'r', (cond1.time)*1000, cond2.avg(48,:), 'k','Linewidth', 1);
title('C5');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,26);
plot ((cond1.time)*1000, cond1.avg(21,:), 'r', (cond1.time)*1000, cond2.avg(21,:), 'k','Linewidth', 1);
title('C3');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,27);
plot ((cond1.time)*1000, cond1.avg(50,:), 'r', (cond1.time)*1000, cond2.avg(50,:), 'k','Linewidth', 1);
title('C1');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,28);
plot ((cond1.time)*1000, cond1.avg(12,:), 'r', (cond1.time)*1000, cond2.avg(12,:), 'k','Linewidth', 1);
title('Cz');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,29);
plot ((cond1.time)*1000, cond1.avg(51,:), 'r', (cond1.time)*1000, cond2.avg(51,:), 'k','Linewidth', 1);
title('C2');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,30);
plot ((cond1.time)*1000, cond1.avg(5,:), 'r',(cond1.time)*1000, cond2.avg(5,:), 'k','Linewidth', 1);
title('C4');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,31);
plot ((cond1.time)*1000, cond1.avg(35,:), 'r',(cond1.time)*1000, cond2.avg(35,:), 'k','Linewidth', 1);
title('C6');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,34);
plot ((cond1.time)*1000, cond1.avg(47,:), 'r', (cond1.time)*1000, cond2.avg(47,:), 'k','Linewidth', 1);
title('CP3');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,35);
plot ((cond1.time)*1000, cond1.avg(19,:), 'r', (cond1.time)*1000, cond2.avg(19,:), 'k','Linewidth', 1);
title('CP1');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,36);
plot ((cond1.time)*1000, cond1.avg(41,:), 'r', (cond1.time)*1000, cond2.avg(41,:), 'k','Linewidth', 1);
title('CPz');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,37);
plot ((cond1.time)*1000, cond1.avg(7,:), 'r', (cond1.time)*1000, cond2.avg(7,:), 'k','Linewidth', 1);
title('CP2');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,38);
plot ((cond1.time)*1000, cond1.avg(36,:), 'r', (cond1.time)*1000, cond2.avg(36,:), 'k','Linewidth', 1);
title('CP4');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,39);
plot ((cond1.time)*1000, cond1.avg(8,:), 'r', (cond1.time)*1000, cond2.avg(8,:), 'k','Linewidth', 1);
title('CP6');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,41);
plot ((cond1.time)*1000, cond1.avg(16,:), 'r', (cond1.time)*1000, cond2.avg(16,:), 'k','Linewidth', 1);
title('P7');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,42);
plot ((cond1.time)*1000, cond1.avg(17,:), 'r', (cond1.time)*1000, cond2.avg(17,:), 'k','Linewidth', 1);
title('P3');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,43);
plot ((cond1.time)*1000, cond1.avg(42,:), 'r', (cond1.time)*1000, cond2.avg(42,:), 'k','Linewidth', 1);
title('P1');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,44);
plot ((cond1.time)*1000, cond1.avg(13,:), 'r', (cond1.time)*1000, cond2.avg(13,:), 'k','Linewidth', 1);
title('Pz');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,45);
plot ((cond1.time)*1000, cond1.avg(40,:), 'r', (cond1.time)*1000, cond2.avg(40,:), 'k','Linewidth', 1);
title('P2');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,46);
plot ((cond1.time)*1000, cond1.avg(11,:), 'r',(cond1.time)*1000, cond2.avg(11,:), 'k','Linewidth', 1);
title('P4');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,47);
plot ((cond1.time)*1000, cond1.avg(9,:), 'r', (cond1.time)*1000, cond2.avg(9,:), 'k','Linewidth', 1);
title('P8');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,51);
plot ((cond1.time)*1000, cond1.avg(44,:), 'r', (cond1.time)*1000, cond2.avg(44,:), 'k','Linewidth', 1);
title('PO3');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,52);
plot ((cond1.time)*1000, cond1.avg(43,:), 'r', (cond1.time)*1000, cond2.avg(43,:), 'k','Linewidth', 1);
title('POz');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

subplot(8,8,53);
plot ((cond1.time)*1000, cond1.avg(39,:), 'r', (cond1.time)*1000, cond2.avg(39,:), 'k','Linewidth', 1);
title('PO4');
ylim([yMin yMax]);
xlim([xLeft xRight]); 
hold on
line('XData', [xLeft xRight], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [yMin yMax], 'LineWidth', 0.5);
set(gca,'YDir','reverse');

% subplot(8,8,59);
% plot ((cond1.time)*1000, cond1.avg(15,:), 'r', (cond1.time)*1000, cond2.avg(15,:), 'k');
% title('O1');
% ylim([-10 10]);
% xlim([-200 1200]); 
% hold on
% line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
% line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
% set(gca,'YDir','reverse');
% 
% subplot(8,8,60);
% plot ((cond1.time)*1000, cond1.avg(14,:), 'r', (cond1.time)*1000, cond2.avg(14,:), 'k');
% title('Oz');
% ylim([-10 10]);
% xlim([-200 1200]); 
% hold on
% line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
% line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
% set(gca,'YDir','reverse');
% 
% subplot(8,8,61);
% plot ((cond1.time)*1000, cond1.avg(10,:), 'r', (cond1.time)*1000, cond2.avg(10,:), 'k');
% title('O2');
% ylim([-10 10]);
% xlim([-200 1200]); 
% hold on
% line('XData', [-200 1200], 'YData', [0 0], 'LineWidth', 1);
% line('XData', [0 0], 'YData', [-10 10], 'LineWidth', 0.5);
% set(gca,'YDir','reverse');

%h = get(gca,'Children');
%v = [h(1) h(3)];
legend1 = legend('Interference', 'No Interference');
set(legend1,...
    'Position',[0.817402439320025 0.207759699624531 0.0596115241601035 0.108208554452382]);