%% Get STL point order
[f,v] = stlread('veloBase.stl');

% Get vertices of mesh
vert  = matFfd(zeros(1,16));

% Remove duplicate vertices in original stl
[slimV, slimF] = patchslim(v,f);

% Create mapping from our vertices to stl vertices
[~,LOCB] = ismembertol(slimV,vert,'ByRows',true);
face        = slimF;
vertLookup  = LOCB;

vert = vert(LOCB,:);
FV.faces = face;
FV.vertices = vert;