function [sample, value] = initialSampling(d,nInitialSamples)
%af_InitialSamples - Produces initial samples
% Initial samples are produced using a Sobol sequence to evenly sample the
% parameter space. If initial samples are invalid (invalid geometry, or did
% not converge in simulator), the next sample in the Sobol sequence is
% chosen. Lather, rinse, repeat until all initial samples are clean.
%
% Syntax:  [observation, value] = initialSampling(domainParams, nSamples)
%
% Inputs:
%    d - domain description struct
%       .validate           (to check validity of samples)
%       .preciseEvaluate    (to get true values of samples)
%    nInitialSamples - initial samples to produce
%
% Outputs:
%    observation - [nInitialSamples X nParameters]
%    value(:,N)  - values returned from precise evaluation, e.g.:
%       value(:,1)  - [nInitialSamples X 1] cD (coefficient of drag)
%       value(:,2)  - [nInitialSamples X 1] cL (coefficient of lift)
%
% Other m-files required: sobolset (target of d.preciseEvaluate)
% Subfunctions: none
% MAT-files required: none
%
% See also: sail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Aug 2017; Last revision: 04-Dec-2017

%------------- BEGIN CODE --------------

%% Produce initial solutions
sobSequence  = scramble(sobolset(d.dof,'Skip',1e3),'MatousekAffineOwen');

% Get collection of valid solutions
nMissing = nInitialSamples; inds = []; sobPoint = 1;
while nMissing > 0
    indPool = sobSequence(sobPoint:(sobPoint+nMissing*2),:);
    sobPoint = 1 + sobPoint + nMissing*2;
    validFunction = @(genomes) feval(d.validate, genomes, d);
    [validInds,~,nMissing] = getValidInds(indPool, validFunction, nMissing);
    inds = [inds; validInds];     %#ok<AGROW>
end

% Evaluate enough of these valid solutions to get your initial sample set
testFunction = @(x) feval(d.preciseEvaluate, x , d);
[sample, value, nMissing] = getValidInds(inds, testFunction, nInitialSamples);

% Recurse to make sure you get all the samples you need
if nMissing > 0
    [sampleRemainder, valueRemainder] = initialSampling(d,nMissing); 
    sample = [sample; sampleRemainder]; value  = [ value; valueRemainder]; 
else
    % Warnings of final sample set
    if size(sample,1) ~= size(unique(sample,'rows'),1)
        warning('Duplicate samples in observation set'); 
    end
    if size(sample,1) ~= nInitialSamples
        warning('Observation set smaller than specified')
    end
end


%------------- END OF CODE --------------




































