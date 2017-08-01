function mapLinIndx = sobol2indx(sobSet,sobPoints,d,edges)
%sobol2indx - given a point on a sobol set, returns the map linear index
% Syntax:   mapLinIndx = sobol2indx(sobSet,sobPoint,p)
%
% Inputs:
%    sobSet:    A sobol sequence 
%    sobPoints: Indices of sequence to draw
%    p:         parameter struct
%
% Outputs:
%    mapLinIndx: a vector of indices in the map [1Xlength(sobPoints)]
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: sobolset
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 09-Aug-2016

%------------- BEGIN CODE --------------

sampleCoords = sobSet(sobPoints,:);
sampleBin = nan(length(sobPoints),d.nDims);
for iDim = 1:d.nDims
    sampleBin(:,iDim) = discretize(sampleCoords(:,iDim),edges{iDim});
end
mapLinIndx = sub2ind(d.featureRes,sampleBin(:,1),sampleBin(:,2));

%------------- END OF CODE --------------