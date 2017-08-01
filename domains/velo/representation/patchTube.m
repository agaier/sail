function [allV,f] = patchTube(section)
% Returns 3D patches in vertice/faces by 
% connecting sections that vary in the Z dimension
%
% Section should be cells that are [3 X (number of corners)]
% 
% Returns allV [N X 3], and faces [M X (number of corners)]

%%
section(cellfun('isempty',section)) = []; % Remove empty cells
nCorners = size(section{1},2);
nSection = length(section);

allV = [];
f = [];

for iSection = 1:nSection-1
    for iCorner = 1:nCorners-1
        v = horzcat(...
            section{iSection}  (:,[1+mod(iCorner-1,nCorners) , 1+mod(iCorner  ,nCorners)]),    ...
            section{iSection+1}(:,[1+mod(iCorner  ,nCorners) , 1+mod(iCorner-1,nCorners)])    ...
            );
        allV = [allV v];
        nF = length(f(:));
        f = [f; nF+1:nF+size(v,2)];        
    end
end
allV = allV';
