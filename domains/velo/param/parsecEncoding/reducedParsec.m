% Produces parsec values when some dimensions are frozen around a base
% shape

function allParsecVals = reducedParsec(p,base,frozenDims)
p = p';
freeDims = ~frozenDims;
if size(p,2) > 1
    allParsecVals = repmat(base,size(p,1),1);
    allParsecVals(:, ~frozenDims) = p;
else  
    allParsecVals( frozenDims) = base(frozenDims);
    allParsecVals(~frozenDims) = p;
end