function a=solveParsec(p)
%solveParsec- Returns PARSEC polynomial coefficinets
%
% Syntax:  a = solveParsec(p)
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
% Outputs:
%    a     - polynomial coefficients
%
% Example: 
%    p = [0.01 0.35 0.055 -0.35 0.01 0.45 -0.006 -0.20 0.0 0.001 -6.0 0.05]
%    coords = solveParsec(p);
%
% Other m-files required: none
% Subfunctions: getXmatrix
% MAT-files required: none
%
% See also: expressParsec

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 3-May-2016

%------------- BEGIN CODE --------------

rLeUp  = p( 1); % Leading edge radius of suction side
Xup    = p( 2); % X coordinate of max Z value of suction side
Zup    = p( 3); % Z coordinate of max Z value of suction side 
Z_XXup = p( 4); % Curvatures of suction side

rLeLo  = p( 5); % Leading edge radius of pressure side
Xlo    = p( 6); % X coordinate of max Z value of pressure side
Zlo    =-p( 7); % Z coordinate of max Z value of pressure side
Z_XXlo = p( 8); % Curvatures of pressure side

Z_Te   = p( 9); % Z position of trailing edge
dZ_Te  = p(10); % Thickness of trailing edge
a_Te   = p(11); % Upper trailing edge angle (degrees)
b_Te   = p(12); % Lower trailing edge angle (degrees)
    
Cup = getXmatrix(Xup);
Clo = getXmatrix(Xlo);

bup=[ Z_Te+(dZ_Te/2); Zup; tand(a_Te-(b_Te/2) );  0   ; Z_XXup; (sqrt(2*rLeUp))];
blo=[-Z_Te+(dZ_Te/2); Zlo; tand(a_Te+(b_Te/2) );bup(4); Z_XXlo; (sqrt(2*rLeLo))];

% Solve system of equations
a = [linsolve(Cup,bup); linsolve(Clo,blo)];

end



function xMat = getXmatrix(x)
% Build polynomial matrix

xMat = [
    ones(1,6)         ;
    
    x.^((1:2:11)./2)  ;
    
    (1:2:11)./2       ;
    
    ( 1/2)*x^(-1/2),...
    ( 3/2)*x^( 1/2),...
    ( 5/2)*x^( 3/2),...
    ( 7/2)*x^( 5/2),...
    ( 9/2)*x^( 7/2),...
    (11/2)*x^( 9/2);
    
    (-1/4)*x^(-3/2),...
    ( 3/4)*x^(-1/2),...
    (15/4)*x^( 1/2),...
    (35/4)*x^( 3/2),...
    (53/4)*x^( 5/2),...
    (99/4)*x^( 7/2);
    
    1,0,0,0,0,0  ];

end

%------------- END OF CODE --------------
