function [acqFunction] = af_CreateAcqFunc(gpModel, d)
%af_CreateAcqFunc - Packages GP models into easily used acquisition function
%
% Syntax:  acqFunction = af_CreateAcqFunction, gpModel, d);
%
% Inputs:
%    gpModel - cell - one or more gaussian process models
%    d              - Domain description struct
%    .express       - genotype->phenotype conversion function
%
% Outputs:
%    acqFunction - anonymous function that takes genome as input and
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 30-Jul-2017

%------------- BEGIN CODE --------------

acqFunction = @(x) af_AcquisitionFunc(...
                        predictGP(gpModel{1},x),... % Drag
                        predictGP(gpModel{2},x),... % Lift
                        d.express(x),...            % Area
                        d);                         % Hyperparams and base

%------------- END OF CODE --------------