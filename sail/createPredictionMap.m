function [predMap, percImproved, rTest] = createPredictionMap(gpModels,observation,p,d, varargin)
%createPredictionMap - Produce prediction map from surrogate model
%
% Syntax:  predictionMap = createPredictionMap(gpModels,observation,p,d)
%
% Inputs:
%    gpModels   - [cell]             GP model(s) produced by SAIL
%    observation- [N X GenomeLength] Known inputs
%    p          - [struct]           SAIL hyperparameters
%    d          - [struct]           Domain definition
%
% Outputs:
%    predMap - prediction map
%    .fitness     [FeatureRes(1) X FeatureRes(2)]
%    .genes       [FeatureRes(1) X FeatureRes(2) X GenomeLength]
%    .'otherVals' [FeatureRes(1) X FeatureRes(2)]
%    percImproved [1 X nGens]  - percentage of children which improved on elites
%
% Example:
%    p = sail; d = af_Domain;
%    output = sail(d,p);
%    predMap = createPredictionMap(output.model,output.model{1}.trainInput,p,d,'featureRes',[50 50]);
%    viewMap(predMap.fitness,d)
%
% Other m-files required: mapElites  nicheCompete updateMap d.createAcqFunction
%
% See also: sail, mapElites, runSail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 01-Sep-2017

%% TODO: if no observations given take them from the gpModels
%------------- INPUT PARSING -----------
parse = inputParser;
parse.addRequired('gpModels');
parse.addRequired('p');
parse.addRequired('d');
parse.addRequired('observation');
parse.addOptional('nChildren'   ,p.nChildren);
parse.addOptional('nGens'       ,p.nGens);
parse.addOptional('featureRes'  ,d.featureRes);

parse.parse(gpModels, observation, p, d, varargin{:});
p.nChildren  = parse.Results.nChildren;
p.nGens      = parse.Results.nGens;
d.featureRes = parse.Results.featureRes;

%------------- BEGIN CODE --------------
d.varCoef = 0; %no award for uncertainty

% Construct functions
acqFunction = feval(d.createAcqFunction,gpModels,d);

% Seed map with precisely evaluated solutions
[fitness,predValues] = acqFunction(observation);
predMap = createMap(d.featureRes, d.dof, d.extraMapValues);
[replaced, replacement] = nicheCompete(observation, fitness, predMap, d);
predMap = updateMap(replaced,replacement,predMap,fitness,observation,...
    predValues,d.extraMapValues);

% Illuminate based on surrogate models
[predMap, percImproved] = mapElites(acqFunction,predMap,p,d);


%------------- END OF CODE --------------