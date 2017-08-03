function p = defaultParamSet()
% defaultParamSet - loads default parameters for SAIL algorithm
%
% Syntax:  p = defaultParamSet
%
% Outputs:
%   p      - struct - parameter struct
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 02-Aug-2017

%------------- BEGIN CODE --------------

% MAP-Elites Parameters
p.nChildren         = 250; 
p.mutSigma          = 0.1; 
p.nGens             = 500;

% Infill Parameters
p.nInitialSamples   = 50;
p.nAdditionalSamples= 10;
p.nTotalSamples     = 1000;
p.trainingMod       = 3;

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

