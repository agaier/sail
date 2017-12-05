function [inds, vals, nMissing, nAttempts] = getValidInds(indPool,testFunction,nDesired)
%getValidInds - Tests individuals until a full valid set is found 
%
% Syntax:  [individuals, value] = getValidInds(indPool,testFunction)
%
% Inputs:
%    indPool        - Pool of possible solutions to test for validity
%    testFunction   - [@] Function to determined validity, and possibly
%                     return values if it is a precise evaluation function
%    nDesired       - Number of valid solutions to return
%    nVals          - (optional) number of values returned by testFunction
%
% Outputs:
%    inds   - Genomes of valid individuals
%    vals   - Values returned from testFunction
%
%
% See also: initialSampling,  mapElites

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Oct 2017; Last revision: 04-Dec-2017

%------------- Input Parsing ------------

%------------- BEGIN CODE --------------
% Initialize variables
inds = []; vals = [];
nMissing = nDesired; nAttempts= 0;

while nMissing > 0
    % Get Next in Pool to test
    testStart = nAttempts+1; testEnd = min(size(indPool,1),nAttempts+nMissing);
    if (testStart > testEnd); break; end
    nextInd = indPool(testStart:testEnd,:);  
    
    % Test for validity
    result = testFunction(nextInd); % Must return a [nInds X nVals] matrix
    
    % Assign valid solutions
    validInds = find( any(~isnan(result),2) );
    vals = [vals;  result(validInds,:)]; %#ok<AGROW>
    inds = [inds; nextInd(validInds,:)]; %#ok<AGROW>
    
    % Retry
    nMissing = nDesired - size(vals,1);
    nAttempts= nAttempts + size(nextInd, 1);  
end






%------------- END OF CODE --------------