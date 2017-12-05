function [meanCurvature] = getTotalCurvature(velo, curvSecIds)
%getTotalCurvature - Returns total curvature of a set of 2D lines
%
% Syntax:  [totalCurvature] = getTotalCurvature(velo, curvSecIds)
%
% Inputs:
%    velo       - [Npoints X 3] - X,Y,Z coordinates of each point in design
%    curvSecIds - [struct]      - Ids of points in line for curvature
%           .x  - [nLines X xPts]
%           .y  - [nLines X yPts]
%
% Outputs:
%    totalCurvature - [scalar] - Sum of curvature of all lines in 2D
%
% Example: 
%    d = veloFfd_Domain; % for point IDs
%    [fv, ffdP, pts] = matVecFfd(rand(1,16));
%    totalCurv = getTotalCurvature(squeeze(pts(1,:,:)),d.curvSecIds)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Sep 2017; Last revision: 29-Sep-2017

%------------- Input Parsing ------------

%%------------- BEGIN CODE --------------
% figure(2); clf; hold on;
% plot3X(velo,'.'); axis equal;

%% Get 2D lines
xzSec = curvSecIds. xz (1:size(curvSecIds. xz, 1),:);
yzSec = curvSecIds. yz (1:size(curvSecIds. yz, 1),:);
yxSec = curvSecIds. yx (1:size(curvSecIds. yx, 1),:);

twoDLine{1} = velo(xzSec(1,:), [1 3]);
twoDLine{2} = velo(xzSec(2,:), [1 3]);
twoDLine{3} = velo(xzSec(3,:), [1 3]);

twoDLine{4} = velo(yzSec(1,:), [2 3]);
twoDLine{5} = velo(yzSec(2,:), [2 3]);
twoDLine{6} = velo(yzSec(3,:), [2 3]);

twoDLine{7} = velo(yxSec(1,:), [1 2]);
twoDLine{8} = velo(yxSec(2,:), [1 2]);
twoDLine{9} = velo(yxSec(3,:), [1 2]);

%% Get length relative curvature and length of each line
curvature = nan(1,length(twoDLine));
for iLine = 1:length(twoDLine)
    lineCurv            = LineCurvature2D(twoDLine{iLine});
    lineDiff            = diff(twoDLine{iLine});
    lineLength          = sum (sqrt (sum (lineDiff.*lineDiff,2) ) );
    curvature(iLine)    = nanmean(abs(lineCurv)).*lineLength;
end

meanCurvature = mean(curvature);

%------------- END OF CODE --------------











