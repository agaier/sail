function d = af_DomainParameters
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
d.preciseEvaluate   = 'af_PreciseEvaluate';
d.categorize        = 'af_Categorize';
d.createAcqFunction = 'af_CreateAcqFunc';
d.validate          = 'af_ValidateChildren';
d.saveData          = 'af_RecordData';

% Genotype to Phenotype Expression
d.dof = 10;
load('raeParsec_aft.mat'); load('raeRange_aft.mat');  
d.base = loadBaseAirfoil(raeParsec, raeRange);
d.express = setExpression(d.base.parsec, d.base.range, d.dof);

% Feature Space
d.featureRes = [25 25];
d.nDims      = length(d.featureRes);
d.featureMin = [0 0];
d.featureMax = [1 1];
d.featureLabels = {'Z_{up}','X_{up}'}; % {X label, Y label}

% GP Models
d.gpParams(1)= paramsGP(d.dof); % Drag
d.gpParams(2)= paramsGP(d.dof); % Lift

% Acquisition function
d.varCoef = 1; % variance weight
d.muCoef  = 1; % mean weight 

% Domain Specific
d.extraMapValues = {'cD','cL'};






%------------- END OF CODE --------------




















