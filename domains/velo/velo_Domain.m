function d = velo_Domain
%velo_Domain - Velomobile Domain Parameters +
%Returns struct with default for %all settings of velomobile domain 
%including hyperparameters, and strings indicating functions for 
%representation and evaluation.
%
% Syntax:  d = velo_Domain;
%
% Example: 
%    output = sail(sail,velo_Domain);
%
%
% See also: sail, runSail

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

% --- There should be a folder called 'case1, case2, ..., caseN in this
% folder, where N is the number of new samples added every iteration.
% --- Each folder has a shell script called 'caserunner.sh' which must be
% run, this will cause an instance of openFoam to run whenever a signal is
% given (to allow jobs to be run on nodes with minimal communication).
% TODO: make script that creates folders and/runs caserunners
d.openFoamFolder = '/home/adam/Code/sail/domains/velo/openFoam/';






%------------- END OF CODE --------------




















