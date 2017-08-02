% AIRFOIL domain
%
% Domain Functions:
%   af_Domain           - Airfoil Domain Parameters (load this into SAIL)
%   af_AcquisitionFunc  - Infill criteria based on uncertainty and fitness
%   af_CreateAcqFunc    - Packages GP models into easily used acquisition function
%   af_PreciseEvaluate  - Evaluates airfoils in XFoil
%   af_ValidateChildren - Validates airfoil
%   af_Categorize       - Returns feature values between 0 and 1 for each dimension
%   af_RecordData       - Do any data gathering here
%
% Representation encoding:
%   expressParsec - Returns coordinates and plots airfoil defined in PARSEC
%   getValidity   - Validates airfoil
%   setExpression - Creates foil expression function from base foil




