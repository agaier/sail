function [output] = sail(p)
%SAIL - Surrogate Assisted Illumination Algorithm
% Main run script of SAIL algorithm
%
% Syntax:  [output] = sail(p)   
%
% Inputs:
%    p - struct for hyperparameters, visualization, and data gathering
%    * - sail with no arguments to return default parameter struct
%
% Outputs:
%    output - output struct with fields:
%               cD: true cD values of all tested samples [Nx1 double]
%               cL: true cL values of all tested samples [Nx1 double]
%          fitness: true fitness values of all tested samples [Nx1 double]
%     inputSamples: genomes of all tested samples [NxM double]
%           gpDrag: GP cD predictor function 
%           gpLift: GP cL predictor function
%              map: MAP of precisely evaluated solutions
%           acqMap: MAP of optimal solutions for sampling
%          predMap: MAP of best predicted solutions
%          mapTrue: true values of predMap
%                p: parameter struct
%       
%
% Example: 
%    p = sail;                                  % Load default parameters
%    p.nTotalSamples = 60;                      % Edit default parameters
%    output = sail(p);                          % Run SAIL algorithm
%    viewMap(output.predMap.fitness, output.p)  % View results    
%
% Other m-files required: defaultParamSet
% Other submodules required: map-elites, gpml-wrapper airFoilTools
% MAT-files required: none
%
% See also: mapElites, runSail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Nov 2016; Last revision: 27-Jan-2017

%------------- BEGIN CODE --------------

if nargin==0; output = defaultParamSet; return; end

%% Domain parameter (temporary)
d.initialize = 'af_InitialSamples';
d.dof = 10;
d.express = p.express;
d.base = p.base;
d.preciseEvalFunction = p.preciseEvalFunction;

d.gpParams(1)= paramsGP(d.dof); % Drag
d.gpParams(2)= paramsGP(d.dof); % Lift
d.createAcqFunction= 'af_CreateAcqFunc';
d.varCoef = p.varCoef;
d.muCoef = p.muCoef;

d.featureRes = p.featureRes;


%% 0 - Produce Initial Samples
[observation, value] = feval(d.initialize,d,p.nInitialSamples);
nSamples = size(observation,1);

%% Acquisition Loop
% 1) Surrogate models are created from all evaluated samples, and these
% models are used to produce an acquisition function. 

% 2) A MAP is  constructed using the  evaluated samples are tested with the
% acquisition function and placed in a map as the initial population.

% 3) An illumination map is created by running MAP-Elites to optimize to
% acquisition function in every cell.

    % 3.2) When analyzing the performance of the algorithm, a prediction
    % map is created from the current models, and the accuracy of that
    % prediction is judged by evaluating all solutions. The frequency of
    % this process can be changed by changing the p.data parameters.
    
% 4) The next samples to be tested are chosen from the acquisition map,
% this is done with a sobol sequence to even sample the map in the feature
% dimensions. When evaluated solutions don't converge the next in bin in
% the sobol set is chosen.

