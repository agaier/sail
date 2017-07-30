function GP_model = trainGP(input,output,p)
%trainGP - Trains Gaussian Process model
% Given training input and output, optimizes given hyperParameters
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input  - [samples X input dims]
%    output - [samples X 1]
%    p      - GP parameter struct
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
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 16-May-2016

%------------- BEGIN CODE --------------

GP_model.hyp = minimize(p.hyp,@gp, -p.functionEvals, @infExact, p.meanfunc, ...
               p.covfunc, p.likfunc, input, output);
GP_model.trainInput = input;
GP_model.trainOutput= output;
GP_model.params     = p;


%------------- END OF CODE --------------