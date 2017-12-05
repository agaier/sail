%RUNSAIL - Example usage script of sail function
% Calling sail without arguments will return a hyperparameter struct of
% default values. These defaults can be changed in
% /sail/defaultParamSet.m
% 
% Calling sail with a parameter and domain struct as input will run the
% algorithm.
%
% Other m-files required: /sail/defaultParamSet.m, <domainName>_Domain.m
% Other submodules required: gpml
% For domain requirements see domains/<domainName>/Content.m
% 
%
% See also: hpcSail, sail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Nov 2016; Last revision: 04-Dec-2017

%------------- BEGIN CODE --------------
% Clean up workspace and add relevant files to path
clear;
currentPath = mfilename('fullpath');
addpath(genpath(currentPath(1:end-length(mfilename))));

% Algorithm hyperparameters 
p = sail;  % load default hyperparameters

% Edit Hyperparameters
 p.nInitialSamples   = 100;
 p.nTotalSamples     = 200;        
 p.nChildren         = 2^5;
 p.nGens             = 2^6; 
 
 p.data.mapEval      = false;   % produce intermediate prediction maps?
 p.data.mapEvalMod   = 50;      % how often? (in samples)     
 
% Domain
%d = parsec_Domain;
d = ffdFoil_Domain;
%d = velo_Domain('encoding','ffd'); d.preciseEvaluate = 'velo_DummyPreciseEvaluate';
 
%% Run SAIL
runTime = tic;
output = sail(p,d);
disp(['Runtime: ' seconds2human(toc(runTime))]);

%% Create New Prediction Map from produced surrogate
% 
% % Adjust hyperparameters
%  p.nGens = 2*p.nGens;
%  
% [predMap, percImproved] = createPredictionMap(...
%                     output.model,...               % Model for evaluation
%                     output.model{1}.trainInput,... % Initial solutions
%                     p,d,'featureRes',[25 25]);     % Hyperparameters
%         
% save('sailTest.mat','output','p','d','predMap','rTest');

