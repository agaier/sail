function valid = velo_param_Validate(genome,d)  
%velo_Param_ValidateChildren - Ensures all velomobile shapes are valid
% This is primarily determined by ensuring the PARSEC curves are produced
% as they are described. See velo_param_express for exact details.
%
% Syntax:  validInds = velo_param_ValidateChildren(genome,d);
%
%
% Inputs:
%   genome - [N X 1] - new solutions
%   d   - Domain description struct
%
% Outputs:
%   validInds - [nChildren X 1] Bitsring - 1 == valid, 0 == invalid
%
% See also: velo_param_Express, initialSampling, 

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Oct 2017; Last revision: 17-Oct-2017

%------------- BEGIN CODE --------------
repParams = d.repParams; % Avoid overhead of splitting whole domain struct
parfor i=1:size(genome,1)
    [~,validInds(i)] = velo_param_Express(genome(i,:), repParams,'validateOnly',true);
end

% Make consistent with unconverged OpenFOAM output (nan == false)
valid = nan(size(validInds))';
valid(validInds==1) = true;
%------------- END OF CODE --------------