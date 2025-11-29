% clear all
% close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Sample Data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this sample data was not used for the analysis in our paper
load('data/SampleData.mat')
Data = SampleData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SampRate = 240;  % Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Peak Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ReferenceLine = ones(length(Data),1)*mean(Data);
Data = Data - ReferenceLine;

Bi = zeros(1,length(Data));
Bi(Data > 0) = 1 ;
T_e = find(diff(Bi) ==  1); % extention points
T_f = find(diff(Bi) == -1); % flexion points
T_f = T_f(T_f > T_e(1));    % remove points before the first extention point

n_i =  min(length(T_e),length(T_f));
PAmp  = [];
PTime = [];
for i = 1:n_i
    if T_e(i) < T_f(i)
        tim_window = T_e(i) : T_f(i);
        [PAmp(i), PTime(i)] = max(Data(tim_window));
        PTime(i) = PTime(i) + T_e(i) - 1;
    else
        disp(['ERROR!!!']);
        return
    end
end

PeakTime = PTime';
PeakAmp  = PAmp';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name',['Peak detection using sample data'],'NumberTitle','off');
hold on
line([0 length(Data)],[0 0]);
plot(Data)
plot(PeakTime,PeakAmp,'ro')
title(['sample data'])

ylabel('Elevation angle','FontSize',10);
xlabel('sampling time [240Hz)]','FontSize',10)
