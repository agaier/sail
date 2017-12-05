function [fitness,predValues] = ffdFoil_AcquisitionFunc(drag,lift,deform,d)
%ffd_AcquisitionFunc - Infill criteria based on uncertainty and fitness
%
% Syntax:  [fitness, predValues] = af_AcquisitionFunc(drag, lift, initialFoils, d)
%
% Inputs:
%   drag    -    [2XN]    - drag mean and variance (log space)
%   lift    -    [2XN]    - lift mean and variance
%   deform  -    [NXM]    - N genomes of length M
%   d       -             - domain struct 
%   .varCoef  [1X1]       - uncertainty weighting for UCB
%   .baseLift [1X1]       - lift of base foil
%   .baseArea [1X1]       - area of base foil
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
%% Single
% area = nan(size(deform,1),1);
% for iDeform = 1:size(deform,1)
%    foil = d.express(deform(iDeform,:));
%    area(iDeform) = polyarea(foil(1,:),foil(2,:));
% end

%% Vectorized
foil = d.express(deform);
area = squeeze(polyarea(foil(1,:,:),foil(2,:,:)));

%%
areaPenalty = (1-(abs(area-d.base.area)./d.base.area)).^7;

liftPenalty = (1- normcdf(d.base.lift, lift(:,1), lift(:,2))).^2;
fitDrag = (d.muCoef * drag(:,1)) - (d.varCoef * drag(:,2) );
fitness = fitDrag .* liftPenalty .* areaPenalty;

predValues{1} = drag;
predValues{2} = lift;
predValues{3} = drag(:,2);
%------------- END OF CODE --------------
