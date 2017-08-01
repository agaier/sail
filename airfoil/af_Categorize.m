function [feature] = af_Categorize(samples, d)
%af_Categorize - Returns feature values between 0 and 1 for each dimension
%
% Syntax:  [fitness, drag, lift] = computeFitness(drag, lift, initialFoils)
%
% Inputs:
%   drag -    [2XN]    - drag mean and variance (log space)
%   lift -    [2XN]    - lift mean and variance
%   foil -    [2XMXN]  - [X,Y] defined over M points, of N individuals
%   p    -             - parameter struct 
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
% Jun 2016; Last revision: 27-Jan-2017

%------------- BEGIN CODE --------------

feature = samples(:,[2 3]);
feature = (feature-d.featureMin)./(d.featureMax-d.featureMin);

%------------- END OF CODE --------------
