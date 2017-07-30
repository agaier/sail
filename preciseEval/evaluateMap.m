function [mapTrue] = evaluateMap(predMap,p)
%evaluateMap - Precisely evaluates every sample in map
%
% Used for evaluation of surrogate performance in toy problems
%
% Syntax:  [mapTrue] = evaluateMap(predMap,p)
%
% Inputs:
%    predMap    - map struct (created using surrogate model)
%    p          - parameter struct
%
% Outputs:
%    mapTrue    - map struct with values determined by precise evaluation
%
% Example: 
%       mapTrue = evaluateMap(predMap,p); 
%
% Other m-files required: createMap
% Subfunctions: none
% MAT-files required: none
%
% See also: dragFit

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 03-Jun-2016

%------------- BEGIN CODE --------------
[mapTrue, p.edges] = createMap(p.featureRes, p.dof);
mapTrue.genes     = predMap.genes;

boolFilledCells = ~isnan(predMap.fitness(:));
indxFilledCells = find(boolFilledCells==1);
nFilledCells = length(indxFilledCells);

[r,c] = size(predMap.fitness);
[filledI,filledJ] = ind2sub([r c], indxFilledCells);
for i=1:nFilledCells
    genes(i,:) = predMap.genes(filledI(i),filledJ(i),:);
end

% Parfor nonsense (splitting variables, local variables...)
express = p.express; baseArea = p.base.area; baseLift = p.base.lift; 
parfor iCell = 1:size(genes,1)
    [fitness(iCell), dragMean(iCell), liftMean(iCell)] = feval(...
        p.preciseEvalFunction, genes(iCell,:), express, baseArea, baseLift);
end

% Assignment
mapTrue.fitness(indxFilledCells)  = fitness ;
mapTrue.dragMean(indxFilledCells) = dragMean;
mapTrue.liftMean(indxFilledCells) = liftMean;



%------------- END OF CODE --------------