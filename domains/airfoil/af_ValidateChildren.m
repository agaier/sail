function validInds = af_ValidateChildren(children,d)    
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
%   children - [nChildren X genomeLength] - new solutions
%
% See also: mapElites

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------
[~, ul, ll, parsecParams] = d.express(children);
for i=1:size(children,1)
    % TODO: Vectorize getValidity
    validInds(i) = getValidity(ul(:,:,i),ll(:,:,i),parsecParams(i,:)); %#ok<AGROW>
end

%------------- END OF CODE --------------