function [fitness,predValue] = velo_AcquisitionFunc(drag,d)
%velo_AcquisitionFunc - Infill criteria based on uncertainty and fitness
%
% Syntax:  [fitness, dragForce] = velo_AcquisitionFunc(drag,d)
%
% Inputs:
%   drag -    [2XN]    - dragForce mean and variance
%   d    -             - domain struct 
%   .varCoef  [1X1]    - uncertainty weighting for UCB
%
% Outputs:
%    fitness   - [1XN] - Fitness value (lower is better)
%    predValue - [1XN] - Predicted drag force (mean)
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------

fitness = -(drag(:,1)*d.muCoef - drag(:,2)*d.varCoef); % better fitness is higher fitness  
predValue = drag(:,1);

%------------- END OF CODE --------------
