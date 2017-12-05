function [value, fitness] = ffdFoil_PreciseEvaluate(observations, d)
%af_PreciseEvaluate - Evaluates airfoils in XFoil
%
% Syntax:  [observation, value] = ffd_PreciseEvaluate(observations, d)
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
%% Single
% parfor iFoil = 1:size(observations,1)
%     shape = d.express(observations(iFoil,:));
%     [drag ,lift] = xfoilEvaluate(shape);
%     drag = log(drag);
%    
%     area = polyarea(shape(1,:), shape(2,:));
%     areaPenalty = (1-(abs(area-d.base.area)./d.base.area)).^7;
%     
%     if lift < d.base.lift %only penalty
%         liftPenalty = 1/ ((1-(lift-d.base.lift)./d.base.lift).^2);
%     else
%         liftPenalty = 1;
%     end
%     
%     fitness(iFoil) = drag.*areaPenalty.*liftPenalty;
%     cD(iFoil) = drag;
%     cL(iFoil) = lift;
% end

%% Vectorized
shape = d.express(observations);
area = squeeze(polyarea(shape(1,:,:), shape(2,:,:)));
areaPenalty = (1-(abs(area-d.base.area)./d.base.area)).^7;
parfor iFoil = 1:size(observations,1)
    [drag ,lift] = xfoilEvaluate(shape(:,:,iFoil));
    drag = log(drag);
    
    if lift < d.base.lift %only penalty
        liftPenalty = 1/ ((1-(lift-d.base.lift)./d.base.lift).^2);
    else
        liftPenalty = 1;
    end
    
    fitness(iFoil) = drag.*areaPenalty(iFoil).*liftPenalty;
    cD(iFoil) = drag;
    cL(iFoil) = lift;
end
%%
value(:,1) = cD;
value(:,2) = cL;

%------------- END OF CODE --------------