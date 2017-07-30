function [figHandle, imageHandle] = viewMap(mapMatrix,p, varargin)
%computeFitness - Computes fitness with penalties from drag, lift, area
%
% Syntax:  fitness = computeFitness(drag, lift, initialFoils)
%
% Inputs:
%   samples - [NXM]    - sample genome
%   fitness - [NX1]    - fitness values
%   p       -             - parameter struct
%
% Outputs:
%   bestIndex - [1XN] - index of best individuals per cell
%
%
% Example:
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: computeFitness,  createMap

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jun 2016; Last revision: 07-Jun-2016

%------------- BEGIN CODE --------------

% For nicer publishing
if isempty(varargin);  yOffset = [0.5 -0.0 0];
else                   yOffset = varargin{1};
end

imgHandle = imagesc(flip(mapMatrix)); fitPlot = gca;
set(imgHandle,'AlphaData',~isnan(imgHandle.CData)*1)
xlab = xlabel(strcat(num2Parsec(p.featureIndx(2)),'\rightarrow'));
ylab = ylabel(['\uparrow' num2Parsec(p.featureIndx(1)) ]);
set(ylab,'Rotation',0,'Position',get(ylab,'Position')-yOffset)



xticklabels = num2str(p.edges{2}',2);
if length(xticklabels)>10
    keep = false(1,length(xticklabels));
    keep(1:round(length(xticklabels)/10):length(xticklabels)) = true;
    xticklabels(~keep,:)= ' ';
end

yticklabels = num2str(p.edges{1}(end:-1:1)',2);
if length(yticklabels)>10
    keep = false(1,length(yticklabels));
    keep(1:round(length(yticklabels)/10):length(yticklabels)) = true;
    yticklabels(~keep,:)= ' ';
end
xticklabels = {}; yticklabels = {};
set(fitPlot,...
    'XTickLabel',xticklabels,...
    'XTick', linspace(0.5,p.featureRes(2)+0.5,p.featureRes(2)+1), ...
    'YTickLabel',yticklabels,...
    'YTick', linspace(0.5,p.featureRes(1)+0.5,p.featureRes(1)+1),...
    'xgrid', 'on', 'ygrid', 'on', 'gridlinestyle', '-',...
    'xcolor', 'k', 'ycolor', 'k'...
    )

colorbar;
axis square
figHandle = fitPlot; imageHandle = imgHandle;

%------------- END OF CODE --------------