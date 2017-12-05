function validInds = velo_ffd_Validate(children,~)  
%velo_FFD_ValidateChildren - Ensures all velomobile shapes are valid
% All shapes produced through deformations are considered valid -- this
% file is simply a placeholder.
%
% Syntax:  validInds = velo_FFD_ValidateChildren(newChildren,d);
%
%
% Inputs:
%   children - [N X 1] - new solutions
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
% Sep 2017; Last revision: 25-Sep-2017

%------------- BEGIN CODE --------------
%% All children are valid
validInds = true(1, size(children,1))';

%------------- END OF CODE --------------