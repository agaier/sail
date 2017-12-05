function base = loadBaseAirfoil(expressionFunction, dof)
%loadBaseAirfoil- Creates base struct with drag, lift, and geometry
%
% Syntax:  base = loadBaseAirfoil(expressionFunction)
%
% Inputs:
%   expressionFunction: function handle for producing deformation
%   dof:                number of degrees of freedom (genome length)
%
% Outputs:
%   base:   Base foil characteristics
%       .foil:      Cartesian points of foil [2X # points]
%       .drag:      Drag as tested in simulation
%       .lift:      Lift as tested in simulation
%       .area:      Area of shape as defined by base.foil
%
%
% Example: 
%   express = @(x) ffdRaeY(x);
%   base = loadBaseAirfoil(express);
%
% Other m-files required: ffdRaeY,  xfoilEvaluate
% Subfunctions: none
% MAT-files required: none
%
% See also: ffdRaeY, ffd,  xfoilEvaluate

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Aug 2017; Last revision: 15-Aug-2017

%------------- BEGIN CODE --------------
base.foil = expressionFunction(0.5*ones(1,dof));
[base.drag, base.lift] = xfoilEvaluate(base.foil);
base.area = polyarea(base.foil(1,:),base.foil(2,:));
%------------- END OF CODE --------------