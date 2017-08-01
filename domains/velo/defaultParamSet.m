function p = defaultParamSet()
% defaultParamSet - loads default parameters for SAIL algorithm
%
% Syntax:  p = defaultParamSet
%
% Outputs:
%   p      - struct - parameter struct
%
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 27-Jan-2016

%------------- BEGIN CODE --------------


% Set Expression Methods
p.dof = 16;

%p.express = setExpression(p.base.parsec, p.base.range,p.dof);
p.express = 'expressVelo';
p.vectorExpress = false;

% Set Fitness Methods
p.varCoef = 1e2;
p.muCoef  = 1; % only used for experiments which only use variance
p.acquisitionFunction = 'veloCd';
p.preciseEvalFunction = 'preciseEval';
p.openFoamFolder = '/home/adam/Code/sail_aiaa2017/openFoam/';

% MAP-Elites Parameters
p.featureIndx       = [1 2]; 
p.featureLabels     = {'Volume', 'Curvature'};%{'Wheel Width','Knee Height'};
p.featureRes        = [20 20]; 
%p.featureMin        = [0.05; 0.08]; 
p.featureMin        = [0.01; 7]; 
%p.featureMax        = [0.35; 0.20]; 
p.featureMax        = [0.04; 23]; 
p.nDims             = length(p.featureRes);
p.nChildren         = 100; 
p.mutSigma          = 0.1; 
p.nGens             = 200;
p.genomeLength      = p.dof;

% Infill Parameters
p.nInitialSamples   = 250;
p.nAdditionalSamples= 10;
p.nTotalSamples     = 1000;
p.trainingMod       = 2;    % retrain model every N iterations

% Display Parameters
p.display.figs      = false;
p.display.gifs      = false;
p.display.illu      = false;
p.display.illuMod   = 100;

% Data Gathering Parameters
p.data.outSave      = true;
p.data.outMod       = 10;
p.data.mapEval      = false;
p.data.mapEvalMod   = p.nTotalSamples;
p.data.outPath      = '';

%------------- END OF CODE --------------

