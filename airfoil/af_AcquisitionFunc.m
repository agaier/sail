function [fitness,predValues] = af_AcquisitionFunc(drag,lift,foil,d)
%computeFitness - Computes fitness with penalties from drag, lift, area
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
area = squeeze(polyarea(foil(1,:,:),foil(2,:,:)));
areaPenalty = (1-(abs(area-d.base.area)./d.base.area)).^7;

liftPenalty = (1- normcdf(d.base.lift, lift(:,1), lift(:,2))).^2;

fitDrag = (d.muCoef * drag(:,1)) - (d.varCoef * drag(:,2) );

if (d.muCoef == 0 && d.varCoef == 0); fitDrag = rand; end

fitness = fitDrag .* liftPenalty .* areaPenalty;

predValues{1} = drag;
predValues{2} = lift;

%------------- END OF CODE --------------
