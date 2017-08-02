function children = createChildren(map, p, d)
%createChildren - produce new children through mutation of map elite
%
% Syntax:  children = createChildren(map,p)
%
% Inputs:
%   map - Population struct
%    .fitness
%    .genes
%    .<additional info> (e.g., drag, lift, etc)
%   p   - SAIL hyperparameter struct
%    .nChildren - number of children created
%    .mutSigma  - sigma of gaussian mutation applied to children
%   d   - Domain description struct
%    .dof       - Degrees of freedom (genome length)
%
% Outputs:
%   children - [nChildren X genomeLength] - new solutions
%
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 01-Aug-2017

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