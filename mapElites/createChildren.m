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
    % Remove empty bins from parent pool
    parentPool = reshape(map.genes,[numel(map.fitness), d.dof]);
    parentPool(isnan(parentPool(:,1)),:) = []; 
    
    % Choose parents and create mutation
    parents = parentPool(randi([1 size(parentPool,1)], [p.nChildren 1]), :);
    mutation = randn(p.nChildren,d.dof) .* p.mutSigma;
    
    % Apply mutation
    children = parents + mutation;
    children(children>1) = 1; children(children<0) = 0;
%------------- END OF CODE --------------