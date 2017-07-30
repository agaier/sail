function [observation, value] = af_InitialSamples(d,nInitialSamples)
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

% Produce initial solutions
inputSobSet  = scramble(sobolset(10,'Skip',1e3),'MatousekAffineOwen');
inputSobCounter = nInitialSamples;
initialSamples = inputSobSet(1:inputSobCounter,:);
cD = nan(nInitialSamples,1); cL = cD;

% Evaluate initial solutions
parfor iFoil = 1:nInitialSamples
    [~,cD(iFoil,1), cL(iFoil,1),~] = feval(d.preciseEvalFunction,...
        initialSamples(iFoil,:), d.express,d.base.area,d.base.lift); %#ok<PFBNS>
end

% Identify, Reselect, Reevaluate invalid solutions
while any(isnan(cD))
    nNans = sum(isnan(cD));
    disp([int2str(sum(nNans)) ' NaN values']);
    
    % Identify
    nanIndx = 1:nInitialSamples;
    nanIndx = nanIndx(isnan(cD));
    
    % Reselect
    nanGenes = inputSobSet(1+inputSobCounter:inputSobCounter+nNans,:);
    inputSobCounter = inputSobCounter + nNans;
    
    % Reevaluate
    newCd = nan(nNans,1);newCl = nan(nNans,1);
    parfor i = 1:nNans
        [~,newCd(i), newCl(i),~] = feval(d.preciseEvalFunction,...
            nanGenes(i,:), d.express,d.base.area,d.base.lift); %#ok<PFBNS>
    end
    
    % Use parfor data
    cD(nanIndx) = newCd;
    cL(nanIndx) = newCl;
    initialSamples(nanIndx,:) = nanGenes;
end

observation = initialSamples;
value(:,1) = cD;
value(:,2) = cL;
%------------- END OF CODE --------------