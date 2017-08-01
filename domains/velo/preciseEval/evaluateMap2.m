function [predMap] = evaluateMap(predMap,p)
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
% Apr 2017; Last revision: 11-Apr-2017

%------------- BEGIN CODE --------------
nCores = p.nAdditionalSamples;
nBins  = p.featureRes(1)*p.featureRes(2);

startId = 1:nCores:nBins;
nBatch = length(startId);

for iBatch = 1:nBatch
    tmpDrag = nan(1,nCores);
    parfor iJob = 1:nCores
        iBin = startId(iBatch)+iJob-1+10;
        disp([int2str(iJob) ' - ' int2str(iBin)]);
        openFoamFolder = [p.openFoamFolder '/case' int2str(iJob) '/'];
        [i,j] = ind2sub(p.featureRes, iBin);
        tmpDrag(iJob) = ...
            feval(p.preciseEvalFunction, squeeze(predMap.genes(i,j,:)),...
            [openFoamFolder 'constant/triSurface/parsecWing.stl'],...
            openFoamFolder);
%       tmpDrag(iJob) = predMap.fitness(i,j);
    end
    predMap.dragMean(startId(iBatch):startId(iBatch)+nCores-1) = tmpDrag;
end





%------------- END OF CODE --------------