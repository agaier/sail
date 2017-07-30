function varargout = constructSurrogate(inputSamples, varargin)
%constructSurrogate - creates GP surrogate functions
%
% Syntax: [gpDrag, gpLift] = constructSurrogate(initialSamples,      ...
%                                               cD, paramsGP(p.dof), ...
%                                               cL, paramsGP(p.dof)  );
%
% Inputs:
%   inputSamples   - [N X M] - training input samples
%   varargin{even} - [N X 1] - training output values
%   varargin {odd} - struct  - GP parameters
%
% Outputs:
%   [varargout(1), varargout(2)] - function handles to gpPredictors
%                                    syntax: [NX1] = gpPredictor([NXM]) 
%
% See also: trainGP, paramsGP, gp

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 13-Jun-2016
%
%------------- BEGIN CODE --------------
if isempty(varargin); error('Must have at least one output vector');end;
nSurrogates = length(varargin)/2;
if mod(nSurrogates,1); error('One set of GP parameters required per output vector');end;

parfor iSurrogate = 1:nSurrogates
    outputSet{iSurrogate} = varargin{iSurrogate*2-1};
    paramSet {iSurrogate} = varargin{iSurrogate*2};
    
    % Clean and Preprocess Training Data
    converged     {iSurrogate} = ~isnan(outputSet{iSurrogate});
    trainingInput {iSurrogate} = inputSamples(converged{iSurrogate} ,:);
    trainingOutput{iSurrogate} = outputSet{iSurrogate}(converged{iSurrogate} );
       
    % Create Gaussian Model Predictors
    gpModel{iSurrogate} = trainGP(trainingInput{iSurrogate},...
                                 trainingOutput{iSurrogate},...
                                       paramSet{iSurrogate} );
end

% Package predictors into functions for output
for iSurrogate = 1:nSurrogates
    varargout{iSurrogate} =  @(x) predictGP(gpModel{iSurrogate},x);
end

if nSurrogates > nargout; warning('Not all GP models output (too few output arguments)');end;
%------------- END OF CODE --------------