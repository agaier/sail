function [bestIndex, bestBin] = getBestPerCell(samples,fitness,d, edges)
%getBestPerCell - Returns index of best individual in each cell
%
% Syntax:  [bestIndex, bestBin] = getBestPerCell(samples,fitness,p)
%
% Inputs:
%   samples - [NXM] - sample genome
%   fitness - [NX1] - fitness values
%   d       - Domain definition struct
%   edges   - {[1 X FeatureRes(1)+1], [1 X FeatureRes(2)+1]}
%           - bin edges of feature space
%
% Outputs:
%   bestIndex - [1XN] - index of best individuals per cell
%
%
% Example:
%
% Other m-files required: d.categorize
%
% See also: createMap

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 27-Jan-2016

%------------- BEGIN CODE --------------

% Get Features of all samples
feature = feval(d.categorize, samples, d);
for iDim = 1:d.nDims
    bin(:,iDim) = discretize(feature(:,iDim),edges{iDim});
end
[sortedByFeatureAndFitness, indxSortOne] = sortrows([bin fitness]);
[~, indxSortTwo] = unique(sortedByFeatureAndFitness(:,[1 2]),'rows');

bestIndex = indxSortOne(indxSortTwo);
bestBin = bin(bestIndex,:);

%------------- END OF CODE --------------