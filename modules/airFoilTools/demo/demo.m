%% Demo script for airfoil tools

%% Encoding
% A pair of real valued matrices is expected for all airfoils
% 
% * Value: [1XN] vector of values between 0 and 1
% * Range: [2XN] matrix of min/max ranges the values are scaled between
% 

%% Parsec-12 ranges and expression method
figure(1);clf;
load('sampleRange.mat');
nParam = 12; nPoints = 100;

expressMethod = @(p,xVals) expressParsec(p,range,xVals);
expressMethodDefault = @(p) expressMethod(p,nPoints);

% Create random shape and plot it
value = rand(1,nParam);
[xyCoords,ul,ll,parsecParams] = expressMethodDefault(value);

% If it isn't valid create another
while ~getValidity(ul,ll,parsecParams)
    value = rand(1,nParam);
    [xyCoords,ul,ll,parsecParams] = expressMethodDefault(value);
end

fPlot(xyCoords); axis equal; grid on; title('Randomly Generated Foil');

%% Create PARSEC approximation of sample foils
% Shape matching via CMA-ES
testFoils = {'RAE2822', 'NACA2412', 'NACA0012'}; nTestFoils = length(testFoils);

%par
for iFoil = 1:nTestFoils
    target{iFoil} = csvread([testFoils{iFoil} '.csv'])';
    [matchedVal(iFoil,:),coords{iFoil},error(iFoil)] = shapeMatch(expressMethod, nParam, target{iFoil});
end
    
% Plot target and matched foil
figure(2); clf;
for iFoil = 1:nTestFoils
    subplot(nTestFoils,1,iFoil); hold on;
    th = fPlot(target{iFoil},'k'); mh = fPlot(coords{iFoil},'g-.'); 
    axis equal; grid on; set(th,'LineWidth',1); set(mh,'LineWidth',1);
    title([testFoils{iFoil} char(10) 'Error: ' num2str(error(iFoil) )]);
    legend('Target','PARSEC-12','Location','NorthEast');hold off;
end

%% Evaluate an airfoil in XFoil
for iFoil = 1:nTestFoils
    [targetCd(iFoil), targetCl(iFoil)]= xfoilEvaluate(target{iFoil});
    [ matchCd(iFoil),  matchCl(iFoil)]= xfoilEvaluate(coords{iFoil});
end
DragDifference = targetCd - matchCd
LiftDifference = targetCl - matchCl


%% Optimize an airfoil using CMA-ES
raeParsec = matchedVal(1,:);
base.drag  = targetCd(1);
base.lift = targetCl(1);
base.area = polyarea(target{1}(1,:),target{1}(2,:));

% Minimize drag without changing area or reducing lift
[bestParams,fitHistory] = minimizeDrag(expressMethodDefault,raeParsec, base, 1000);


%% Plot Base and Optimizated Foil
figure(3);clf;
subplot(3,1,1); 
fPlot(expressMethodDefault(raeParsec),'k--');hold on;
fPlot(expressMethodDefault(bestParams),'b'); 
legend('Base Foil','Optimized Foil');

subplot(3,1,2)
plot(fitHistory(:,1), fitHistory(:,2)); hold on;
plot(fitHistory(:,1), repmat(log(baseDrag),1,numel(fitHistory(:,1))),'k--')
xlabel('Iterations'); ylabel('Fitness'); grid on;
legend('Optimized Drag','Base Drag','Location','NorthEast');

subplot(3,1,3);
pPlot(raeParsec, 'k-o') ; hold on
pPlot(bestParams,'b-o')
title('Parameter Differences')
legend('Base Foil','Optimized Foil','Location','NorthEast');

