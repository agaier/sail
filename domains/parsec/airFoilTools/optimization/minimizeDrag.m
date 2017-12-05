function [bestParams,bestDrag,bestLift,bestFitness, fitHistory] = ...
    minimizeDrag(expressMethod,baseFoilGenes, base, nIters)
%function [bestParams,bestDrag,bestLift,bestFitness] = ...
%    minimizeDrag(expressMethod,baseFoilGenes, base, nIters)
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
%opts.EvalParallel = 'yes';

baseDrag = base.drag;
baseLift = base.lift;
baseArea = base.area;

baseFoilGenes(baseFoilGenes>1) = 1;
baseFoilGenes(baseFoilGenes<0) = 0;

[~,~,~,~,out,best] = cmaes('dragFit',baseFoilGenes,0.2,opts, ...
                            expressMethod, baseArea, baseLift);
bestParams = best.x'; 

[bestFitness, bestDrag, bestLift, bestArea] = dragFit(bestParams, expressMethod, baseArea, baseLift);

if ~isempty(out.fitHistory)
    fitHistory = out.fitHistory(:,[1 2]);
else
    fitHistory = NaN;
end

%------------- END OF CODE --------------