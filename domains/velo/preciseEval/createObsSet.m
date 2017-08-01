%% Design Space Sampling
clear;
addpath(genpath('../../sail_aiaa2017'));
addpath(genpath('../../matlabExtensions'))

nParams = 16;
nSample= 2000;
batchSize = 200;

% Create nSamples Valid Designs
validParams = [];
sobSet  = scramble(sobolset(nParams,'Skip',1e5),'MatousekAffineOwen');

nBatch = 0;
while (size(validParams,1) < nSample)
    startPt = 1+batchSize*nBatch;
    endPt = startPt+batchSize-1;
    sobCounter = startPt:endPt;
    inputSamples = sobSet(sobCounter,:);
    
    parfor i=1:batchSize
        valid(i) = expressVelo(inputSamples(i,:)',...
            'validateOnly',true);
    end
    
    validParams = [validParams; inputSamples(valid,:)]; %#ok<AGROW>
    nBatch = nBatch+1
end

validParams = validParams(1:nSample,:); %only as many as you need

params = validParams;
save('param.mat','params')

%% Create OpenFoam Cases
originalFolder = '~/Code/sail_aiaa2017/ofTemplates/hpc2_12/';
targetFolder   = '/scratch/agaier2m/sampleSet/';
save([targetFolder 'param.mat'],'params');

parfor i=1:nSample
    caseName = [targetFolder 'case' digitInt2str(i,4) '/'];
    stlFileName = [caseName 'constant/triSurface/parsecWing.stl'];
    system(['cp -r ' originalFolder ' ' caseName]);
    expressVelo(params(i,:),'plotting',false,'export',true,'filename', stlFileName);
    %createCase(validParams(i,:)', stlFileName, caseName);
    display(['Case ' digitInt2str(i,4) ' done.']);
end