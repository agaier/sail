function [value] = af_PreciseEvaluate(nextObservations, d)
%af_InitialSamples - Produces initial airfoil samples
% Initial samples are produced using a Sobol sequence to evenly sample the
% parameter space. If initial samples are invalid (invalid geometry, or did
% not converge in simulator), the next sample in the Sobol sequence is
% chosen. Lather, rinse, repeat until all initial samples are clean.
%
% Syntax:  [observation, value] = af_InitialSamples(p)
%
% Inputs:
%    d - domain description struct
%       .preciseEvalFunction
%       .express
%       .base.area
%       .base.lift
%    nInitialSamples - initial samples to produce
%
% Outputs:
%    observation - [nInitialSamples X nParameters]
%    value(:,1)  - [nInitialSamples X 1] cD (coefficient of drag)
%    value(:,2)  - [nInitialSamples X 1] cL (coefficient of lift)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 30-Jul-2017

%------------- BEGIN CODE --------------

% Evaluate initially chosen solutions
parfor iFoil = 1:size(nextObservations,1)
    [~,newcD(iFoil,1), newcL(iFoil,1),~] = dragFit(...
        nextObservations(iFoil,:), d.express,d.base.area,d.base.lift); %#ok<PFBNS>
end

value(:,1) = newcD;
value(:,2) = newcL;

%------------- END OF CODE --------------