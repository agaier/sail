function [fitness,predValue] = velo_AcquisitionFunc(drag,d)
%computeFitness - Computes fitness with penalties from drag, lift, area
%
% Syntax:  [fitness, drag, lift] = computeFitness(drag, lift, initialFoils)
%
% Inputs:
%   drag -    [2XN]    - drag mean and variance (log space)
%   lift -    [2XN]    - lift mean and variance
%   foil -    [2XMXN]  - [X,Y] defined over M points, of N individuals
%   d    -             - domain struct 
%   .varCoef  [1X1]    - uncertainty weighting for UCB
%   .baseLift [1X1]    - lift of base foil
%   .baseArea [1X1]    - area of base foil
%
% Outputs:
%    fitness - [1XN] - Fitness value (lower is better)
%
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------

fitness = -(drag(:,1)*d.muCoef - drag(:,2)*d.varCoef); % better fitness is higher fitness  
predValue = drag(:,1);

%------------- END OF CODE --------------
