% VELO domain
%
% Domain Functions:
%   velo_Domain           - Velomobile Domain Parameters
%   velo_AcquisitionFunc  - Infill criteria based on uncertainty and fitness
%   velo_CreateAcqFunc    - Packages GP models into easily used acquisition function
%   velo_PreciseEvaluate  - Sends velomobile shapes in parallel to OpenFOAM func
%   velo_OpenFoamResult   - Evaluates a single shape in OpenFOAM
%   velo_ValidateChildren - Validates velomobile shapes
%   velo_Categorize       - Returns feature values between 0 and 1 for each dimension
%   velo_RecordData       - Do any data gathering here
%
% Representation encoding:
%   expressVelo           - Converts set of parameters to STL velomobile
%   #notallvelos.mat      - 10,000 velomobiles found by Sobol sequence

