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
% Jun 2017; Last revision: 30-Jul-2017

%------------- BEGIN CODE --------------

d.initialize = 'af_InitialSamples';

% Load Base Airfoil
load('raeParsec.mat'); load('raeRange.mat');  
d.base = loadBaseAirfoil(raeParsec, raeRange);

% Set Expression Methods
d.dof = 10;
d.express = setExpression(d.base.parsec, d.base.range, d.dof);


d.preciseEvalFunction = 'dragFit';
d.preciseEvaluate = 'af_PreciseEvaluate';

d.gpParams(1)= paramsGP(d.dof); % Drag
d.gpParams(2)= paramsGP(d.dof); % Lift
d.createAcqFunction= 'af_CreateAcqFunc';
d.varCoef = 1; % variance weight
d.muCoef  = 1; % mean weight 

d.categorize = 'af_Categorize';
d.featureIndx       = [2 3]; 
d.featureRes = [25 25];
d.nDims             = length(d.featureRes);
d.featureMin = 0;
d.featureMax = 1;

d.extraMapValues = {'cD','cL'};

d.validate = 'af_ValidateChildren';

d.saveData = 'af_RecordData';


%------------- END OF CODE --------------




















