% function [bestParams,fitHistory] = ...
%     minimizeDrag(expressMethod,baseFoilGenes, base, nIters)
function [bestParams,bestDrag,bestLift,bestFitness, fitHistory] = ...
   minimizeDrag()
%minimizeDrag - evolves base foil to reduce drag
%
% Syntax:  [bestParams, bestFoil, bestDrag, bestLift, history] = minimizeDrag(expressMethod, baseFoil)
%
% Inputs:
%    expressMethod - foil expression method (encoding -> x,y coordinates)
%    baseFoil      - starting foil in a [2XN] x,y coordinate vector
%
% Outputs:
%   bestParams  - encoding parameters of best found foil
%   bestFoil    - [2XN] x,y coordinate vector of best found foil
%   bestDrag    - drag value of best found foil
%   bestLift    - lift value of best found foil
%   history     - fitness history as [1 X iterations] vector
%
% Example: 
%   see demo.m
%
% Other m-files required: cmaes expressParsec dragFit
% Subfunctions: none
% MAT-files required: none
%
% See also: cmaes,  dragFit, expressParsec

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 17-May-2016

%------------- BEGIN CODE --------------

%% CMA-ES options
nIters = 1000;

opts = cmaes;
opts.Restarts = 0;
opts.LBounds = 0;
opts.UBounds = 1;
opts.StopFitness = -Inf;
opts.PopSize = 10;
opts.SaveVariables = 'off';
opts.TolFun = -Inf;
opts.LogTime = 0;
opts.DispModulo = 5;
opts.MaxFunEvals = nIters;
opts.EvalInitialX = 'no';
opts.StopOnEqualFunctionValues = false;
opts.EvalParallel = 'yes';

% Expression function usage
express = @(x) ffdRaeY(x);
baseParams = 0.5*ones(1,10);
[~, baseLift, baseFoil] = ffdDrag(baseParams);
baseArea = polyarea(baseFoil(1,:), baseFoil(2,:));

% Evaluation function usage
[baseFitness,baseDrag, baseLift, baseArea] = dragFit(baseParams, express, baseArea, baseLift);


[~,~,~,~,out,best] = cmaes('dragFit',baseParams,0.2,opts, ...
                            express, baseArea, baseLift);
bestParams = best.x'; 
%display(out.fitHistory);
if ~isempty(out.fitHistory)
    fitHistory = out.fitHistory(:,[1 2]);
else
    fitHistory = NaN;
end

%% Display Results
[bestFitness, bestDrag, bestLift, bestArea] = dragFit(bestParams, express, baseArea, baseLift);
%clf; 
% subplot(2,1,1);
% fPlot(express(baseParams),'--');hold on;fPlot(express(bestParams));
% axis equal; grid on; legend({'RAE2822','Deformed Foil'})
% 
% subplot(2,1,2);
% percDiff = @(base,comparison) (comparison-base)/base;
% h = bar([percDiff(baseFitness,bestFitness); 
%      percDiff(baseDrag,bestDrag);
%      percDiff(baseLift,bestLift);
%      percDiff(baseArea,bestArea)].*100);
% set(gca,'XTickLabel',{'Fitness','Drag','Lift','Area Difference'});
% ylabel('Percent Improvement From Base'); grid on
% 
% disp(['Base Foil Drag: ' num2str(baseDrag)]);
% disp(['Best Foil Drag: ' num2str(bestDrag)]);
 




%------------- END OF CODE --------------