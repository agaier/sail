function d = velo_Domain(varargin)
%velo_Domain - Velomobile Domain Parameters 
% Returns struct with default for all settings of velomobile domain
% including hyperparameters, and strings indicating functions for
% representation and evaluation. Direct parameter or free form deformation
% encodings can be chosen.
%
% Syntax:  d = velo_Domain('encoding',ENCODING,'nCases',NCASES);
%
% Example: 
%    d = velo_Domain('encoding','ffd'  ,'nCases',10)
%    output = sail(sail,d);
%    d = velo_Domain('encoding','param','nCases',2)
%    output = sail(sail,d);
%
%
% See also: sail, runSail

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Oct 2017; Last revision: 02-Oct-2017
%------------- Input Parsing ------------
parse = inputParser;
parse.addOptional('encoding', 'ffd');
parse.addOptional('nCases'  , 1);

parse.parse(varargin{:});
encoding = parse.Results.encoding;
nCases   = parse.Results.nCases;
%------------- BEGIN CODE --------------

d.name = ['velo_' encoding];
rmpath( genpath('domains'));
addpath(genpath('domains/velo/'));

% - Scripts 
% Common to any representations
d.preciseEvaluate   = 'velo_PreciseEvaluate';    %
d.categorize        = 'velo_Categorize';         %
d.createAcqFunction = 'velo_CreateAcqFunc';      %
d.validate          = [d.name '_Validate'];

% - Genotype to Phenotype Expression
% Any representation should produce a fv struct and NX3 meshpoints
d.dof = 16;
base = 0.5+zeros(1,d.dof);
switch encoding
    case 'ffd'
        [~, ~, d.FfdP] =  velo_ffd_Express(base,'veloBase.stl');
        d.express  = @(x) velo_ffd_Express(x, d.FfdP);
        d.varCoef  = 1e0; % variance weight
        
    case 'param'
        load('paramPtIndx.mat','LOCB','slimF');
        d.repParams.LOCB    = LOCB; d.repParams.slimF   = slimF;
        load('patchTE.mat','vTE','fTE');
        d.repParams.vTE     = vTE;  d.repParams.fTE     = fTE;
        
        d.express  = @(x) batchExpressVelo(x, d.repParams);
        d.varCoef  = 1e0; % variance weight
    otherwise
        warning('No valid encoding defined');
end
d.base.fv   = d.express(base);
d.base.mesh = d.base.fv.vertices;

% - Alternative initialization [ TODO ]
d.loadInitialSamples = false;
d.initialSampleSource= '#notallFfdvelos.mat';

% - Feature Space
% Map borders
d.featureRes = [16 16];
d.nDims      = length(d.featureRes);
d.featureLabels = {'Volume', 'Curvature'}; % {X label, Y label}
d.extraMapValues = {'dragForce','confidence'};

% Domain Specific
%   Feature Borders
d.featureMin = [0.25  2.5];
d.featureMax = [0.65  4.0];

%   Curvature Calculation (stl specific
[d.curvSecIds.xz,d.curvSecIds.yz,d.curvSecIds.yx] = getCurvatureIds(...
    d.base.mesh, [10 16 22], [1 17 18], [36 16 4], 'doPlot',false);


% - GP Models
d.gpParams(1)= paramsGP(d.dof); % Drag Force

% Acquisition function
d.muCoef  = 1;   % mean weight 

% - Visualization
color8 = parula(8);
d.view = @(x) patch('Faces',x.faces,'Vertices',x.vertices,...
                    'FaceColor',color8(3,:),'FaceAlpha',0.35);
                
%% Precise Evaluation
if nargin < 1; nCases = 10; end
d.caseStart = 1;
d.nCases = nCases;
d.nVals = 1; % # of values of interest, e.g. dragForce (1), or cD and cL (2)

% Cluster
% % Cases are executed and stored here (cases are started elsewhere)
 d.openFoamFolder = ['/scratch/agaier2m/sailCFD/']; 
% - There should be a folder called 'case1, case2, ..., caseN in this
% folder, where N is the number of new samples added every iteration.
% - Each folder has a shell script called 'caserunner.sh' which must be
% run, this will cause an instance of openFoam to run whenever a signal is
% given (to allow jobs to be run on nodes with minimal communication).

%% Local
% TODO: make script that creates folders and runs caserunners
%d.openFoamTemplate = ['~/Code/ffdSail/domains/' d.name '/pe/templateCase_4core'];
%
%% Cases are executed and stored here
%d.openFoamFolder = ['~/Code/ffdSail/domains/' d.name '/pe/'];
%
%for iCase = 1:d.nCases
%    system(['cp -r ' d.openFoamTemplate ' ' d.openFoamFolder 'case' int2str(iCase)]); 
%    %system(['(cd ' d.openFoamFolder 'case' int2str(iCase) '; ./caseRunner.sh &)']); 
%end
%
%system(['(cd ' d.openFoamFolder ' && ./startCaseRunners.sh)']);

% %------------- END OF CODE --------------




