while nSamples <= p.nTotalSamples
    
    %% 1 - Create Surrogate and Acquisition Function
    disp(['PE ' int2str(nSamples) ' | Training Surrogate Models']);
    
    parfor iModel = 1:size(value,2)
       gpModel{iModel} = trainGP(observation, value(:,iModel), d.gpParams(iModel))
    end
    
    acqFunction = feval(d.createAcqFunction, gpModel, d);                                         
    
    %% 2 - Initialize MAP with Initial Samples
    % Evaluate data set with acquisition function
    [fitness,predValues] = acqFunction(observation);
    
    % Place Best Samples in Map
    [obsMap, p.edges] = createMap(d.featureRes, d.dof);
    [replaced, replacement] = nicheCompete(observation, fitness, obsMap, p);
    obsMap = updateMap(replaced,replacement,obsMap,fitness,observation);
    
    if p.display.figs
        figure(1);subplot(10,2,12:2:18);
        viewMap(obsMap.value,p);        
        colormap(parula(16)); caxis(gca,[-5.4 0]);
        title('Best PE Fitness Samples');
    end
    
    %% 3 - Illuminate Acquisition Map
    disp(['PE: ' int2str(nSamples) '| Illuminating Acquisition Map']);
    acqMap = mapElites(acqFunction,obsMap,p);
    
    % View Acquisition Map and Drag Predictions
    if p.display.figs
        figure(1);
        subplot(10,2,1:2:8);
        viewMap(acqMap.fitness,p);
        title('Acquisition Map'); %  caxis([-5.5 0])
        subplot(10,2,2:2:8);
        viewMap(acqMap.dragMean,p); colormap(parula(16));
        title('Drag Mean (\mu)'); % caxis([0 1.5]);
        subplot(10,2,11:2:18);
        viewMap(sqrt(acqMap.dragS2),p);colormap(parula(16));
        title('Drag Uncertainty (\sigma)') % caxis([0 0.5])
    end
    
    
    %% 3.2 - Save data for Analysis
    if (nSamples == p.nTotalSamples)  ...                   % @End
    || ~mod((nSamples-p.nInitialSamples), p.data.outMod)    % @Interval
                                
        % Known Samples
        output.cD = cD;              output.cL = cL; 
        output.fitness = fitness;    output.inputSamples = inputSamples;
        
        % Surrogate Models        
        output.gpDrag = gpDrag;      output.gpLift = gpLift;
        
        % Illuminate without exploration reward to produce Prediction Map
        previousVarCoef = p.varCoef;  previousMuCoef = p.muCoef;
        p.varCoef = 0;                      p.muCoef = 1;
        predFunction = @(x) computeFitness(gpDrag(x), gpLift(x), p.express(x), p); % include predicted drag and lift for analysis                                                          
        p.varCoef = previousVarCoef;        p.muCoef = previousMuCoef;
        
        disp(['PE: ' int2str(nSamples) '| Illuminating Prediction Map']);
        predMap = mapElites(predFunction,obsMap,p);
        if p.display.figs
            figure(3); 
            if p.data.mapEval; subplot(2,1,1); end;
            viewMap(predMap.fitness,p);
            title('Prediction Map'); colormap(parula(16));caxis([-5.4 0]);
        end
        
        % Evaluate all individuals in prediction map
        mapTrue = [];
        if p.data.mapEval && ~mod(nSamples,p.data.mapEvalMod)
            disp(['PE ' int2str(nSamples) ' | Evaluating Prediction Map']);
            mapTrue = evaluateMap(predMap,p);   
            figure(3); subplot(2,1,2)
            viewMap(mapTrue.fitness,p);
            title('True Fitness'); colormap(parula(16));caxis([-5.4 0]);
        end
        
        % Maps
        output.map = obsMap;            
        output.acqMap = acqMap;
        output.predMap = predMap;
        output.mapTrue = mapTrue;
        
        % Parameters
        output.p = p;         
        
        save([p.data.outPath 'pe' digitInt2str(nSamples,3) '.mat'], 'output')
    end
    
    %% 4 - Select Infill Samples
    if nSamples == p.nInitialSamples    % Initialize sobol sequence for sample selection
        sobSet  = scramble(sobolset(p.nDims,'Skip',1e3),'MatousekAffineOwen');
        sobPoint= 1;
    end
    
    
    if nSamples == p.nTotalSamples; break; else % On Final illumination, no infill
        %%
        display(['PE ' int2str(nSamples) ' | Selecting Next Samples']);

        % Choose Samples for Evaluation
        newSampleRange = sobPoint:(sobPoint+p.nAdditionalSamples-1);
        mapLinIndx = sobol2indx(sobSet,newSampleRange,p);
        sobPoint = sobPoint + length(newSampleRange);
        
        emptyCells = isnan(acqMap.fitness(mapLinIndx));
        while any(emptyCells)
            nEmptyCells = sum(emptyCells);
            mapLinIndx(emptyCells) = ...
                sobol2indx(sobSet,sobPoint:sobPoint+nEmptyCells-1,p);
            emptyCells = isnan(acqMap.fitness(mapLinIndx));
            sobPoint = sobPoint + nEmptyCells;
        end
        
        % Evaluate New Samples
        [r,c] = size(acqMap.fitness);
        [chosenI,chosenJ] = ind2sub([r c], mapLinIndx);
        for i=1:length(mapLinIndx)
            newGenes(i,:) = acqMap.genes(chosenI(i),chosenJ(i),:); %#ok<AGROW>
        end
        
        % Parfor nonsense (splitting variables, local variables...)
        express = p.express; baseArea = p.base.area; baseLift = p.base.lift;
        parfor iGenes = 1:p.nAdditionalSamples
            [~,newCd(iGenes,1),newCl(iGenes,1),~] = feval(p.preciseEvalFunction,...
                newGenes(iGenes,:), express, baseArea, baseLift); %#ok<PFBNS>
        end
        
        % If nan, take the next in the sobol set
        while any(isnan(newCd))
            nNans = sum(isnan(newCd));
            nanGenes = nan(nNans,p.dof);
            display([int2str(nNans) ' NaN values']);
            
            % Identify
            nanIndx = 1:p.nAdditionalSamples;
            nanIndx = nanIndx(isnan(newCd));
            
            % Replace
            newSampleRange = sobPoint:(sobPoint+nNans-1);
            mapLinIndx = sobol2indx(sobSet,newSampleRange,p);
            sobPoint = sobPoint + length(newSampleRange);
            
            [chosenI,chosenJ] = ind2sub([r c], mapLinIndx);
            for iGenes=1:nNans
                nanGenes(iGenes,:) = ...
                    acqMap.genes(chosenI(iGenes),chosenJ(iGenes),:);
            end
            
            % Reevaluate
            newCdp = nan(nNans,1);newClp = nan(nNans,1);
            parfor i = 1:nNans
                [~,newCdp(i), newClp(i),~] = feval(p.preciseEvalFunction,...
                    nanGenes(i,:), express, baseArea, baseLift); %#ok<PFBNS>
            end
            
            % Use parfor data
            newCd(nanIndx)      = newCdp;
            newCl(nanIndx)      = newClp;
            newGenes(nanIndx,:) = nanGenes;
        end
        
        % Add Precise Evaluation Results to Data Set
        cD           = cat(1,cD,newCd);
        cL           = cat(1,cL,newCl);
        inputSamples = cat(1,inputSamples, newGenes);
        nSamples     = size(inputSamples,1);
    end
    
    %% Save Plots
    if p.display.figs
        figure(1);
        subplot(10,2,12:2:18);
        viewMap(obsMap.fitness,p);
        colormap(parula(16));caxis([-5.4 0]);
        title('Precisely Evaluated Samples')
        
        subplot(60,2,[119:120]);
        progress = zeros(1,p.nTotalSamples);progress(1:nSamples) = 1;
        imagesc(progress); ylabel('');
        xlabel(['Precise Evaluations: (' int2str(nSamples) ' / '  int2str(p.nTotalSamples) ')']);
        set(gca,'YTickLabel','','YTick','','XTick','','XTickLabel', '')
    end
    
    % next GIF frame
    if p.display.gifs; drawnow; export_fig test.tif -nocrop -append; end
    
end

% Finalize GIF
if p.display.gifs;im2gif('test.tif', '-delay', 0.5, '-loops', 0);end


output.p = p;
end %%end function





