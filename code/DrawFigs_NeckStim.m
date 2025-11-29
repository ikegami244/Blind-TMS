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
DataName = 'Acquired Blind';

ms1 = 4;
ymin = -0.03;
ymax = 0.02;
xpos = 1 ;
col = [0 0 1];

Data = Data_STM-Data_NON;

hold on;
L1 = line([0 2],[0 0]);
set(L1,'color',[1 1 1]*0.3,'LineStyle','--','linewidth',0.5)
Data(ABLDSubID,:)
plot(xpos+(0.5-rand(1,numel(ABLDSubID)))*0.05+0.1,Data(ABLDSubID,:)','color',col,'LineStyle','none','linewidth',0.5,...
    'Marker','o','MarkerEdgeColor',col,'MarkerFaceColor','none','MarkerSize',ms1);
plot(xpos+(0.5-rand(1,numel(NABLDSubID)))*0.05+0.1,Data(NABLDSubID,:)','color',col,'LineStyle','none','linewidth',0.5,...
    'Marker','o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',ms1);

boxplot(Data',xpos,'position',xpos,'Symbol','','Widths',0.1,...
    'Whisker',10,'color',col);

axis([xpos-0.25 xpos+0.25 ymin ymax]);
set(gca, 'XTick', xpos)
set(gca, 'YTick', ymin:0.01:ymax)
set(gca, 'XTickLabel',[]);
ylabel('ΔSD of the cycle duraion (sec)','FontSize',10)

tx = text(xpos,ymax+0.002,DataName);
set(tx,'FontSize',10,'FontName','Arial','HorizontalAlignment','center',...
    'fontweight','bold','color',col,'FontSize',15);
end




