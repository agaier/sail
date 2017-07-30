function [params,coords,error] = shapeMatch(expressMethod,nParam,target)
%shapeMatch - Matches a parameterized shape to a set of x,y coordinates
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
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 12-May-2016

%------------- BEGIN CODE --------------

%% CMA-ES options

opts = cmaes;
opts.Restarts = 3;
opts.LBounds = 0;
opts.UBounds = 1;
opts.StopFitness = 1e-10;
opts.PopSize = 12;
opts.SaveVariables = 'off';
opts.TolFun = 1e-10;
opts.LogTime = 0;
opts.DispModulo = Inf;
%opts.MaxFunEvals = 10000;

[~,error,~,~,~,best] = cmaes('matchFit',rand(1,nParam),0.2,opts,expressMethod,target);
params = best.x';
ulTarget = target(:,1:floor(end/2) );
llTarget = target(:,1+ceil(end/2):end);
coords = expressMethod(params,[ulTarget(1,:); llTarget(1,:)]);

%------------- END OF CODE --------------