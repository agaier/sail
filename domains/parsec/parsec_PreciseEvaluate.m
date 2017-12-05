function [value, fitness] = parsec_PreciseEvaluate(observations, d)
%af_PreciseEvaluate - Evaluates airfoils in XFoil
%
% Syntax:  [observation, value] = af_InitialSamples(p)
%
% Inputs:
%    observations - Samples to evaluate
%    d            - domain description struct
%                   .express
%                   .base.area
%                   .base.lift    
%
% Outputs:
%    value(:,1)  - [nObservations X 1] cD (coefficient of drag)
%    value(:,2)  - [nObservations X 1] cL (coefficient of lift)
%    fitness     - [nObservations X 1] calculated performance
%
% Other m-files required: xFoilEvaluate

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 30-Jul-2017

%------------- BEGIN CODE --------------

% Evaluate initially chosen solutions
fitness = nan(1,size(observations,1));
parfor iFoil = 1:size(observations,1)
    [shape,ul,ll,parsecParams] = d.express(observations(iFoil,:));
    
    if getValidity(ul,ll,parsecParams)
        [drag ,lift] = xfoilEvaluate(shape);
       
        drag = log(drag);
        
        area = polyarea(shape(1,:), shape(2,:));
        areaPenalty = (1-(abs(area-d.base.area)./d.base.area)).^7;
        liftPenalty = (1-(abs(lift-d.base.lift)./d.base.lift)).^2;
        liftPenalty = max([liftPenalty (lift > d.base.lift)]); %only penalty
        
        fitness(iFoil) = drag.*areaPenalty.*liftPenalty;
    else
        disp('invalid geometry');
        drag    = nan;
        lift    = nan;
        fitness(iFoil) = nan;
    end
    
    cD(iFoil) = drag;
    cL(iFoil) = lift;
end

value(:,1) = cD;
value(:,2) = cL;

%------------- END OF CODE --------------