function [xzSectionIds, yzSectionIds, yxSectionIds] = getCurvatureIds(mesh, yCurveIds, xCurveIds, zCurveIds, varargin)

%getCurvatureIds - Gets point IDs for selected 2D lines of 3D shape for computing curvature 
% Some parameters (start, space, nSec) are particular for the velomobile
% stl file included in the velo and veloFfd domains.
%
% Syntax:  [d.curv_xSecIds,d.curv_ySecIds] = getCurvatureIds(xSectionNumbers, ySectionNumbers, varargin)
%
%
% Inputs:
%    xSectionNumbers - [1 X nLines] Which xSection lines to return
%    ySectionNumbers - [1 X nLines] Which ySection lines to return
%
% Outputs:
%    xSecIds - [nLines X nPointsPerLine] - Description
%    ySecIds - [nLines X nPointsPerLine] - Description
%
% Example: 
%    [d.curv_xSecIds,d.curv_ySecIds] = getCurvatureIds([10 16 22], [39 27 17],'doPlot',true);
%
% Other m-files required: matVecFfd
% Subfunctions: none
% MAT-files required: none
%
% See also: matVecFfd, getVeloFeature

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Sep 2015; Last revision: 29-Sep-2017

%------------- Input Parsing ------------
parse = inputParser;
parse.addRequired('yCurveIds');
parse.addRequired('xCurveIds');
parse.addRequired('zCurveIds');
parse.addOptional('doPlot', false);

parse.parse(xCurveIds, yCurveIds, zCurveIds, varargin{:});
% xCurveIds = parse.Results.xCurveIds;
% yCurveIds = parse.Results.yCurveIds;
% zCurveIds = parse.Results.zCurveIds;
doPlot          = parse.Results.doPlot;
color8 =parula(8);
xy = color8(7,:);
yz = color8(6,:);
xz = color8(5,:);

%------------- BEGIN CODE --------------

%% Get Base Shape
pts = squeeze(mesh);
vPlot = @(x,varargin) plot3(x(:,1), x(:,2), x(:,3),varargin{:});

% STL specific parameters
start = 1; %start = 93;
space = 90; %space = 46;
nSec  = 29; %nSec  = 29;

%% Identify lines on Y curves side
for iSec = 1:nSec
    ySecIds(iSec,:) = start+(iSec-1)*space : start-1+space*iSec;   
end

%% Grab a selected Y curve lines
ySections_full = ySecIds(yCurveIds,:);

for iSec=1:size(ySections_full,1)
    % Take half of the ySection
    ids = ySections_full(iSec,:);
    ids = ids(1:end/2);
    
    % Take the side and sort it by Z
    side = ids(1:28);
    [~,sortI] = sortrows(pts(side,:),3);
    yzSectionIds(iSec,:) = side(sortI);
end

if doPlot
    %figure(1); 
    figure(4);
    hold on;
    for iSec = 1:size(yzSectionIds,1)
        vPlot(pts(yzSectionIds(iSec,:),:),'-','Color',xy,'LineWidth',5)
    end
    %title('Selected Lines');
end

%% Identify lines along X curve
for iSec=1:space
    xSecIds(iSec,:) = iSec+start: space: iSec+(space*nSec);
end

%% Grab a selected few X Curve lines
xzSectionIds = xSecIds(xCurveIds,:);

if doPlot
    %figure(2); 
    figure(4);
    hold on
    for iSec=1:size(xzSectionIds,1)
        ids = xzSectionIds(iSec,:);
        vPlot(pts(ids,:),'-','Color',xz,'LineWidth',5)
    end
end

%% Grab a selected few Z Curve lines
yxSectionIds = xSecIds(zCurveIds,:);

if doPlot
    %figure(3); 
    figure(4);
    hold on;
    for iSec=1:size(yxSectionIds,1)
        ids = yxSectionIds((iSec),:);
        vPlot(pts(ids,:),'-','Color',yz,'LineWidth',5)
    end
    view(-60,20)
end

%------------- END OF CODE --------------