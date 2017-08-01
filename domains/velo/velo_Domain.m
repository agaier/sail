function d = velo_Domain
%af_DomainParameters - Airfoil Domain Parameters
%Returns struct with default for all settings of airfoil domain including
%hyperparameters, and strings indicating functions for representation and 
%evaluation.
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------

% Scripts
d.preciseEvaluate   = 'velo_PreciseEvaluate';
d.categorize        = 'velo_Categorize'; %
d.createAcqFunction = 'velo_CreateAcqFunc'; %
d.validate          = 'velo_ValidateChildren'; %
d.saveData          = 'velo_RecordData'; %

% Alternative initialization
d.loadInitialSamples = true;
d.initialSampleSource= '#notallvelos.mat';

% Genotype to Phenotype Expression
d.dof = 16;
%d.express = @(genome, filename) expressVelo(x, 

% Feature Space
d.featureRes = [20 20];
d.nDims      = length(d.featureRes);
d.featureMin = [0.01 7];
d.featureMax = [0.04 23];
d.featureLabels = {'Curvature','Volume'}; % {X label, Y label}

% GP Models
d.gpParams(1)= paramsGP(d.dof); % Drag

% Acquisition function
d.varCoef = 1e2; % variance weight
d.muCoef  = 1; % mean weight 

% Domain Specific
d.extraMapValues = {};






%------------- END OF CODE --------------




















