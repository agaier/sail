%runSail - Example usage script of sail function
% Running sail without arguments will return a hyperparameter struct of
% default values. These defaults can be changed in
% /sail/defaultParamSet.m
% 
% Running sail with a parameter struct as input will run the algorithm
%
%
% Other m-files required: defaultParamSet, sail, mapElites
% Other submodules required: gpml-wrapper
% 
%
% See also: mapElites, sail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Nov 2016; Last revision: 01-Aag-2017

%------------- BEGIN CODE --------------

p = sail;

% Adjust hyperparameters 
 p.nInitialSamples   = 50;   
 p.nAdditionalSamples= 10;    
 p.nTotalSamples     = 150;    
 p.nChildren         = 100;    
 p.nGens             = 500;
 
 p.display.illu      = false;
 p.display.illuMod   = 100;
 p.display.figs      = true;      
 
 p.data.outSave      = false;
 p.data.mapEval      = true;
 p.data.mapEvalMod   = 50;              
 
 
% % % % % % % % % % % % % % %
tic;
%d = velo_Domain;
d = af_Domain;
output = sail(p,af_Domain);
disp(['Runtime: ' seconds2human(toc)]);

%% Create Prediction Map from produced surrogate
% Adjust hyperparameters
p.nChildren = 250;
p.nGens = 500;

p.display.illu = true;
p.display.illuMod = 100;
d.featureRes = [50 50];

predMap = createPredictionMap(output.model,p,d);
viewMap(predMap.fitness, p, d) % View Prediction Map


















