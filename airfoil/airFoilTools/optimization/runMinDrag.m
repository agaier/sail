function runMinDrag(frozenDims, nRuns, fileName)
%runMinDrag - Drag minimization cma-es with frozen dims and save results
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    frozenDims - vector of indices to not change in baseParsec
%    nRuns      - number of runs
%    fileName   - output file
%
%
% Example: 
%   frozenDims = [9 10];
%   runMinDrag(frozenDims, nRuns, fileName)
%
% Other m-files required: minDragHPC
% Subfunctions: none
% MAT-files required: baseShape.mat parsecRange.mat
%
% See also: minDragHPC, minimizeDrag, cmaes, dragFit

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 20-May-2016

%------------- BEGIN CODE --------------
if nargin == 1
    nRuns = 3;
    fileName = 'test.mat';
end

load('raeParsec.mat'); baseParsec = raeParsec;
load('raeRange.mat') ; baseRange  = raeRange;

minDragHPC(frozenDims,baseParsec, baseRange, nRuns,fileName)

%------------- END OF CODE --------------