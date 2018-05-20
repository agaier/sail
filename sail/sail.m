function [output] = sail(p,d)
%SAIL - Surrogate Assisted Illumination Algorithm
% Main run script of SAIL algorithm
%
% Syntax:  [output] = sail(p)
%
% Inputs:
%   p  - struct - Hyperparameters for algorithm, visualization, and data gathering
%   d  - struct - Domain definition
%    * - sail with no arguments to return default parameter struct
%
% Outputs:
%    output - output struct with fields:
%               .output.model{1}             - gpModels produced by SAIL
%               .output.model{1}.trainInput  - input samples
%               .output.model{1}.trainOutput - sample results
%               .p - parameter struct (for data keeping)
%               .* - other parameters recorded throughout run
%
% Example:
%    p = sail;                                  % Load default parameters
%    p.nTotalSamples = 80;                      % Edit default parameters
%    d = af_Domain;                             % Load domain parameters
%    output = sail(d,p);                        % Run SAIL algorithm
%    predMap = createPredictionMap(output.model,p,d);
%    viewMap(predMap.fitness, p, d)             % View Prediction Map
%
% Other m-files required:
%   defaultParamSet, initialSampling, trainGP,
%   createMap, nicheCompete, updateMap, mapElites, sobolset
%
% Other submodules required: gpml-wrapper
%
% MAT-files required: if loading initial samples "d.initialSampleSource"
%
% See also: runSail, createPredictionMap, mapElites

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Nov 2016; Last revision: 03-Aug-2017

%------------- BEGIN CODE --------------

if nargin==0; output = defaultParamSet; return; end

% Create initial
trainingTime = []; predTime = [0]; illumTime = [0]; peTime = []; predMap = [];
%% 0 - Produce Initial Samples
peStart = tic;
if ~d.loadInitialSamples
    [observation, value] = initialSampling(d,p.nInitialSamples);
else
    load(d.initialSampleSource); % Contains fields: 'observation', 'value'
    randomPick = randperm(size(observation,1),p.nInitialSamples); %#ok<NODEF>
    observation = observation(randomPick,:);
    value = value(randomPick,:); %#ok<NODEF>
end
nSamples = size(observation,1);

% -- Data Gathering -- %   
peTime = [peTime toc(peStart)];    

