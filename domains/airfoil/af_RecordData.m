%% af_RecordData -- Do any data gathering here

%% TODO: Convert this to function and reformat for generalized SAIL

% if (nSamples == p.nTotalSamples)  ...                   % @End
%         || ~mod((nSamples-p.nInitialSamples), p.data.outMod)    % @Interval
%     
%     % Known Samples
%     output.cD = cD;              output.cL = cL;
%     output.fitness = fitness;    output.inputSamples = inputSamples;
%     
%     % Surrogate Models
%     output.gpDrag = gpDrag;      output.gpLift = gpLift;
%     
%     % Illuminate without exploration reward to produce Prediction Map
%     previousVarCoef = p.varCoef;  previousMuCoef = p.muCoef;
%     p.varCoef = 0;                      p.muCoef = 1;
%     predFunction = @(x) computeFitness(gpDrag(x), gpLift(x), p.express(x), p); % include predicted drag and lift for analysis
%     p.varCoef = previousVarCoef;        p.muCoef = previousMuCoef;
%     
%     disp(['PE: ' int2str(nSamples) '| Illuminating Prediction Map']);
%     predMap = mapElites(predFunction,obsMap,p);
%     if p.display.figs
%         figure(3);
%         if p.data.mapEval; subplot(2,1,1); end;
%         viewMap(predMap.fitness,p);
%         title('Prediction Map'); colormap(parula(16));caxis([-5.4 0]);
%     end
%     
%     % Evaluate all individuals in prediction map
%     mapTrue = [];
%     if p.data.mapEval && ~mod(nSamples,p.data.mapEvalMod)
%         disp(['PE ' int2str(nSamples) ' | Evaluating Prediction Map']);
%         mapTrue = evaluateMap(predMap,p);
%         figure(3); subplot(2,1,2)
%         viewMap(mapTrue.fitness,p);
%         title('True Fitness'); colormap(parula(16));caxis([-5.4 0]);
%     end
%     
%     % Maps
%     output.map = obsMap;
%     output.acqMap = acqMap;
%     output.predMap = predMap;
%     output.mapTrue = mapTrue;
%     
%     % Parameters
%     output.p = p;
%     save([p.data.outPath 'pe' digitInt2str(nSamples,3) '.mat'], 'output')
% end