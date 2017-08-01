function predMap = createPredictionMap(gpModels,p,d)
%createPredictionMap - Produced prediction map from surrogate model
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 1-Aug-2017

% TODO: 'varargin' arguments to change hyperparameters below

%------------- BEGIN CODE --------------

% Adjust hyperparameters
p.nChildren = 250;
p.nGens = 500;

p.display.illu = true;
p.display.illuMod = 100;

d.varCoef = 0; %no award for uncertainty
d.featureRes = [50 50];

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