% clear all
% close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('data/PeakTime.mat')

% - PT includes the peak time data of both feet of both blocks
%   for 14 stimulation trials(sites) and no-stimulation trial for each of all the 28 participants.
% - The order of the participants' data is consistent with the participant # shown in Table 1

% - PT(SubID).L{site,blk} :left foot data
%            .R{site,blk} :right foot data
%    SubID: participants' ID (1-28)
%    site:  1-14: stimulation site, 15: no stimulation
%    blk: 1: first block, 2: second block  

% - Missing Data: no data for the 1st block of stimulation site #14 for participant #23
%   (i.e., PT(23).L{14,1} == NaN; PT(23).R{14,1} == NaN)

% - Excluded Data: we excluded the right foot data in the 2nd block of stimulation site # 5 for participant #20 (see PT)
%   (i.e., PT(20).R{5,2} == NaN)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subject Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global BlindSubID SightedSubID ConBLDSubID ABLDSubID NABLDSubID

BlindSubID   = 1:12;
SightedSubID = 13:24;
ConBLDSubID  = 25:28;

ABLDSubID    = 1:6;
NABLDSubID   = 7:12;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subnum   = 28; % number of participants
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
DrawBarGraph(SD,'11');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw Supplementary Figure S1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DrawBarGraph(SD,'all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw Supplementary Figure S2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DrawCBLdata(SD,'11');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FIG = DrawBarGraph(SD,site)

global BlindSubID SightedSubID ABLDSubID NABLDSubID


if strcmp(site, '11')
    FIG = figure('Name',['Fig.2: SD for pV1/V2'],'NumberTitle','off');
    Data_BL = SD(11,BlindSubID)';
    Data_SI  = SD(11,SightedSubID)';
    stimsite = 'pV1/V2';
    
elseif strcmp(site, 'all')
    FIG = figure('Name',['Fig.S1: SD for all sites'],'NumberTitle','off');
    Data_BL = mean(SD(1:14,BlindSubID),1)';
    Data_SI  = mean(SD(1:14,SightedSubID),1)';
    stimsite = 'all sites';
    
end

ms1 = 2;
offset1 = [-0.15 0.15] + 0.03;
offset2 = [-0.15 0.15];
ymax = 0.25; 


for gr = 1:2 % group
    switch gr
        case 1
            DataName = 'Blind';
            xpos1 = 1 ;
            xpos  = xpos1;
            col = [0 0 1];
            Data = [SD(15,BlindSubID)',Data_BL];
            
        case 2
            DataName = 'Sighted';
            xpos2 = 1.8 ;
            xpos  = xpos2;
            col = [1 0 0];
            Data = [SD(15,SightedSubID)',Data_SI];
    end
    
    hold on;
    b1 = bar(xpos,mean(Data,1));
    set(b1,'EdgeColor',col,'FaceColor',col,'FaceAlpha',0.5,'BarWidth',0.5, 'LineWidth',1,'LineStyle','none')
    
    if gr == 1
        plot(xpos+offset1,Data(ABLDSubID,:)','color',col,'LineStyle','-','linewidth',0.5);
        plot(xpos+offset1,Data(NABLDSubID,:)','color',col,'LineStyle','--','linewidth',0.5);
    else
        plot(xpos+offset1,Data','color',col,'LineStyle','-','linewidth',0.5);
    end

    tx = text(xpos,ymax-3/240,DataName);
    set(tx,'FontSize',10,'FontName','Arial','HorizontalAlignment','center',...
        'fontweight','bold','color',col,'FontSize',15);
end

axis([xpos1-0.5 xpos2+0.5 0 ymax]);
set(gca, 'XTick', [xpos1+offset2,xpos2+offset2])
set(gca, 'YTick', [0:0.05:0.25])

set(gca, 'XTickLabel',{'no stim',stimsite,'no stim',stimsite});
ylabel('SD of the cycle duraion (sec)','FontSize',10)

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FIG = DrawCBLdata(SD,site)

global ConBLDSubID

if strcmp(site, '11')
    FIG = figure('Name',['Fig.3: SD for pV1/V2'],'NumberTitle','off');
    Data_CBL = SD(11,ConBLDSubID)';
    stimsite = 'pV1/V2';
    
elseif strcmp(site, 'all')
    FIG = figure('Name',['Fig.S2: SD for all sites'],'NumberTitle','off');
    Data_CBL = mean(SD(1:14,ConBLDSubID),1)';
    stimsite = 'all sites';
    
end

ms1 = 8;
offset1 = [-0.15 0.15] + 0.03;
offset2 = [-0.15 0.15];
ymax = 0.25;

DataName = 'ConBlind';
xpos1 = 1 ;
col = [0 1 0];
Data = [SD(15,ConBLDSubID)',Data_CBL];

hold on;
synb = {'o','p','s','v'};

for sub = 1:length(Data_CBL)
    hold on
    h1 = plot(xpos1+offset1,Data(sub,:)');
    set(h1,'marker',synb{sub}, 'markersize',ms1,'MarkerFaceColor',col,'MarkerEdgeColor','k','Color',col,'linewidth',0.5)
end

axis([xpos1-0.3 xpos1+0.3 0 ymax]);
set(gca, 'XTick', [offset1+xpos1])
set(gca, 'YTick', [0:0.05:0.25])
set(gca, 'XTickLabel',{'no stim',stimsite});
ylabel('SD of the cycle duraion (sec)','FontSize',10)
lgd = legend({'participant #25','participant #26','participant #27','participant #28'});
lgd.NumColumns = 2;
lgd.Location = 'north';

end


