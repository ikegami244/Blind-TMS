clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('data/PeakTime.mat')

% - PT includes the peak time data of both feet of both blocks
%   for 14 stimulation trials(sites) and no-stimulation trial for each of all the 36 participants.
% - The order of the participants' data is consistent with the participant # shown in Table 1

% - PT(SubID).L{site,blk} :left foot data
%            .R{site,blk} :right foot data
%    SubID: participants' ID (1-36)
%    site:  1-14: stimulation site, 15: no stimulation
%    blk: 1: first block, 2: second block  

% - Exclusion or missing data (see Methods in the text) are set to NaN 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subject Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global BlindSubID SightedSubID ConBLDSubID ABLDSubID NABLDSubID

BlindSubID   = 1:12;
ConBLDSubID  = 13:24;
SightedSubID = 25:36;

ABLDSubID    = 1:6;
NABLDSubID   = 7:12;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subnum   = 36; % number of participants
blknum   = 2;  % number of blocks
sitenum  = 15; % number of stimulation sites (15: no stimulation trial)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate SD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for SubID = 1:subnum % participant
    CycleDurL = [];
    CycleDurR = [];
    SDL = [];
    SDR = [];

    for blk = 1:blknum % block
        for site = 1:sitenum % stimulation site
            CycleDurL{site,blk} = diff(PT(SubID).L{site,blk})/240; %unit-->sec
            CycleDurR{site,blk} = diff(PT(SubID).R{site,blk})/240;

            SDL(site,blk) = std(CycleDurL{site,blk});
            SDR(site,blk) = std(CycleDurR{site,blk});

        end
    end
    SD(:,SubID) = nanmean([SDL,SDR],2);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw Figure 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DrawFig(SD,'11');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw Supplementary Figure S1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DrawFig(SD,'all');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FIG = DrawFig(SD,site)

global BlindSubID SightedSubID ABLDSubID NABLDSubID ConBLDSubID

% (1) Comparison of SDs between stim and no-stim conditions

if strcmp(site, '11')
    FIG = figure('Name','Fig.2: SD for pV1/V2','NumberTitle','off');
    Data_BL = SD(11,BlindSubID)';
    Data_CBL = SD(11,ConBLDSubID)';
    Data_SI  = SD(11,SightedSubID)';    
    stimsite = 'pV1/V2';
    
elseif strcmp(site, 'all')
    FIG = figure('Name','Fig.S1: SD for all sites','NumberTitle','off');
    Data_BL = nanmean(SD(1:14,BlindSubID),1)';
    Data_CBL = nanmean(SD(1:14,ConBLDSubID),1)';
    Data_SI  = nanmean(SD(1:14,SightedSubID),1)';
    stimsite = 'all sites';
    
end

ms1 = 4;
offset1 = [-0.15 0.15] ;
offset2 = [-0.15 0.15];
ymax = 0.35; 


for gr = 1:3 % group
    switch gr
        case 1
            DataName = 'AcqBlind';
            xpos1 = 1 ;
            xpos  = xpos1;
            col = [0 0 1];
            Data = [SD(15,BlindSubID)',Data_BL];
            
        case 2
            DataName = 'ConBlind';
            xpos2 = 2 ;
            xpos  = xpos2;
            col = [0 1 0];
            Data = [SD(15,ConBLDSubID)',Data_CBL];
        
        case 3
            DataName = 'Sighted';
            xpos3 = 3 ;
            xpos  = xpos3;
            col = [1 0 0];
            Data = [SD(15,SightedSubID)',Data_SI];
    end

    subplot(2,1,1)
    hold on;

    if gr == 1
        hold on
        plot(xpos+offset1,Data(ABLDSubID,:)','color',col,'LineStyle','--','linewidth',0.5,...
            'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',col,'MarkerSize',ms1);
        plot(xpos+offset1,Data(NABLDSubID,:)','color',col,'LineStyle','-','linewidth',0.5,...
            'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',col,'MarkerSize',ms1);
    else
        plot(xpos+offset1,Data','color',col,'LineStyle','-','linewidth',0.5,...
            'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',col,'MarkerSize',ms1);
    end

    tx = text(xpos,ymax+10/240,DataName);
    set(tx,'FontSize',10,'FontName','Arial','HorizontalAlignment','center',...
        'fontweight','bold','color',col,'FontSize',15);
end

axis([xpos1-0.5 xpos3+0.5 0 ymax]);
set(gca, 'XTick', [xpos1+offset2,xpos2+offset2,xpos3+offset2])
set(gca, 'YTick', 0:0.05:0.30)
set(gca, 'XTickLabel',{'no stim',stimsite,'no stim',stimsite,'no stim',stimsite});
ylabel('SD of the cycle duraion (sec)','FontSize',10)



%  Delta SD
if strcmp(site, '11')
    Data_BL = SD(11,BlindSubID)'-SD(15,BlindSubID)';
    Data_CBL = SD(11,ConBLDSubID)'-SD(15,ConBLDSubID)';
    Data_SI  = SD(11,SightedSubID)'-SD(15,SightedSubID)';    
    stimsite = 'pV1/V2';
    ymin = -0.1; 

elseif strcmp(site, 'all')
    Data_BL = nanmean(SD(1:14,BlindSubID),1)'-SD(15,BlindSubID)';
    Data_CBL = nanmean(SD(1:14,ConBLDSubID),1)'-SD(15,ConBLDSubID)';
    Data_SI  = nanmean(SD(1:14,SightedSubID),1)'-SD(15,SightedSubID)';
    stimsite = 'all sites';
    ymin = -0.125;    
end

ymax = 0.07; 

for gr = 1:3 % group
    switch gr
        case 1
            DataName = 'AcqBlind';
            xpos1 = 1 ;
            xpos  = xpos1;
            col = [0 0 1];
            Data = Data_BL;
            
        case 2
            DataName = 'ConBlind';
            xpos2 = 1.5 ;
            xpos  = xpos2;
            col = [0 1 0];
            Data = Data_CBL;
        
        case 3
            DataName = 'Sighted';
            xpos3 = 2 ;
            xpos  = xpos3;
            col = [1 0 0];
            Data = Data_SI;
    end

    subplot(2,1,2)
    hold on;

    L1 = line([0 3],[0 0]);
    set(L1,'color',[1 1 1]*0.3,'LineStyle','--','linewidth',0.5)
    
    if gr == 1
        hold on
        plot(xpos+(0.5-rand(1,6))*0.05+0.1,Data(ABLDSubID,:)','color',col,'LineStyle','none','linewidth',0.5,...
            'Marker','o','MarkerEdgeColor',col,'MarkerFaceColor','none','MarkerSize',ms1);
        plot(xpos+(0.5-rand(1,6))*0.05+0.1,Data(NABLDSubID,:)','color',col,'LineStyle','none','linewidth',0.5,...
            'Marker','o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',ms1);
    else
        plot(xpos+(0.5-rand(1,length(Data)))*0.05+0.1,Data','color',col,'LineStyle','none','linewidth',0.5,...
            'Marker','o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',ms1);
    end
        boxplot(Data',xpos,'position',xpos,'Symbol','','Widths',0.1,...
            'Whisker',10,'color',col); 
end

axis([xpos1-0.25 xpos3+0.25 ymin ymax]);
set(gca, 'XTick', [xpos1,xpos2,xpos3]);
set(gca, 'YTick', ymin:0.025:ymax);
set(gca, 'XTickLabel',[]);
ylabel('ΔSD of the cycle duraion (sec)','FontSize',10);

end
