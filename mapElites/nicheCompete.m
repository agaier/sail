function [replaced, replacement] = nicheCompete(newInds,fitness,map,p)
%nicheCompete - results of competition with map's existing elites
%
% Syntax:  [replaced, replacement] = nicheCompete(newInds,fitness,map,p)
%
% Inputs:
%   newInds - [NXM]    - new population to compete for niches
%   fitness - [NX1]    - fitness values fo new population
%   map     - struct   - population archive
%   p       -          - parameter struct
%
% Outputs:
%   replaced - [1XN] - linear index of map cells to recieve replacements
%   replaced - [1XN] - index of newInds to replace current elites in niche
%
% Example:
%
% Other m-files required: getBestPerCell.m
% Subfunctions: none
% MAT-files required: none
%
% See also: createMap, getBestPerCell, updateMap

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 07-Jun-2016

%------------- BEGIN CODE --------------
[bestIndex, bestBin] = getBestPerCell(newInds,fitness,p);
mapLinIndx = sub2ind(p.featureRes,bestBin(:,1),bestBin(:,2));

% Compare to already existing samples
improvement = ~(fitness (bestIndex) >= map.fitness(mapLinIndx)); % comparisons to NaN are always false
improvement(isnan(fitness(bestIndex))) = false;
replacement = bestIndex (improvement);
replaced    = mapLinIndx(improvement);

%------------- END OF CODE --------------