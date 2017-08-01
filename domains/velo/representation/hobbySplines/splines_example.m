%% Hobby's splines, example
%
% This file demonstrates some examples of drawing Bezier curves
% in Matlab using Hobby's algorithm for choosing control points
% based on curvature and tension.

%% Simple examples

% Create a new figure:
hfig = figure(1);
set(hfig,'color',[1 1 1],'name','Spline example');
clf;

% For clarity, define points separately:
points = {...
 [0 0],[1 1],[2,0],...
};
hobbysplines(points,'debug',true,'cycle',true);

% Experiment with `tension'.
% Note the default creates roughly circular plots.

points = {[1 0],[1 1],[0 1],[0 0]};
hobbysplines(points,'debug',true,'cycle',true,'offset',[3 0]);
hobbysplines(points,'debug',true,'tension',0.75,'cycle',true,'offset',[3 0],'linestyle','.');
hobbysplines(points,'debug',true,'tension',1.5 ,'cycle',true,'offset',[3 0],'linestyle','-.');
hobbysplines(points,'debug',true,'tension',2.0 ,'cycle',true,'offset',[3 0],'linestyle','--');

t = linspace(0,2*pi,30);
plot(3.5+1/sqrt(2)*cos(t),0.5+1/sqrt(2)*sin(t),'r.','MarkerSize',10)% a "real" circle

axis equal
axis off

%% Example with more points
%
% This is supposed to also test out the various possibilities of optional
% arguments.

hfig = figure(2); clf;
set(hfig,'color',[1 1 1],'name','Spline example');

points = {
  {[0 0] '' 0.7 0.7},   ... 1
  [0.7 0.8],            ... 2
  {[0.8 2] 45},         ... 3
  {[1 4] '' '' 0.5},    ... 4
  [0 5],                ... 5 
  {[-1 3.5] '' 0.6 ''}, ... 6
  [-0.8 2],             ... 7
  [-0.8 1]               %  8
};
hobbysplines(points,'debug',true,'tension',2);

axis equal
axis off

%% 3D

hfig = figure(3);
set(hfig,'color',[1 1 1],'name','3D spline example');
clf; hold on

points = {...
 [0 0 0],[1 1 1],[2 0 0],[1 -1 1]...
};
hobbysplines(points,'debug',true,'cycle',true);

points = {...
 {[0 0 0] '' 3},...
 {[1 1 1] [0 1 0] 0.75 2},...
 {[2 0 0] [0 0 -1] 1},...
 {[1 -1 1] '' 0.75}...
};
Q = hobbysplines(points,'debug',true,'cycle',true,'color','red');

axis equal
view(3)


