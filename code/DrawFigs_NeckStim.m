clear all
% close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('data/PeakTime_NeckStim.mat')

% - PT includes the peak time data of both feet of both blocks
%   for 10 stimulation trials and 10 no-stimulation trials for each of all 11 acquired participants.
%   Odd-numbered trials are in the stimulation condition while even-numbered
%   trials are in the no-stimulation condition.
% - The order of the participants' data is consistent with the participant # shown in Table 3

% - PT(SubID).L{site,blk} :left foot data
%            .R{site,blk} :right foot data
%    SubID: participants' ID (#2,6,7,8,12,25-30 in Table 3)
%    blk: 1: first block, 2: second block  

% - Missing Data: no data for the 1st block of participant #7
%   (i.e., PT(3).R{:,1} == NaN; PT(3).R{:,1} == NaN)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subject Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ABLDSubID NABLDSubID

ABLDSubID    = 1:2;
NABLDSubID   = 3:11;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subnum   = 11; % number of participants
blknum   = 2;  % number of blocks
trlnum   = 10; % number of trials (for each block)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate SD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for sub = 1:subnum
    CycleDurL = [];
    CycleDurR = [];
    SDL = [];
    SDR = [];

    for blk = 1:blknum % block

        for trl = 1:trlnum % stimulation site
            CycleDurL{10*(blk-1)+trl} = diff(PT(sub).L{trl,blk})/240; %unit-->sec
            CycleDurR{10*(blk-1)+trl} = diff(PT(sub).R{trl,blk})/240;

            SDL(10*(blk-1)+trl) = nanstd(CycleDurL{10*(blk-1)+trl});
            SDR(10*(blk-1)+trl) = nanstd(CycleDurR{10*(blk-1)+trl});
        end
    end

    SD(:,sub) = nanmean([SDL;SDR]);
    SD_nTMS = SD(1:2:end,sub); % no-stim condition
    SD_TMS  = SD(2:2:end,sub);  % neckstim condition
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw Figure 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DrawBarGraph_Haptic(SD);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FIG = DrawBarGraph_Haptic(SD)

global ABLDSubID NABLDSubID

FIG = figure('Name',['SD for neck stimulation'],'NumberTitle','off');
Data_NON = nanmean(SD(1:2:20,:),1)';
Data_STM = nanmean(SD(2:2:20,:),1)';
stimsite = 'neck';

ms1 = 2;
offset1 = [-0.15 0.15];
ymax = 0.25;


DataName = 'Blind';
xpos1 = 1 ;
xpos2 = 2 ;
xpos  = offset1+xpos1 ;
col = [0 0 1];
Data = [Data_NON , Data_STM];

hold on;
b1 = bar(xpos,nanmean(Data,1));
set(b1,'EdgeColor',col,'FaceColor',col,'FaceAlpha',0.5,'BarWidth',0.5, 'LineWidth',1,'LineStyle','none')

plot(xpos,Data(ABLDSubID,:)','color',col,'LineStyle','-','linewidth',0.5);
plot(xpos,Data(NABLDSubID,:)','color',col,'LineStyle','--','linewidth',0.5);

tx = text(mean(xpos),ymax-0.04,DataName);
set(tx,'FontSize',10,'FontName','Arial','HorizontalAlignment','center',...
    'fontweight','bold','color',col,'FontSize',15);
 
axis([xpos1-0.5 xpos1+0.5 0 ymax]);
set(gca, 'XTick',xpos)
set(gca, 'YTick', [0:0.05:0.25])

set(gca, 'XTickLabel',{'no stim','neck stim'});
ylabel('SD of the cycle duraion (sec)','FontSize',10)

end




