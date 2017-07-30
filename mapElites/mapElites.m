function [map, h] = mapElites(fitnessFunction,map,p, varargin)
%mapElites - Multi-dimensional Archive of Phenotypic Elites algorithm
%
% Syntax:  map = mapElites(fitnessFunction, map, p);
%
% Inputs:
%   fitnessFunction - function - returns fitness of vector of individuals
%   map             - function - initial solutions in F-dimensional map
%   p               - struct   - parameter struct
%
% Outputs:
%   map    - struct - population archive
%   h      - [1X2]  - axes handle, data handle
%
%
% See also: createChildren, computeFitness, getBestPerCell, updateMap

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 27-Jan-2017

%------------- BEGIN CODE --------------

% View Initial Map
h = [];
if p.display.illu
    figure(2); clf;
    [h(1), h(2)] = viewMap(map.fitness,p); title('Illumination Fitness')
end

iGen = 0;
while (iGen < p.nGens)
    %% Create and Evaluate Children
    % Continue to remutate until enough children which satisfy geometric
    % constraints are created
    children = [];
    while size(children,1) < p.nChildren
        newChildren = createChildren(map,p);
        validInds = validateChildren(newChildren,p);
        children = [children ;newChildren(validInds,:)] ; %#ok<AGROW>
    end
    children = children(1:p.nChildren,:);
    [fitness, drag, lift] = fitnessFunction(children);

    %% Add Children to Map   
    [replaced, replacement] = nicheCompete(children,fitness,map,p);
    map = updateMap(replaced,replacement,map,fitness,drag,lift,children);  
                       
    %% View New Map
    if p.display.illu && ~mod(iGen,p.display.illuMod)
        set(h(2),'CData',flip(map.fitness),...
            'AlphaData',~isnan(flip(map.fitness)))
        colormap(h(1),parula(16));
        drawnow;
    end
    
iGen = iGen+1; if ~mod(iGen,100);disp([char(9) 'Illumination Generation: ' int2str(iGen)]);end;
end



%------------- END OF CODE --------------