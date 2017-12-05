% viewResults -- Use this file to visualize results. It is assumed that
% input files have the form produced by 'compileResults.m':
%   file names "<rep>_result.mat"
%
% The representations should be defined in the 'rep' variable as strings
%
% Plots are produced which compare each run by:
%   - Model Accuracy at each PE (Box Plots)
%   - Model Accuracy at 1000 PE (Maps)
%   - Performance at each PE    (Line, as % of optimum)
%   - Performance at 1000 PE    (Maps)
%
% See also: compileResults
%
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 01-Sep-2017

clear; 
print2pdf = false; %#ok<*UNRCH>
if(print2pdf);set(0,'DefaultFigureWindowStyle','normal');end

%%
rep = {'parsec','ffd','cppn'};
nRep = length(rep);
for iRep=1:nRep;load([rep{iRep} '_result']);end

%--- For plotting only ---|
% It is assumed all compared maps have the same resolutions and were
% evaluated at the same number of PEs.
eval(['evalPt= ' rep{1} ' .evalPt']);
eval(['fitBins = size(' rep{1} '.predFitness,1) * size(' rep{1} '.predFitness,2);']);
eval(['peBins  = size(' rep{1} '.predFitness,3)']);
eval(['d = ' rep{1} '_Domain']); 
byItr = @(x) reshape(x,[fitBins peBins]);
colors = parula(nRep+1); % The bright yellow is heard to read...
%-------------------------|

%% Accuracy of Models
fh(1) = figure(1); clf; fh(1).Name = 'Model Accuracy'; hold on;
fh(1).Position = [2751,151,850,902];

% at each PE
boxPlotBins = (nRep+1)*peBins; % One NAN block in between each PE set for readability
for iRep=1:nRep
    eval(['acc{iRep} = nan(fitBins,boxPlotBins); acc{iRep}(:,iRep:(nRep+1):boxPlotBins) = byItr(' rep{iRep} '.absErrorcD.^2);']);
end

for i=1:nRep
    h = boxplot(acc{i},'PlotStyle','compact','Color',colors(i,:),'Labels',repmat({' '},[1,boxPlotBins]),'whisker',2); hold on;
end

% Formatting
xticks([round(nRep/2):nRep+1:boxPlotBins]); xticklabels(evalPt); 
set(gca,'YScale','log','YLim',[1e-13 1]); grid on;
xlabel('Precise Evaluations'); ylabel('MSE');
for i = 1:nRep; plot(NaN,1,'color', colors(i,:), 'LineWidth', 4); hold on;end;
legend(capitalize(rep),'Location','SouthWest','FontSize',16);
title('Model Performance Per PE','FontSize',20); hold off;

%% at 1000 PE (Maps)
fh(2) = figure(2); clf; fh(2).Name = 'Model Accuracy at 1000 PE'; hold on;
fh(2).Position = [1923,151,1221,943];
dragRange = [-5 -3.5]; absErrorRange = [-6 0]; perErrorRange = [0 15];

counter = 1;
for iRep = 1:nRep
    subplot(nRep,3,counter); 
        eval(['viewMap(' rep{iRep} '.predcD(:,:,end),d);']); 
        caxis(dragRange);
        title([capitalize(rep{iRep}) ' Drag Prediction']);
        counter = counter+1;
    subplot(nRep,3,counter);
        eval(['viewMap( log(abs(' rep{iRep} '.absErrorcD(:,:,end))),d);']); 
        caxis(absErrorRange);
        title([capitalize(rep{iRep}) ' Absolute Drag Error (log scale)'])
        counter = counter+1;
    subplot(nRep,3,counter);
        eval(['viewMap(' rep{iRep} '.percErrorcD(:,:,end),d);']); 
        caxis(perErrorRange);
        title([capitalize(rep{iRep}) ' Percentage Drag Error'])
        counter = counter+1;
end

%% Performance
%% at each PE
stdDevScale = 4;

fh(3) = figure(3); clf; fh(3).Name = 'Map Performance per PE'; hold on;
fh(3).Position = [2751,151,850,902];

% Legend
for i = 1:nRep; plot(NaN,1,'color', colors(i,:), 'LineWidth', 4); hold on;end;
legend(capitalize(rep),'Location','SouthWest','FontSize',16);

% Data
hold on;
for iRep=1:nRep
    eval(['[l,p] = boundedline(evalPt,' rep{iRep} '.trueFitOptMedian,' rep{iRep} '.trueFitOptStd./stdDevScale);']);
    l.Color = colors(iRep,:); l.LineWidth = 4; p.FaceColor = colors(iRep,:); p.FaceAlpha = 0.25;   
end
grid on; set(gca, 'XLim',[100 1000])
title('Median Map Performance Per PE','FontSize',20); hold off;
xlabel('Precise Evaluations')
ylabel('Percentage of Optima')

%% at 1000 PE (Maps)
fh(4) = figure(4); clf; fh(4).Name = 'Map Performance at 1000 PE'; hold on;
fh(4).Position = [1923,151,767,943];

dragRange = [0 5];
counter = 1;
for iRep = 1:nRep
    subplot(nRep,2,counter); 
        eval(['viewMap(-' rep{iRep} '.predFitness(:,:,end),d);']); 
        caxis(dragRange);
        title([capitalize(rep{iRep}) ' Fitness Prediction']);
        counter = counter+1;
    subplot(nRep,2,counter);
        eval(['viewMap(-' rep{iRep} '.trueFitness(:,:,end),d);']); 
        caxis(dragRange);
        title([capitalize(rep{iRep}) ' True Fitness'])
        counter = counter+1;
end
colormap(parula(15));

%% Save all figures
if print2pdf 
    figure(fh(1)); save2pdf('modelAccuracy'); 
    figure(fh(2)); save2pdf('modelMaps');
    figure(fh(3)); save2pdf('performance');
    figure(fh(4)); save2pdf('perfMaps');
end