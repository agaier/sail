function d = af_Domain
%af_Domain - Airfoil Domain Parameters
%Returns struct with default for all settings of airfoil domain including
%hyperparameters, and strings indicating functions for representation and 
%evaluation.
%
% Syntax:  d = af_Domain;
%
% Example: 
%    output = sail(sail,af_Domain);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required:
%   /domains/airfoil/airfoilTools/demo/raeParsec_aft.mat
%   /domains/airfoil/airfoilTools/demo/raeRange_aft.mat
%
% See also: sail, runSail

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

% Alternative initialization
d.loadInitialSamples = false;
d.initialSampleSource= '';

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




















