function [value] = velo_PreciseEvaluate(nextObservations, d)
%velo_PreciseEvaluate - Send velomobile shapes in parallel to OpenFOAM func
%
% Syntax:  [observation, value] = af_InitialSamples(p)
%
% Inputs:
%    observations - Samples to evaluate
%    d            - domain description struct
%                   .openFoamFolder 
%
% Outputs:
%    value(:,1)  - [nObservations X 1] drag force
%
% Other m-files required: velo_openFoamResult

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 02-Aug-2017

%------------- BEGIN CODE --------------
folderBaseName = d.openFoamFolder;
parfor iGenome=1:size(nextObservations,1)
    openFoamFolder = [folderBaseName 'case' int2str(iGenome) '/'];
    value(iGenome) = velo_OpenFoamResult(...
                nextObservations(iGenome,:)',...
                [openFoamFolder 'constant/triSurface/parsecWing.stl'],...
                openFoamFolder);
end

%------------- END OF CODE --------------