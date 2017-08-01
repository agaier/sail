function [nextObservation, newValue] = af_InitialSamples(d,nInitialSamples)
%af_InitialSamples - Produces initial airfoil samples
% Initial samples are produced using a Sobol sequence to evenly sample the
% parameter space. If initial samples are invalid (invalid geometry, or did
% not converge in simulator), the next sample in the Sobol sequence is
% chosen. Lather, rinse, repeat until all initial samples are clean.
%
% Syntax:  [observation, value] = af_InitialSamples(domainParams, nSamples)
%
% Inputs:
%    d - domain description struct
%       .preciseEvaluate
%       .dof
%       .featureRes
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
% See also: af_PreciseEvaluate

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Aug 2017; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------

% Produce initial solutions
sobSequence  = scramble(sobolset(d.dof,'Skip',1e3),'MatousekAffineOwen');
sobPoint = 1;

nextObservation = nan(nInitialSamples, d.dof);
newValue = nan(nInitialSamples, length(d.featureRes)); % new values will be stored here
noValue = any(isnan(newValue),2);

while any(any(noValue))
    nNans = sum(noValue);
    
    % Identify (grab indx of NANs)
    nanIndx = 1:nInitialSamples;  nanIndx = nanIndx(noValue);
    
    % Replace with next in Sobol Sequence
    nextGenes = sobSequence(sobPoint:(sobPoint+nNans)-1,:);
    
    % Evaluate
    measuredValue = feval(d.preciseEvaluate, nextGenes, d);
    
    % Assign found values
    newValue(nanIndx,:) = measuredValue;
    noValue = any(isnan(newValue),2);
    nextObservation(nanIndx,:) = nextGenes;
    sobPoint = sobPoint + nNans;   % Increment sobol sequence for next samples
end

%------------- END OF CODE --------------




































