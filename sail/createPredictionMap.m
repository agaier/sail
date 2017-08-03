function predMap = createPredictionMap(gpModels,p,d, varargin)
%createPredictionMap - Produce prediction map from surrogate model
%
% Syntax:  predictionMap = createPredictionMap(gpModels,p,d)
%
% Inputs:
%    gpModels   - GP model produced by SAIL
%    p          - SAIL hyperparameter struct
%    d          - Domain definition struct
%
% Outputs:
%    predMap - prediction map
%    .fitness     [Rows X Columns]
%    .genes       [Rows X Columns X GenomeLength]
%    .'otherVals' [Rows X Columns]
%
% Example: 
%    p = sail;
%    d = af_Domain;
%    output = sail(d,p);
%    predMap = createPredictionMap(output.model,p,d,'featureRes',[50 50]);
%    viewMap(predMap.fitness,d, predMap.edges)
%
% Other m-files required: mapElites  nicheCompete updateMap d.createAcqFunction
%
% See also: sail, mapElites, runSail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 03-Aug-2017

%------------- INPUT PARSING -----------
parse = inputParser;
parse.addRequired('gpModels');
parse.addRequired('p');
parse.addRequired('d');
parse.addOptional('nChildren',p.nChildren);
parse.addOptional('nGens',p.nGens);
parse.addOptional('featureRes',d.featureRes);

parse.parse(gpModels,p,d,varargin{:});
p.nChildren  = parse.Results.nChildren;
p.nGens      = parse.Results.nGens;
d.featureRes = parse.Results.featureRes;

%------------- BEGIN CODE --------------
d.varCoef = 0; %no award for uncertainty

% Construct functions
acqFunction = feval(d.createAcqFunction,gpModels,d);

% Seed map with precisely evaluated solutions
observation = gpModels{1}.trainInput;
[fitness,predValues] = acqFunction(observation);
predMap = createMap(d.featureRes, d.dof, d.extraMapValues);
[replaced, replacement] = nicheCompete(observation, fitness, predMap, d);
predMap = updateMap(replaced,replacement,predMap,fitness,observation,...
                        predValues,d.extraMapValues);

% Illuminate based on surrogate models
predMap = mapElites(acqFunction,predMap,p,d);

%------------- END OF CODE --------------