function output = vanillaMapElites(p)
%vanillaMapElites - Runs the standard MAP-Elites algorithm
%
% Syntax:  [output] = vanillaMapElites(p)            
%
% Inputs:
%    p - struct for hyperparameters, visualization, and data gathering
%    * - vanillaMapElites with no arguments to return default parameter struct
%
% Outputs:
%    output - output struct with fields:
%       .fitHistory : Fitness in each bin [{1XM} Cell array of fitness maps]
%       .p          : parameter struct
%       .runTime    : runtime in seconds
%       .map        : Final map
%           .fitness
%           .dragMean (named for consistency with SAIL)
%           .liftMean (named for consistency with SAIL)
%           .genes
%
% Example: 
%   p = vanillaMapElites;                      % Load default parameters
%   p.nInitialSamples   = 20;                  % Edit default parameters
%   p.nTotalSamples     = 1000;                
%   p.nChildren         = 4;     
%   p.featureRes        = [5 5];               
%   output = vanillaMapElites(p);              % Run MAP-Elites
%   viewMap(output.map.fitness, output.p)      % View results    
%
% Other m-files required: defaultParamSet
% Other submodules required: map-elites, gpml-wrapper airFoilTools
% MAT-files required: none
%
% See also: mapElites, runSail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Nov 2016; Last revision: 27-Jan-2017

%------------- BEGIN CODE --------------
    
%% Set Parameters
if nargin==0; output = defaultParamSet; return; end;

rng('default')
tstart = tic;
%% 0 - Produce Initial Samples
% Produce Initial PE samples
inputSobSet  = scramble(sobolset(10,'Skip',1e3),'MatousekAffineOwen');
inputSobCounter = p.nInitialSamples;
inputSamples = inputSobSet(1:inputSobCounter,:);
cD = nan(p.nInitialSamples,1); cL = cD;
parfor iFoil = 1:p.nInitialSamples
    [fitness(iFoil,1),cD(iFoil,1), cL(iFoil,1),~] = feval(p.preciseEvalFunction,...
        inputSamples(iFoil,:), p.express,p.base.area,p.base.lift); %#ok<PFBNS>
end

% Identify, Reselect, Reevaluate NaNs
while any(isnan(cD))
    nNans = sum(isnan(cD));
    display([int2str(sum(nNans)) ' NaN values']);
    
    % Identify
    nanIndx = 1:p.nInitialSamples;
    nanIndx = nanIndx(isnan(cD));
    
    % Reselect
    nanGenes = inputSobSet(1+inputSobCounter:inputSobCounter+nNans,:);
    inputSobCounter = inputSobCounter + nNans;
    
    % Reevaluate
    newCd = nan(nNans,1);newCl = nan(nNans,1);newFit = nan(nNans,1); % rows not cols
    
    if nNans==1
        [newFit,newCd, newCl,~] = feval(p.preciseEvalFunction,...
            nanGenes, p.express,p.base.area,p.base.lift);
    else   
        parfor i = 1:nNans
            [newFit(i),newCd(i), newCl(i),~] = feval(p.preciseEvalFunction,...
                nanGenes(i,:), p.express,p.base.area,p.base.lift); %#ok<PFBNS>
        end
    end
    
    % Use parfor data
    fitness(nanIndx) = newFit;
    cD(nanIndx) = newCd;
    cL(nanIndx) = newCl;
    inputSamples(nanIndx,:) = nanGenes;
end

%%
display('Initial Samples Found, beginning MAP-Elites');
[map, p.edges] = createMap(p.featureRes, p.dof);

% Place Samples in Map
[replaced, replacement] = nicheCompete(inputSamples, fitness, map, p);
map = updateMap(replaced,replacement,map,fitness,cD,cL,inputSamples);

h = []; [h(1), h(2)] = viewMap(map.fitness,p); title('Fitness')
fitHistory{p.nInitialSamples} = map.fitness(:);

%% MAP-Elites Loop
for iInd=p.nInitialSamples:p.nChildren:p.nTotalSamples
    % Create Children
    children = [];
    while size(children,1) < p.nChildren
        newChildren = createChildren(map,p);
        validInds = validateChildren(newChildren,p);
        children = [children ;newChildren(validInds,:)] ; %#ok<AGROW>
    end
    children = children(1:p.nChildren,:);
    parfor iChild = 1:p.nChildren
        [newfitness(iChild,1),drag(iChild ,1), lift(iChild,1),~] = feval(p.preciseEvalFunction,...
            children(iChild,:), p.express,p.base.area,p.base.lift); %#ok<PFBNS>
    end
        
    % Add Children to Map   
    [replaced, replacement] = nicheCompete(children,newfitness,map,p);
    oldmap = map;
    map = updateMap(replaced,replacement,map,newfitness,drag,lift,children);  

    % Record Data
    fitHistory{iInd} = map.fitness(:);
    display(['Evaluations: ' int2str(iInd)])
    
    set(h(2),'CData',flip(map.fitness),...
        'AlphaData',~isnan(flip(map.fitness)))
    title('Fitness')
    colormap(h(1),parula(16)); caxis([-5.3 0]);
    drawnow;
end

% Output results
runTime = toc(tstart);
output.map = map;
output.p = p;
output.fitHistory = fitHistory;
output.runTime = runTime;
save([p.data.outPath 'mapResults.mat'], 'fitHistory','map','p','runTime')    

