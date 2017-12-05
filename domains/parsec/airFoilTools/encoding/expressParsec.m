function [fullLine, ul, ll, parsecParams, p, handle] = expressParsec(p,range,xcoords)
%expressParsec - Returns coordinates and plots airfoil defined in PARSEC
%
% Syntax:  [coords]      = expressParsec(p)       % one matrix of coordinates
%          [top, bottom] = expressParsec(p)       % top and bottom separate
%
% Inputs:
%    p      - Vector of 12 parsec parameters
%    ________________________________________________________________________________
%   |      Range       |                                                             |
%   |------------------|-------------------------------------------------------------|
%   | 0.00375, 0.05    |   1) (rLeUp)  Leading edge radius of suction side           |
%   | 0.2625 , 0.6875  |   2) (Xup)    X coordinate of max Z value of suction side   |
%   | 0.0725 , 0.1875  |   3) (Zup)    Z coordinate of max Z value of suction side   |
%   |-0.75   , 0.25    |   4) (Z_XXup) Curvature of suction side                     |
%   | 0.005  , 0.04    |   5) (rLeLo)  Leading edge radius of pressure side          |
%   | 0.300  , 0.6     |   6) (Xlo)    X coordinate of max Z value of pressure side  |
%   |-0.012  ,-0.05875 |   7) (Zlo)    Z coordinate of max Z value of pressure side  |
%   |-0.81   ,-0.375   |   8) (Z_XXlo) Curvature of pressure side                    |
%   | 0.001  , 0.001   |   9) (dZ_Te)  Thickness of trailing edge                    | 
%   |-0.00   , 0.01    |  10) (Z_Te)   Z position of trailing edge                   |
%   |-6.0    ,-2.0125  |  11) (a_Te)   Upper trailing edge angle (degrees)           |
%   | 2.5    , 11.413  |  12) (b_Te)   Lower trailing edge angle (degrees)           |
%   |__________________|_____________________________________________________________|
%
% [TODO]
%    vargin - number of points to express    [set default]
%    vargin - ratio of extra points at edges [set default]
%    vargin - any value to also plot [change to line style, etc.]
%    vargin - upper/lower seperate (BOOL)
%
% Outputs:
%    cartesianCoordinates  - [2XN] cartesian coordinates of 
%            OR
%    upperCoords           - [2X(N/2)] cartesian coordinates of top side
%    lowerCoords           - [2X(N/2)] cartesian coordinates of bottom side
%
% Example: 
%        rLeUp  Xup    Zup   Z_XXup  rLeLo  Xlo    Zlo      Z_XXlo Z_Te dZ_Te a_Te    b_Te
%    p = [0.01  0.35  0.0550 -0.350  0.010  0.45    0.006   -0.20    0.0   0.001  -6.0    0.05 ]
%    p = [0.017 0.35  0.0791 -0.645  0.008  0.17   -0.0338  -0.695   0.0   0.001  -5.88   14.9]
%    coords = expressParsec(p);axis([0 1 -0.08 0.2])
%
% Other m-files required: solveParsec
% Subfunctions: none
% MAT-files required: none
%
% See also: solveParsec

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 3-May-2016

%------------- BEGIN CODE --------------
%% Scale input
if nargin ==1
    range = ones(2,12);
end

nPset = size(p,1);
b = range(2,:)-range(1,:);
c = range(1,:);

rangeScale = @(x)   x.*repmat(b,nPset,1)+repmat(c,nPset,1);
parsecParams = rangeScale(p);

%% Compute airfoil polynomial
for iPset = 1:nPset
    a(:,iPset) = solveParsec(parsecParams(iPset,:));
end

%% X coordinates
if nargin < 3               % Default
     spacing = cosspace(0,1,200);
     xx_suc = spacing(end:-1:1);
     xx_pre = spacing;
else
    if size(xcoords,2) == 1 % Number of Points
        spacing = cosspace(0,1,xcoords);
        xx_suc = spacing(end:-1:1);
        xx_pre = spacing;
    else                    % X coordinates
        if size(xcoords,1) < 2
            xx_suc = xcoords;
            xx_pre = xx_suc;
        else                % Upper and lower line x coordinates
            xx_suc = xcoords(1,:);
            xx_pre = xcoords(2,:);
        end
    end
end

%% Get airfoil coordinates from PARSEC polynomial
if nPset > 1 % Vectorized Expression
    
    % Prep for vectorized matrices
    xx_pre = repmat(xx_pre,nPset,1);
    xx_suc = repmat(xx_suc,nPset,1);
    a = repmat(a,1,1,200);
    
    yy_suc = real(  squeeze(a(1, :,:)).*xx_suc.^(1/2) + ...
        squeeze(a(2, :,:)).*xx_suc.^(3/2) + ...
        squeeze(a(3, :,:)).*xx_suc.^(5/2) + ...
        squeeze(a(4, :,:)).*xx_suc.^(7/2) + ...
        squeeze(a(5, :,:)).*xx_suc.^(9/2) + ...
        squeeze(a(6, :,:)).*xx_suc.^(11/2) ...
        );
    
    yy_pre = real(  squeeze(a(7, :,:)).*xx_pre.^(1/2) + ...
        squeeze(a(8, :,:)).*xx_pre.^(3/2) + ...
        squeeze(a(9, :,:)).*xx_pre.^(5/2) + ...
        squeeze(a(10,:,:)).*xx_pre.^(7/2) + ...
        squeeze(a(11,:,:)).*xx_pre.^(9/2) + ...
        squeeze(a(12,:,:)).*xx_pre.^(11/2) ...
        );
    
    ul(1,:,:) = xx_suc';
    ul(2,:,:) = yy_suc';
    
    ll(1,:,:) = xx_pre';
    ll(2,:,:) = -yy_pre';
    
    fullLine = horzcat(ul,ll);
    
else
    % Single Foil
    yy_suc = real(a(1)*xx_suc.^(1/2) + ...
        a(2)*xx_suc.^(3/2) + ...
        a(3)*xx_suc.^(5/2) + ...
        a(4)*xx_suc.^(7/2) + ...
        a(5)*xx_suc.^(9/2) + ...
        a(6)*xx_suc.^(11/2) ...
        );
    
    yy_pre = real(a(7)*xx_pre.^(1/2) + ...
        a(8)*xx_pre.^(3/2) + ...
        a(9)*xx_pre.^(5/2) + ...
        a(10)*xx_pre.^(7/2) + ...
        a(11)*xx_pre.^(9/2) + ...
        a(12)*xx_pre.^(11/2) ...
        );
    ul = [xx_suc; yy_suc];
    ll = [xx_pre;-yy_pre];
    
    fullLine = [ul,ll];
end
