function [map, edges] = createMap(featureResolution, genomeLength, varargin)
%createMap - Defines map struct and feature space cell divisions
%
% Syntax:  [map, edges] = createMap(featureResolution, genomeLength)
%
% Inputs:
%    featureResolution - [1XN] - Number of bins in N dimensions
%    featureResolution - [1X1] - Length of genome
%    featureResolution - cell  - Strings with name of additional value
%
% Outputs:
%    map  - struct with [M(1) X M(2)...X M(N)] matrices for fitness, etc
%       edges               - {1XN} cell of partitions for each dimension
%       fitness, drag, etc  - [M(1) X M(2) X M(N)] matrices of scalars
%       genes               - [M(1) X M(2) X M(N) X genomeLength]
%
% Example: 
%   map = createMap([10 5], 3); % 10 X 5 map of genomes with 3 parameters
%   OR
%   extraMapValues = {'cD','cL'};
%   map = createMap(d.featureRes, d.dof, extraMapValues)
%


% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 27-Jan-2017

%------------- BEGIN CODE --------------

for i=1:length(featureResolution)
    edges{i} = linspace(0,1,featureResolution(i)+1); %#ok<AGROW>
end
map.edges = edges;

blankMap     = NaN(featureResolution,'double');
map.fitness  = blankMap;
map.genes    = repmat(blankMap,[1 1 genomeLength]); %#ok<REPMAT>

if ~isempty(varargin)
    for iValues = 1:length(varargin{1})
        eval(['map.' varargin{1}{iValues} ' = blankMap;']);
    end
end



%------------- END OF CODE --------------