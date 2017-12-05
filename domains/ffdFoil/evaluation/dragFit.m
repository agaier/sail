function [fitness, drag, lift, area] = ...
    dragFit(x, expressMethod, baseArea, baseLift)
%dragFit - Returns drag reduction fitness: drag and constraint violation
% Soft Constraints:
%   a) Area approximately the same as base foil
%   b) Lift greater than or equal to base foil
%
%  fitness = drag * (1 - abs(areaDiff) ) * liftPercentWorse
%
%  Note: Lift is only a penalty, if lift is better than base foil no
%  additional fitness is awarded
%
% Syntax:  [fitness, drag, lift, area] = dragFit(x, expressMethod, baseArea, baseLift)
%
% Inputs:
%    x             - parameters for single shape
%    expressMethod - function which converts 'x' parameterization to x,y coordinates
%    baseFoil      - [2XN] x,y points
%
% Outputs:
%    fitness = drag * (1+areaDiff).^2 + liftPercentWorse
%
%
% Other m-files required: expressParsec getValidity
% Subfunctions: none
% MAT-files required: none
%
% TODO:
% * Seperate fitness calculation from evaluation


% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 17-May-2016

%------------- BEGIN CODE --------------
if size(x,1) > size(x,2);x=x';end
shape = expressMethod(x);
[drag ,lift] = xfoilEvaluate(shape);

drag = log(drag);

area = polyarea(shape(1,:), shape(2,:));
areaPenalty = (1-(abs(area-baseArea)./baseArea)).^7;

if lift < baseLift %only penalty
    liftPenalty = 1/ ((1-(lift-baseLift)./baseLift).^2);
else
    liftPenalty = 1;
end

fitness = drag.*areaPenalty.*liftPenalty;



%------------- END OF CODE --------------