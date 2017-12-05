function children = createChildren(map, nChildren, p, d)
%createChildren - produce new children through mutation of map elite
%
% Syntax:  children = createChildren(map,nChildren,p,d)
%
% Inputs:
%   map         - Population struct
%    .fitness
%    .genes
%   nChildren - number of children to create
%   p           - SAIL hyperparameter struct
%    .mutSigma      - sigma of gaussian mutation applied to children
%   d           - Domain description struct
%    .dof           - Degrees of freedom (genome length)
%
% Outputs:
%   children - [nChildren X genomeLength] - new solutions
%
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 17-Oct-2017

%------------- BEGIN CODE --------------  
    % Remove empty bins from parent pool
    parentPool = reshape(map.genes,[numel(map.fitness), d.dof]);
    parentPool(isnan(parentPool(:,1)),:) = []; 
    
    % Choose parents and create mutation
    parents = parentPool(randi([1 size(parentPool,1)], [nChildren 1]), :);
    mutation = randn(nChildren,d.dof) .* p.mutSigma;
    
    % Apply mutation
    children = parents + mutation;
    children(children>1) = 1; children(children<0) = 0;
%------------- END OF CODE --------------