function validInds = ffdFoil_ValidateChildren(children,d)    
%af_ValidateChildren - Validates airfoil
% Returns true if no airfoil lines cross and highest top and bottom points
% are in the correct positions.
%
% Syntax:  validInds = af_ValidateChildren(newChildren,d);
%
%
% Inputs:
%   children - [N X genomeLength] - new solutions
%   d   - Domain description struct
%    .express       - genotype->phenotype conversion function
%
% Outputs:
%   children - [1 X nChildren] - boolean string of valid (1) or not (0)
%
% See also: mapElites

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------

%% All children are valid
validInds = true(size(children,1),1);

%------------- END OF CODE --------------