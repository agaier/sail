%% Demo Velo.m -- demonstrates simple velomobile representation

%% Parameters
load('parsecRange');

valid = false;
while ~valid
    openFoamFolder = '~/Code/veloDesign/openfoamDesktop/';
    %stlFileName = [openFoamFolder 'constant/triSurface/parsecWing.stl'];
    stlFileName = ['test.stl'];
    
    % Create Design
    p = rand(16,1);
    [valid, shape,~] = expressVelo(p,'nPoints',16,'plotting',true,'filename', stlFileName);
end

%% Mesh and Simulate
simulate = true;
if simulate
    stlFileName = [openFoamFolder 'constant/triSurface/parsecWing.stl'];
    cD = preciseEval(p, stlFileName, openFoamFolder)
end

%% Sample shape
% p = [
%     % Z Curve (1-5)
%     naca0012.rLeUp;     % Width of nose
%     naca0012.Xup;       % Position of widest point
%     naca0012.Zup;       % Width of widest point
%     naca0012.Z_XXup;    % Curvature along Z
%     0.2;                % Width at back
%     % Y Curves
%     % -- Y Mid (6-10)
%     0.5000;             % Distance of Ridge from Center
%     naca2412.rLeUp;     % Leading Edge Radius  
%     naca2412.Xup;       % Position of tallest Point
%     naca2412.Zup;       % Height of tallest point
%     naca2412.Z_XXup;    % Curvature of Middle Curve
%     % -- Y Ridge (10-14)
%     naca2412.rLeUp;     % Leading Edge Radius  
%     naca2412.Xup;       % Position of tallest Point
%     naca2412.Zup;       % Height of tallest point
%     naca2412.Z_XXup;    % Curvature of Middle Curve
%     % -- X Rib (15-21)
%     0.2400;             % Top edge radius  
%     0.7930;             % Position of widest point
%     0.3350;             % Relative width of rib curve
%     0.5;                % Curvature of Rib
%     0.5000;             % Width of flat bottom
%     0.1271;             % TE alpha Angle
%     0.5;                % TE beta Angle
% ];
















