function map = updateMap(replaced,replacement,map,...
                            fitness,genes,values,extraMapValues)
%updateMap - Replaces all values in a set of map cells
%
% Syntax:  map = updateMap(replaced,replacement,map,fitness,drag,lift,children)
%
% Inputs:
%   replaced    - [1XM]  - linear index of map cells to be replaced
%   replacement - [1XM]  - linear index of children values to place in map
%   map         - struct - population archive
%   fitness     - [1XN]  - Child fitness
%   drag        - [2XN]  - Child drag mean/variance
%   lift        - [2XN]  - Child lift mean/variance
%   children    - [NXD]  - Child genomes
%
% Outputs:
%   map         - struct - population archive
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: createMap, nicheCompete

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 07-Jun-2016

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