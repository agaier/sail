function [fitness,predValues] = parsec_AcquisitionFunc(drag,lift,foil,d)
%af_AcquisitionFunc - Infill criteria based on uncertainty and fitness
%
% Syntax:  [fitness, predValues] = af_AcquisitionFunc(drag, lift, initialFoils, d)
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
%    fitness    - [1XN] - Fitness value (lower is better)
%    predValues - {1,2}]- Drag, Lift 
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 01-Aug-2017

%------------- BEGIN CODE --------------
fitDrag = (d.muCoef * drag(:,1)) - (d.varCoef * drag(:,2) );

area = squeeze(polyarea(foil(1,:,:),foil(2,:,:)));
areaPenalty = (1-(abs(area-d.base.area)./d.base.area)).^7;
liftPenalty = (1- normcdf(d.base.lift, lift(:,1), lift(:,2))).^2;

fitness = fitDrag .* liftPenalty .* areaPenalty;

predValues{1} = drag;
predValues{2} = lift;
predValues{3} = drag(:,2);

%------------- END OF CODE --------------
