%% Loads all timing and Drag data from CFD results

rootFolder = '~/raw/';
cd(rootFolder);
folderNames = dir('case*'); 
nFolder = length(folderNames);


timing = nan(3,nFolder); % [mesh,cfd,total]
for iFolder = 1:nFolder
   % tmp = importdata(['case' digitInt2str(iFolder,4) '/forces.dat']);
   tmp = importdata([folderNames(iFolder).name '/forces.dat']);
   dragF(iFolder) = eval(tmp{end}(16:27));
    inTmp = csvread([folderNames(iFolder).name '/mesh.timing']);
   timing(1,iFolder) = inTmp(1);
    inTmp = csvread([folderNames(iFolder).name '/cfd.timing']);
   timing(2,iFolder) = inTmp(1);
    inTmp = csvread([folderNames(iFolder).name '/all.timing']);
   timing(3,iFolder) = inTmp(1);
end

%% Timings
hfig = figure(1); set(hfig,'color',[1 1 1],'name','Timings');
subplot(3,1,1); hist(timing(1,:),12); title(['Meshing Time -- ' seconds2human(median(timing(1,:)))]); 
 xlabel('Seconds')
subplot(3,1,2); hist(timing(2,:),12); title(['CFD Time -- ' seconds2human(median(timing(2,:)))]); 
xlabel('Seconds')
subplot(3,1,3); hist(timing(3,:),12); title(['Total Time -- ' seconds2human(median(timing(3,:)))]);  
xlabel('Seconds')
save2pdf('timings.pdf')

%% Drag Values
hfig = figure(2); clf; set(hfig,'color',[1 1 1],'name','Drag Values');
% subplot(2,1,1); plot(dragF); ylabel('Calcualted Drag Force'); xlabel('Simulation Timesteps'); 
% subplot(2,1,2); 
hist(dragF,20)%;set(gca,'XScale','log'); xlabel('C_D (log scale)')
title('Distribution of Drag Force Values'); xlabel('Drag Force (N)');
save2pdf('drag.pdf')

%% Drag and Timings
hfig = figure(3); set(hfig,'color',[1 1 1],'name','Drag and Simulation Time');
%scatter(timing(3,:), cD(end,:),'bo');
scatter(timing(3,:), dragF(end,:),'bo');

h=lsline; h.Color = 'k';h.LineStyle='--';h.LineWidth=2;
title('Correlation between Drag Force and Simulation Time?');
xlabel('Simulation time (in seconds)'); ylabel('C_D');

%save2pdf('correlation.pdf')

%% Best, Worst, Fastest, Slowest
% [cdVal,cdRank] = sort(cD(end,:));
% [tVal,tRank]   = sort(timing(3,:));
% best = cdRank(1);
% worst= cdRank(end);
% fastest= tRank(1);
% slowest= tRank(end);
%
%% Package into obsSet struct

% Just rename for now, we really want drag force not cD
dragF = dragF(:);
load('param.mat');
params = params(1:length(dragF),:);
save('#notallvelos5.mat','params','dragF')



