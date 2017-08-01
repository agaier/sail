function expressionFunction = setExpression(baseParsec, baseRange, degreesOfFreedom)
%setExpression - Creates foil expression function from base foil
% If no number of degrees of freedom are assigned, 10 are assumed.
%
% Syntax:  expressFoil  = setExpression(baseParsec, baseRange)
%
% Inputs:
%    baseParsec     - [1X12] - PARSEC parameters of base foil
%    baseRange      - [2X12] - Min/Max PARSEC parameter ranges 
%    unFrozenDims   - [1X1]  - Number of degrees of freedom from base foil
%
% Outputs:
%    expressionFunction - function which takes [unFrozenDims] parameters
%    and returns x,y coordinates of airfoil
%
% Example: 
%     load('raeParsec.mat'); baseParsec = raeParsec;
%     load('raeRange.mat') ; baseRange  = raeRange;
%     baseFoil = expressParsec(baseParsec,baseRange);
%     expressFoil  = setExpression(baseParsec, baseRange);
%
% Other m-files required: freeDims, expressParsec
%
% See also: freeDims, expressParsec

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 07-Jun-2016

%------------- BEGIN CODE --------------
if nargin < 3; degreesOfFreedom = 10; end

freeDimsBool = false(1,12); 
freeDimsBool(freeDims(degreesOfFreedom)) = true;

expressionFunction  = @(p)...
        expressParsec(getFullParsec(p,baseParsec,freeDimsBool), baseRange);

%------------- END OF CODE --------------