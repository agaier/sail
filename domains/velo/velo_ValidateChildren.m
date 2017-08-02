function validInds = velo_ValidateChildren(children,d)  
%velo_ValidateChildren - Validates velomobile shapes
% Returns true if lines cross and highest top and bottom points are in the 
% correct positions.
%
% Syntax:  validInds = velo_ValidateChildren(newChildren,d);
%
%
% Inputs:
%   children - [N X genomeLength] - new solutions
%   d   - Domain description struct
%    .express       - genotype->phenotype conversion function
%
% Outputs:
%   children - [nChildren X genomeLength] - new solutions
%
% See also: mapElites

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------

parfor i=1:size(children,1)
    validInds(i) = expressVelo(children(i,:)','validateOnly',true);    
end

%------------- END OF CODE --------------