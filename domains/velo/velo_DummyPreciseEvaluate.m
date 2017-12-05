function [value] = velo_DummyPreciseEvaluate(nextObservations, d)
%velo_DummyPreciseEvaluate - Dummy PE for testing other parts of SAIL
%
% Syntax:  [observation, value] = af_InitialSamples(p)
%
% Inputs:
%    nextObservations - [NX1] of FV structs - Samples to evaluate
%    d                - domain description struct
%     .openFoamFolder 
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

% Divide individuals to be evaluated by number of cases
nObs    = size(nextObservations,1);
nCases  = d.nCases;
nRounds = ceil(nObs/d.nCases);
caseStart = d.caseStart;

value = nan(nObs,d.nVals);
for iRound=0:nRounds-1
    PEValue = nan(nCases,d.nVals);
    % Evaluate as many samples as you have cases in a batch
    %par
    for iCase = 1:nCases
        obsIndx = iRound*nCases+iCase;       
        if obsIndx <= nObs
            openFoamFolder = [folderBaseName 'case' int2str(iCase+caseStart-1) '/'];

            PEValue(iCase,:) = [obsIndx]; % For testing only
            if rand < 0.2; PEValue(iCase,:) = [nan]; end
        end
    end  
    
    % Assign results of batch 
    obsIndices = 1+iRound*nCases:nCases+iRound*nCases;
    filledIndices = obsIndices(obsIndices<=nObs);
    value(filledIndices,:) = PEValue(1:length(filledIndices),:);
end

%------------- END OF CODE --------------