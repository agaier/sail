function dragF = velo_openFoamResult(x, stlFileName,openFoamFolder)
dragF = nan;

% Create STL
[valid] = expressVelo(x, 'export',true,'filename', stlFileName);
if ~valid; disp('Invalid shape'); return;end

% Run SnappyHexMesh and OpenFOAM
system(['(cd '   openFoamFolder '; ./Allclean)']);
system(['touch ' openFoamFolder 'start.signal']);

% Wait for results
resultOutputFile = [openFoamFolder 'forces.dat'];
tic;
while ~exist([openFoamFolder 'mesh.timing'] ,'file')
    display(['Waiting for Meshing: ' seconds2human(toc)]);
    pause(30);
end
display(['|----| Meshing done in ' seconds2human(toc)]);

tic;
while ~exist([openFoamFolder 'all.timing'] ,'file')
    display(['Waiting for CFD: ' seconds2human(toc)]);
    pause(30);
end
display(['|----| CFD done in ' seconds2human(toc)]);

if exist(resultOutputFile, 'file')
    display(resultOutputFile);
    raw = importdata(resultOutputFile);
    dragF = eval(raw{end}(16:27));
    if dragF > 12 % Sanity check to prevent model destruction
        disp(['|-------> Drag Force calculated as ' num2str(dragF) ' (returning NaN)']);
        dragF = nan; 
        save([openFoamFolder  'error' int2str(randi(1000,1)) '.mat'], 'x');
    end
else
    save([openFoamFolder  'error' int2str(randi(1000,1)) '.mat'], 'x');    
end

system(['touch ' openFoamFolder 'done.signal']);
