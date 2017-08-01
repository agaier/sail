function [fitness] = matchFit(x, expressMethod,target,varargin)
%shapeMatch - Returns mean squared error difference between two shapes
%
% Syntax:  [fitness] = matchFit(x, expressMethod,target,varargin)
%
% Inputs:
%    x             - parameters for single shape
%    expressMethod - function which converts 'x' parameterization to x,y
%    coordsinates
%    target        - [2XN] x,y points
%
% Outputs:
%    error - MSE as squared distance of closest points in x to target
%
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
ulTarget = target(:,1:floor(end/2) );
llTarget = target(:,1+ceil(end/2):end);

[shape,ul,ll,parsecParams] = expressMethod(x',[ulTarget(1,:); llTarget(1,:)]);
if getValidity(ul,ll,parsecParams)
    errorTop = ul(2,:) - ulTarget(2,:);
    errorBot = ll(2,:) - llTarget(2,:);    
    fitness = mean([errorTop errorBot].^2);
else
    fitness = nan;
end

% splot = @(coords) plot(coords(1,:), coords(2,:)); % 2d plotting
% splot(shape);hold on;splot(target);hold off;
% axis([0 1 -0.08 0.08]);
% drawnow;

%------------- END OF CODE --------------