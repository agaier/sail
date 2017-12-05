% AIRFOIL domain
%
% Domain Functions:
%   parsec_Domain           - Airfoil Domain Parameters (load this into SAIL)
%   parsec_AcquisitionFunc  - Infill criteria based on uncertainty and fitness
%   parsec_CreateAcqFunc    - Packages GP models into easily used acquisition function
%   parsec_PreciseEvaluate  - Evaluates airfoils in XFoil
%   parsec_ValidateChildren - Validates airfoil geometry
%   parsec_Categorize       - Returns feature values between 0 and 1 for each dimension
%
% Representation encoding:
%   expressParsec - Returns coordinates and plots airfoil defined in PARSEC
%   getValidity   - Validates airfoil
%   setExpression - Creates foil expression function from base foil




