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

% Load Base Airfoil
load('raeParsec.mat'); load('raeRange.mat');  
p.base = loadBaseAirfoil(raeParsec, raeRange);

% Set Expression Methods
p.dof = 10;
p.express = setExpression(p.base.parsec, p.base.range,p.dof);

% Set Fitness Methods
p.varCoef = 1;
p.muCoef  = 1; % only used for experiments which only use variance
p.acquisitionFunction = 'computeFitness';
p.preciseEvalFunction = 'dragFit';

% MAP-Elites Parameters
p.featureIndx       = [2 3]; 
p.featureRes        = [25 25]; 
p.nDims             = length(p.featureRes);
p.nChildren         = 250; 
p.mutSigma          = 0.1; 
p.nGens             = 500;
p.genomeLength      = p.dof;

% Model Parameters
p.nInitialSamples   = 50;
p.nAdditionalSamples= 10;
p.nTotalSamples     = 1000;

% Display Parameters
p.display.figs      = false;
p.display.gifs      = false;
p.display.illu      = false;
p.display.illuMod   = p.nGens;

% Data Gathering Parameters
p.data.outSave      = true;
p.data.outMod       = 10;
p.data.mapEval      = false;
p.data.mapEvalMod   = p.nTotalSamples;
p.data.outPath      = '';

%------------- END OF CODE --------------