%% Acquisition Loop
while nSamples <= p.nTotalSamples
    %% 1 - Create Surrogate and Acquisition Function
    % Surrogate models are created from all evaluated samples, and these
    % models are used to produce an acquisition function.
    disp(['PE ' int2str(nSamples) ' | Training Surrogate Models']); 
    trainStart = tic;
    parfor iModel = 1:size(value,2)
        % Only retrain model parameters every 'p.trainingMod' iterations
        if (nSamples==p.nInitialSamples || mod(nSamples,p.trainingMod*p.nAdditionalSamples))
            gpModel{iModel} = trainGP(observation, value(:,iModel), d.gpParams(iModel));
        else
            gpModel{iModel} = trainGP(observation, value(:,iModel), d.gpParams(iModel),'functionEvals',0);
        end
    end
    
    % -- Data Gathering -- %
    trainingTime = [trainingTime toc(trainStart)];    
    
    % Save found model parameters and update acquisition function
    for iModel=1:size(value,2); d.gpParams(iModel).hyp = gpModel{iModel}.hyp; end
    acqFunction = feval(d.createAcqFunction, gpModel, d);
           
    % Create intermediate prediction map for analysis
    if ~mod(nSamples,p.data.mapEvalMod) && p.data.mapEval
        disp(['PE: ' int2str(nSamples) '| Illuminating Prediction Map']);
        [predMap(nSamples), ~] = ...
            createPredictionMap(gpModel,observation,p,d,...
            'featureRes', p.data.predMapRes, ...
            'nGens'     , 2*p.nGens);
    end

    % No reason for further illumination if we have reached our budget
    if nSamples >= p.nTotalSamples; break; end
    
    %% 2 - Illuminate Acquisition Map
    % A map is constructed using the evaluated samples which are evaluated
    % with the acquisition function and placed in the map as the initial
    % population. The observed samples are the seed population of the
    % 'acquisition map' which is then created by optimizing the acquisition
    % function with MAP-Elites.
    if nSamples == p.nTotalSamples; break; end  % After final model is created no more infill is necessary
    disp(['PE: ' int2str(nSamples) '| Illuminating Acquisition Map']);
    illumStart = tic;
    
    % Evaluate observation set with acquisition function
    [fitness,predValues] = acqFunction(observation);
    
    % Place best samples in acquistion map with acquisition fitness
    obsMap = createMap(d.featureRes, d.dof, d.extraMapValues);
    [replaced, replacement] = nicheCompete(observation, fitness, obsMap, d);
    obsMap = updateMap(replaced,replacement,obsMap,fitness,observation,...
        predValues,d.extraMapValues);
    
    % Illuminate with MAP-Elites
    [acqMap, percImproved(:,nSamples),~,predictTime] = mapElites(acqFunction,obsMap,p,d);
    
    % -- Data Gathering -- % 
    predTime  = [predTime predictTime]; % Doesn't include categorization, etc.
    illumTime = [illumTime toc(illumStart)];    
    acqMapRecord(nSamples)     = acqMap;        
    confContribution(nSamples) = nanmedian( (acqMap.confidence(:).*d.varCoef) ./ abs(acqMap.fitness(:)) );
   
    %% 3 - Select Infill Samples    
    % The next samples to be tested are chosen from the acquisition map: a
    % sobol sequence is used to to evenly sample the map in the feature
    % dimensions. When evaluated solutions don't converge or the chosen bin
    % is empty the next bin in the sobol set is chosen.
    disp(['PE: ' int2str(nSamples) '| Evaluating New Samples']); 
    peStart = tic;
 
    % At first iteration initialize sobol sequence for sample selection
    if nSamples == p.nInitialSamples
        sobSet  = scramble(sobolset(d.nDims,'Skip',1e3),'MatousekAffineOwen');
        sobPoint= 1;
    end
    
    % Choose new samples and evaluate them for new observations
    nMissing = p.nAdditionalSamples; newValue = []; newSample = [];
    while nMissing > 0
        % Evenly sample solutions from acquisition map
        %newSampleRange      = sobPoint:(sobPoint+p.nAdditionalSamples*2)-1;
        newSampleRange      = sobPoint:(sobPoint+p.nAdditionalSamples)-1;
        [~, binIndx]        = sobol2indx(sobSet,newSampleRange, d, acqMap.edges);
        for iGenes=1:size(binIndx,1)
            indPool(iGenes,:) = acqMap.genes(binIndx(iGenes,1),binIndx(iGenes,2),:); % TODO: more than 2 dims
        end
        % Remove repeats and nans (empty bins)
        indPool = setdiff(indPool,observation,'rows','stable');
        indPool = indPool(~any(isnan(indPool),2),:);
        
        % Evaluate enough of these valid solutions to get your initial sample set
        peFunction = @(x) feval(d.preciseEvaluate, x , d);    % returns nan if not converged
        [foundSample, foundValue, nMissing] = getValidInds(indPool, peFunction, nMissing);
        newSample = [newSample; foundSample]; %#ok<*AGROW>
        newValue  = [newValue ; foundValue ]; %#ok<*AGROW>
        
        % Advance sobol sequence
        sobPoint = sobPoint + p.nAdditionalSamples + 1;
    end
    
    % Assign found values
    value       = cat(1,value,      newValue);
    observation = cat(1,observation,newSample);
    nSamples    = size(observation,1);
    
    if length(observation) ~= length(unique(observation,'rows'));warning('Duplicate samples in observation set.'); end
 
    % -- Data Gathering -- % 
    peTime = [peTime toc(peStart)];    
    
    output.trainTime    = trainingTime;
    output.predictTime  = predTime;
    output.illumTime    = illumTime;
    output.peTime       = peTime;
    save([p.data.outPath 'sailRun.mat'], 'output');
end % end acquisition loop

    %% Save relevant data
    output.p            = p;
    output.d            = d;
    output.model        = gpModel;
    output.trainTime    = trainingTime;
    output.predictTime  = predTime;
    output.illumTime    = illumTime;
    output.peTime       = peTime;
    output.percImproved = percImproved;
    output.predMap      = predMap;
    output.acqMap       = acqMapRecord;
    output.confContrib  = confContribution;
    output.unpack       = 'names = fieldnames(output); for i=1:length(names) eval( [names{i},''= output.'', names{i}, '';''] ); end';
    
    if p.data.outSave; save([p.data.outPath 'sailRun.mat'], 'output'); end
end




