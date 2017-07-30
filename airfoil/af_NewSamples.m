function [observation, value, sobPoint] = af_NewSamples(nextObservations, d, p, a)
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
sobPoint = a.sobPoint;
sobSet   = a.sobSet;
acqMap   = a.acqMap;
r = a.r;
c = a.c;


% Evaluate initially chosen solutions
parfor iFoil = 1:length(nextObservations)
    [~,newcD(iFoil,1), newcL(iFoil,1),~] = feval(d.preciseEvalFunction,...
        nextObservations(iFoil,:), d.express,d.base.area,d.base.lift); %#ok<PFBNS>
end

% If nan, take the next in the sobol set
newcD(1) = nan;
while any(isnan(newcD))
    nNans = sum(isnan(newcD));
    nanGenes = nan(nNans,p.dof);
    disp([int2str(nNans) ' NaN values']);
    
    % Identify
    nanIndx = 1:p.nAdditionalSamples;
    nanIndx = nanIndx(isnan(newcD));
    
    % Replace
    newSampleRange = sobPoint:(sobPoint+nNans-1);
    mapLinIndx = sobol2indx(sobSet,newSampleRange,p);
    sobPoint = sobPoint + length(newSampleRange);
    
    [chosenI,chosenJ] = ind2sub([r c], mapLinIndx);
    for iGenes=1:nNans
        nanGenes(iGenes,:) = ...
            acqMap.genes(chosenI(iGenes),chosenJ(iGenes),:);
    end
    
    % Reevaluate
    newCdp = nan(nNans,1);
    newClp = nan(nNans,1);
    parfor i = 1:nNans
        [~,newCdp(i), newClp(i),~] = feval(p.preciseEvalFunction,...
            nanGenes(i,:), d.express, d.base.area, d.base.lift); %#ok<PFBNS>
    end
    
    % Use parfor data
    newcD(nanIndx)      = newCdp; %#ok<AGROW>
    newcL(nanIndx)      = newClp; %#ok<AGROW>
    nextObservations(nanIndx,:) = nanGenes;
end

observation = nextObservations;
value(:,1) = newcD;
value(:,2) = newcL;

%------------- END OF CODE --------------