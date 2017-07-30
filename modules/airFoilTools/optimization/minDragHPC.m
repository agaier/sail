function minDragHPC(frozenDims,baseParsec, baseRange, nRuns, fileName)
%minDragHPC - Runs drag minimization cma-es on cluster and saves all
%results to mat file

frozenDimsBool  = false(1,12); frozenDimsBool(frozenDims) = true;
fullParsec      = @(p) reducedParsec(p,baseParsec,frozenDimsBool);
expressMethod   = @(p) expressParsec(fullParsec(p), baseRange);
startParams     = baseParsec(~frozenDimsBool);

for iRun = 1:nRuns
[bestParams(:,iRun), ~, bestDrag(iRun),bestLift(iRun),history(:,:,iRun)] = ...
    minimizeDrag(expressMethod, startParams);
end

save(fileName,'bestParams','bestDrag','bestLift','history','expressMethod','fullParsec');


end