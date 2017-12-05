function velo_hpcSail(encoding, nCases, startCase)
% Runs SAIL velomobile optimization on cluster - [RUN THROUGH QSUB]
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Oct 2017; Last revision: 05-Oct-2017

%------------- BEGIN CODE --------------
disp([encoding nCases startCase]);

%% Parallelization Settings
%parpool(12);
% Ensure Randomness of Randomness
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));

% Create Temp Directory for Multithreading
tmpdir = getenv('TMPDIR');
if isempty(tmpdir);tmpdir='/tmp';end
myCluster.JobStorageLocation  = tmpdir;
myCluster.HasSharedFilesystem = true;

%% Add all files to path
addpath(genpath('~/Code/ffdSail/'));
addpath(genpath('~/Code/matlabExtensions/'));
cd ~/Code/ffdSail

nRuns = 2;
for iRun = 1:nRuns

%% Algorithm hyperparameters 
	p = sail;               % loads default hyperparameters
	 p.nInitialSamples   = 200;   
	 p.nAdditionalSamples= 10;    
	 p.nTotalSamples	 = 1000;       
	  
	 p.nChildren         = 2^7;
	 p.nGens             = 2^8;
	 
	 p.display.illu      = false;  
	 
	 p.data.mapEval      = false;   % produce intermediate prediction maps?
	 p.data.mapEvalMod   = 250;      % how often? (in samples)     
     p.data.predMapRes   = [25 25];  
	 
% Domain hyperparameters 
d = velo_Domain('encoding',encoding,'nCases',nCases);
d.featureRes = [25 25];
d.caseStart = startCase;

% Use Dummy Evaluation 
d.preciseEvaluate = 'velo_DummyPreciseEvaluate';
 
%% Run SAIL
runTime = tic;
disp('Running SAIL')
output = sail(p,d);
disp(['Runtime: ' seconds2human(toc(runTime))]);

%% Create New Prediction Map from produced surrogate

% Adjust hyperparameters
p.nGens = 2*p.nGens;
 
predMap = createPredictionMap(...
            output.model,...               % Model for evaluation
            output.model{1}.trainInput,... % Initial solutions
            p,d,'featureRes',p.data.predMapRes);     % Hyperparameters
               
save(['sail' encoding int2str(iRun) '.mat'],'output','p','d','predMap');

foundDesigns = reshape(predMap.genes,[p.data.predMapRes(1)*p.data.predMapRes(2),16]);
trueFit = feval(d.preciseEvaluate,foundDesigns,d); %#ok<NASGU>

save(['sail' encoding int2str(iRun) '.mat'],'output','p','d','predMap','trueFit');
end

%------------- END OF CODE --------------
