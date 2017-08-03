function [GP_model] = trainGP(input,output,d, varargin)
%trainGP - Trains Gaussian Process model
% Given training input and output, optimizes given hyperParameters
%
% Syntax:  [output1,output2] = function_name(input1,output,gpParams)
%
% Inputs:
%    input  - [samples X input dims]
%    output - [samples X 1]
%    d      - GP parameter struct
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 02-Aug-2016

%------------- INPUT PARSING -----------
parse = inputParser;
parse.addRequired('input');
parse.addRequired('output');
parse.addRequired('d');
parse.addOptional('functionEvals',-d.functionEvals);

parse.parse(input,output,d,varargin{:});
functionEvals = parse.Results.functionEvals;

%------------- BEGIN CODE --------------
GP_model.hyp = minimize(d.hyp,@gp, -functionEvals, @infExact, d.meanfunc, ...
               d.covfunc, d.likfunc, input, output);
GP_model.trainInput = input;
GP_model.trainOutput= output;
GP_model.params     = d;

%------------- END OF CODE --------------