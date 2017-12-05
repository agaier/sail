%addAllToPath - This function adds all folders above it to the path
%
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Oct 2017; Last revision: 09-Oct-2017

%------------- BEGIN CODE --------------
% Clean up workspace and add relevant files to path
currentPath = mfilename('fullpath');
addpath(genpath(currentPath(1:end-length(mfilename))));
addpath(genpath('~/Code/matlabExtensions/'));


