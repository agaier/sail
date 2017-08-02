function map = updateMap(replaced,replacement,map,...
                            fitness,genes,values,extraMapValues) %#ok<INUSL>
%updateMap - Replaces all values in a set of map cells
%
% Syntax:  map = updateMap(replaced,replacement,map,fitness,drag,lift,children)
%
% Inputs:
%   replaced    - [1XM]  - linear index of map cells to be replaced
%   replacement - [1XM]  - linear index of children values to place in map
%   map         - struct - population archive
%   fitness     - [1XN]  - Child fitness
%   genes       - [NXD]  - Child genomes
%   values      - [1XN]  - extra values of interest, e.g. 'cD'
%
% Outputs:
%   map         - struct - population archive
%
%
% See also: createMap, nicheCompete

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 02-Aug-2017

%------------- BEGIN CODE --------------

% Assign Fitness
map.fitness (replaced) = fitness (replacement);

% Assign Genomes
[r,c] = size(map.fitness);
[replacedI,replacedJ] = ind2sub([r c], replaced);
for iReplace = 1:length(replaced)
    map.genes(replacedI(iReplace),replacedJ(iReplace),:) = ...
        genes(replacement(iReplace),:) ;    
end

% Assign Miscellaneous Map values
if ~isempty(extraMapValues)
    for iValues = 1:length(extraMapValues)
        eval(['map.' extraMapValues{iValues} '(replaced) = values{' int2str(iValues) '}(replacement);']);
    end
end

%------------- END OF CODE --------------