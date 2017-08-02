%RunSail -- Example usage script of sail function
% Running sail without arguments will return a hyperparameter struct of
% default values. These defaults can be changed in
% /src/config/defaultParamSet.m
% 
% Running sail with a parameter struct as input will run the algorithm
%
% Example: 
%    p = sail;                                  % Load default parameters
%    p.nTotalSamples = 60;                      % Edit default parameters
%    output = sail(p);                          % Run SAIL algorithm
%    viewMap(output.predMap.fitness, output.p)  % View results    
%
% Other m-files required: defaultParamSet, sail
% Other submodules required: map-elites, gpml-wrapper airFoilTools
% MAT-files required: src/data/airfoil/raeParsec.mat, /raeParsec.mat
%
% See also: mapElites, sail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Nov 2016; Last revision: 27-Jan-2017

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
profile on;
output = sail(d,p);
profile viewer;
disp(['Runtime: ' seconds2human(toc)]);

%% Create Prediction Map from produced surrogate
predMap = createPredictionMap(output.model,p,d);


















