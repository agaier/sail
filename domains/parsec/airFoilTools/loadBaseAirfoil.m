function base = loadBaseAirfoil(parsec, range)
%loadBaseAirfoil- Creates base struct with drag, lift, and geometry
%
% Syntax:  base = loadBaseAirfoil(parsec, range)
%
% Inputs:
%   parsec: Parsec values of base normalized between 0 and 1 [1X12]
%   range : Parsec ranges as min/max [2X12]
%
% Outputs:
%   base:   Base foil characteristics
%       .parsec:    Parsec values of base normalized between 0 and 1 [1X12]
%       .range:     Parsec ranges as min/max [2X12]
%       .foil:      Cartesian points of foil [2X # points]
%       .drag:      Drag as tested in simulation
%       .lift:      Lift as tested in simulation
%       .area:      Area of shape as defined by base.foil
%
%
% Example: 
%   load('raeParsec.mat'); load('raeRange.mat');  
%   base = loadBaseAirfoil(raeParsec, raeRange);
%
% Other m-files required: expressParsec,  xfoilEvaluate
% Subfunctions: none
% MAT-files required: none
%
% See also: expressParsec,  xfoilEvaluate

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 07-Jun-2016

%------------- BEGIN CODE --------------
base.parsec = parsec;
base.range  = range;
base.foil = expressParsec(parsec,range);
[base.drag, base.lift] = xfoilEvaluate(base.foil);
base.area = polyarea(base.foil(1,:),base.foil(2,:));
%------------- END OF CODE --------------