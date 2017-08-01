function children = createChildren(map, p, d)
%createChildren - produce new children through mutation of map elite
%
% Syntax:  children = createChildren(map,p)
%
% Inputs:
%   map     -             - population struct
%    .fitness
%    .genes
%    .<additional info> (e.g., drag, lift, etc)
%   p       -             - parameter struct
%    .nChildren
%    .mutSigma
%
% Outputs:
%   bestIndex - [1XN] - index of best individuals per cell
%
%
% Example:
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also:

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 07-Jun-2016

%------------- BEGIN CODE --------------
    boolFilledCells = ~isnan(map.fitness(:));
    indxFilledCells = find(boolFilledCells==1);
    nFilledCells = length(indxFilledCells);
    
    [r,c] = size(map.fitness);
    [filledI,filledJ] = ind2sub([r c], indxFilledCells);
    for i=1:nFilledCells
        parentPool(i,:) = map.genes(filledI(i),filledJ(i),:);
    end
    
    % Choose parents and create mutation
    parents = parentPool(randi([1 nFilledCells], [p.nChildren 1]), :);
    mutation = randn(p.nChildren,d.dof) .* p.mutSigma;
    
    % Apply mutation
    children = parents + mutation;
    children(children>1) = 1; children(children<0) = 0;
%------------- END OF CODE --------------