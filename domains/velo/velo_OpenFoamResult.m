function dragF = velo_OpenFoamResult(x, stlFileName,openFoamFolder)
%velo_openFoamResult - Evaluates a single shape in OpenFOAM
%
% Syntax:  [observation, value] = af_InitialSamples(p)
%
% Inputs:
%    x              - Sample genome to evaluate
%    stlFileName    - Target to place expressed genome
%    openFoamFolder - OpenFOAM case folder
%
% Outputs:
%    dragF  - [1X1] drag force result
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Jun 2017; Last revision: 02-Aug-2017

%------------- BEGIN CODE --------------
dragF = nan;

% Create STL
stlwrite(stlFileName, x);

% Run SnappyHexMesh and OpenFOAM
[~,~] = system(['touch ' openFoamFolder 'start.signal']);

% Wait for results
resultOutputFile = [openFoamFolder 'forces.dat'];
tic;
while ~exist([openFoamFolder 'mesh.timing'] ,'file')
    display(['Waiting for Meshing: ' seconds2human(toc)]);
    pause(10);
    if (toc > 300); dragF = nan; return; end;
end
display(['|----| Meshing done in ' seconds2human(toc)]);

tic;
while ~exist([openFoamFolder 'all.timing'] ,'file')
    display(['Waiting for CFD: ' seconds2human(toc)]);
    pause(10);
    if (toc > 300); dragF = nan; return; end;
end
display(['|----| CFD done in ' seconds2human(toc)]);

if exist(resultOutputFile, 'file')
    display(resultOutputFile);
    raw = importdata(resultOutputFile);
    dragF = eval(raw{end}(16:27));
    if dragF > 30 % Sanity check to prevent model destruction
        disp(['|-------> Drag Force calculated as ' num2str(dragF) ' (returning NaN)']);
        dragF = nan; 
        save([openFoamFolder  'error' int2str(randi(1000,1)) '.mat'], 'x');
    end
else
    save([openFoamFolder  'error' int2str(randi(1000,1)) '.mat'], 'x');    
end

system(['touch ' openFoamFolder 'done.signal']);
[~,~] = system(['(cd '   openFoamFolder '; ./Allclean)']);

