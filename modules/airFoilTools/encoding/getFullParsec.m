function fullParsec = getFullParsec(p,base,freeDims)
%getFullParsec - gives 12 PARSEC parameters given changed unfrozen params
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  fullParsec = getFullParsec(p,base,freeDims)
%
% Inputs:
%    params     [MXN]  - parameter values of unfrozen parameters
%    base       [1X12] - base 12 parameter values
%    freeDims   [1X12] - boolean string where 1 indicates a free dimension
%
% Outputs:
%    fullParsec [12XN] - Full PARSEC parameterization of N param sets
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
% Jun 2016; Last revision: 02-Jun-2016

%------------- BEGIN CODE --------------
fullParsec = repmat(base,size(p,1),1);
fullParsec(:,freeDims) = p;

%------------- END OF CODE --------------


























