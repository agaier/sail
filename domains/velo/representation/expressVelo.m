function [validity, finalPatch, feature, lRef, aRef] = expressVelo(p, varargin)
%% Converts set of parameters to STL velomobile
% %---------------------------------%
%    1    'Top: Leading Edge Radius'
%    2    'Top: Pos of Tallest Point'
%    3    'Top: Tallest Point'
%    4    'Top: Curvature'
%    5    'Mid: Leading Edge Radius'
%    6    'Mid: Pos of Tallest Point'
%    7    'Mid: Tallest Point'
%    8    'Mid: Curvature'
%    9    'Ridge: Leading Edge Radius'
%    10   'Ridge: Pos of Tallest Point'
%    11   'Ridge: Relative Height'
%    12   'Rib: Leading Edge Radius'
%    13   'Rib: Pos of Tallest Point'
%    14   'Rib: Tallest Point'
%    15   'Rib: Curvature'
%    16   'Rib: TE Alpha'
% %---------------------------------%
%% Input Parsing
parse = inputParser;
parse.addRequired('p');
parse.addOptional('nPoints' ,32);
parse.addOptional('fileName','test.stl');
parse.addOptional('plotting',false);
parse.addOptional('meshOnly',true);
parse.addOptional('export'  ,false);
parse.addOptional('validateOnly', false)
parse.addOptional('categoryOnly',false);

parse.parse(p,varargin{:});
nPoints     = parse.Results.nPoints;
fileName    = parse.Results.fileName;
doPlot      = parse.Results.plotting;
meshOnly    = parse.Results.meshOnly;
doExport    = parse.Results.export;
validateOnly= parse.Results.validateOnly;
categoryOnly= parse.Results.categoryOnly;

finalPatch.vertices = nan;
finalPatch.faces = nan;
validity = true;
feature = [nan nan];

% if categoryOnly % Ribs are for volume and curvature, detail is not necessary
%     nPoints = nPoints/4;
% end

%% Range Nonsense
scale = 2.5;    % Length in meters
lRef  = scale;  % Assumes all velos are same length

% NACA as approximated by CMA-ES
naca0012 = [0.27735 0.33481 0.12472 0.57311,...
            0.27734 0.33481 0.87528 0.57313,...
            0.50000 0.36203 0.09295 0.50001];
                    
naca2412 = [0.35455 0.39801 0.24401 0.51320,  ...
            0.21564 0.20433 0.98537 0.59222,  ...
            0.49968 0.36209 0.09329 0.69849];

parRange =[0.001 0.1 0.04 -1.5 0.001 0.1 -0.20 -1.5 -0.05 0.001 -10 -20
           0.050 0.7 0.20  0.3 0.050 0.7 -0.04  0.3  0.05 0.005  10  20];
       
% Found Range
mn =[ 0.20; 0.20; 0.15; 0.00; 0.00; 0.10; 0.15; 0.00; 0.25; 0.15; 0.00; 0.00; 0.25; 0.15; 0.00; 0.00;];
mx =[ 1.50; 0.90; 0.75; 1.10; 1.00; 0.95; 1.00; 1.20; 0.95; 0.75; 1.00; 1.10; 0.95; 1.00; 5.00; 0.75;];

p = p(:).*(mx-mn)+mn; % make sure you are scaling vectors

%% Example shape based only on naca0012 and naca2412

for foldingParameterAssignment = 1:1
%% -- Z Curve (Top) -- p(1:5)       :: [ Rle, X, Z, Zxx, dZte ]
% We use a symmetrical wing for the top profile, defining only the leading
% edge, height, width, curvature, and thickness at the end.  For the 
% remainder of the parameters we use the values of a NACA0012 airfoil.
topParsec       = naca0012;
topParsec(1)= p(1); topParsec(2)= p(2); topParsec(3)= p(3); topParsec(4) = p(4);     
topParsec(5) = p(1); topParsec(6) = p(2); topParsec(7) = p(3); topParsec(8) = p(4);
topParsec(10) = 4.2; 

%% Ridge Distance --  p(6:7)        :: [ ridgeDist, ridgeLength ]
% A raised ridge appears on each side of the velomobile to allow for the
% rider to pedal, the distance of these ridges is defined as a percentage
% of the width of the velomobile (edgeDist). The ridges follow curves
% identical to the top curve, with reduced size. These ridges end when they
% are no longer needed for the riders knees, at a percentage (edgeLength)
% of the velomobile body.
edgeDist = 0.5;

%% Middle Curve (Side) -- p(8:14)    :: [ Rle, X, Z, Zxx, Alpha, Beta, dZte ]
% The middle curve extends from the front of the velomobile to the end, and
% gives the general side view shape. It is characterized by a large dZte
% value, which indicates the width of the velomobile at the end. The angle
% of the end of the velomobile is also determined by this curve (alpha and
% beta). In the front portion of the velomobile, this curve acts as the
% middle control point of a spline whose end points are the knee ridges.
cMidParsec       = naca2412;
cMidParsec(1)= p(5);    cMidParsec(2)  = p(6);     
cMidParsec(3)  = p(7);    cMidParsec(4)= p(8);
cMidParsec(10) = 20;

%% Ridge Curve (Side) -- p(15:22)    :: [ Rle, X, Z, Zxx, Alpha, Beta, dZte ]
% The ridge curve extends from the front of the velomobile to 'edgeLength'
% percent of the chord. After 'edgeLength' it joins the middle curve with a
% Y value of 0.
cRidgeParsec         = naca2412;
cRidgeParsec(1)  = p(9);    cRidgeParsec(2)  = p(10);    
cRidgeParsec(3)    = cMidParsec(3) * 0.85+p(16)*.35; % Ridges can be between 85% and 120% hight of middle)
cRidgeParsec(4)  = 0.5;    
cRidgeParsec(10)     = cMidParsec(10);

%% Bottom Curve (Side) -- p(22:28)  :: [ Rle, X, Z, Zxx, dZte, alpha, beta ] 
% This curve defines the center line in the bottom, in addition to the four
% main curve characteristics, the thickness of the back and angle of
% trailing edge is included.
cBotParsec         = naca2412;
cBotParsec(10)   = 20;

%% -- X Curves (Front) -- p(29: ) :: Rle, X, Z, Zxx, dZte, alpha, beta ] 
% 'Ribs' which connect the Y Curves are produced in the X-Dimension. The
% top ridges and center are connected with a spline. An additional X curve
% (Front) connects the ridges to the bottom curve. This curve is scaled and
% aligned to have a width determined by the Z Curve (Top), and connect the
% ridge and bottom. The distance of the trailing edge of this curve from
% zero determines the width of a flat bottom, created by connecting the end
% of the X Curve to the Bottom Curve.
cFrontPar   = [ p(12)   p(13)  p(14)    p(15) ...
                p(12)   p(13)  p(14)    p(15) ... % This line doesn't matter as we only take half of the wing
                0.2   0      p(16)    0.3750 ] ;    

end

%% Prep
% Helper Functions
expressMethod = @(p,xVals) expressParsec(p,parRange,xVals);
express = @(p) expressMethod(p,nPoints);

%% Produce Curves
% -- Z Curves (Top View) --
[cTop,valid(1)] = express(topParsec);
cTop = [cTop;zeros(1,length(cTop))];
% Minimum Width at front (08% - 40%)
minWidth = 0.04;
valid(1) = all(abs(cTop(2,(cTop(1,:)>0.08)&(cTop(1,:)<0.40))) > minWidth);

% wheelIndx = intersect(find(cTop(1,1:end/2)>0.3), find(cTop(1,1:end/2)<0.4));
% wheelWidth = max(cTop(2,wheelIndx));
    
% -- Y Curves (Side View) --
% Distance of ridges from center
cYedge = cTop(2,:) * edgeDist;
cYedge = -cYedge(1:end/2); %only need half

% Y - Middle Curve
[cMid, valid(2)] = express(cMidParsec);        cMid = cMid(:,1:end/2);     % Take only top curve
cMid = [cMid(1,:); zeros(1,length(cMid));cMid(2,:)]; % Y Center line

% Y - Ridge Curve
[cRidge, valid(3)] = express(cRidgeParsec);    cRidge = cRidge(:,1:end/2); % Take only top curve
cRidge = [cRidge(1,:); cYedge ;cRidge(2,:)];  % Y dim follows curve of body
kneeIndx = intersect(find(cRidge(1,:)>0.3), find(cRidge(1,:)<0.4));
%kneeHeight = max(cRidge(3,wheelIndx));

% Y - Bottom Curve
[cBot, valid(4)] = express(cBotParsec);        cBot = cBot(:,1:end/2);     % Take only top curve
cBot(1,:) = -cBot(1,:); % Under curve
cBot = [cBot(1,:); zeros(1,length(cBot));cBot(2,:)]; % Center bottom curve

% -- X Curves (Front) --
[cFront, valid(5)] = express(cFrontPar); cFront = cFront (:,1:end/2);   % Take only top curve
cRibBase  = [zeros(1,length(cFront));-cFront(2,:); -cFront(1,:)];

%% Bail Out if invalid or you don't need to express whole shape
if ~all(valid)
    aRef = nan;
    lRef = nan;
    validity = false;
    return 
end

if validateOnly;  return; end

%% Side Curve (Rib) in 3D at every section
norm    = @(x) (x-min(x))./(max(x)-min(x));
stretch = @(x,minimum,maximum) norm(x).*(maximum-minimum)+minimum;

RibSection = cell(1,nPoints); RibSectionReflect = RibSection; %Preallocate

if ~categoryOnly % Ribs are for volume and curvature, detail is not necessary
     sectionRange = 1:nPoints-1;
else
     sectionRange = 1:4:nPoints-1;    
end

for iSection = sectionRange
    % Each slice in Z is in the shape of X Curve, as bound by Y and Z Curves
    cFront(1,:) = cRibBase (1,:) +  cRidge(1,iSection);
    cFront(2,:) = stretch(cRibBase (2,:), cTop(2,iSection),-cRidge(2,iSection));
    cFront(3,:) = stretch(cRibBase (3,:),-cBot(3,iSection), cRidge(3,iSection));
    
    % Create Splines from mid points (top)
    ridgeTop = cFront(:,end);
    ridgeRefTop = [ridgeTop(1) -ridgeTop(2) ridgeTop(3)]';
    points = { cFront(:,end)',  cMid(:,iSection)', ridgeRefTop'};
    %splineTop = hobbysplines(points,'cycle',false,'resolution',nPoints/4); %TODO: edit to take n sections as parameter
    if categoryOnly
        splineTop = quick_hobbysplines(points,4); 
    else
        splineTop = quick_hobbysplines(points,nPoints/4);
    end
    
    % Create Splines from mid points (bottom)
    ridgeBot = cFront(:,1);
    ridgeRefBot = [ridgeBot(1) -ridgeBot(2) ridgeBot(3)]';
    points = { cFront(:,1)',  -cBot(:,iSection)', ridgeRefBot'};
    %splineBot = hobbysplines(points,'cycle',false,'resolution',nPoints/4); %TODO: edit to take n sections as parameter
    if categoryOnly
        splineBot = quick_hobbysplines(points,4); 
    else
        splineBot = quick_hobbysplines(points,nPoints/4);
    end
    
    % Middle Curves end in middle
    RibSection{iSection} = horzcat(splineBot{1}',cFront,splineTop{1}'); 
    RibSectionReflect{iSection}      =  RibSection{iSection};                   
    RibSectionReflect{iSection}(2,:) = -RibSection{iSection}(2,:);              
end

%% Assign area largest rib as Reference Area
%aRef = polyarea(RibSection{bigRibIndx}(2,:).*scale,RibSection{bigRibIndx}(3,:).*scale).*2;
%bigRib = [RibSection{bigRibIndx}(2,:).*scale;RibSection{bigRibIndx}(3,:).*scale];

%% -- Produce 3D Design From Ribs --
% Plot views
if categoryOnly
    [v,f] = patchTube([RibSection(1:end-1)]);% fliplr(RibSectionReflect(1:end-1))]);
else
    [v,f] = patchTube([RibSection(1:end-1) fliplr(RibSectionReflect(1:end-1))]);
end

% Connect points at trailing edge
% Find points on either end of TE
nVertices  = size(v,1);
teVertices = find(v(:,1) == 1);
%teVertices = find(v(:,1) == max(v(:,1)));
leftTeVertices = 1:4:teVertices(end/2);
rightTeVertices = fliplr( nVertices: -4 :nVertices-teVertices(end/2) ); % line up both sides

% Use opposite points as either end of spline
leftPts   = v(leftTeVertices ,:);
rightPts  = v(rightTeVertices,:);
nPts = length(rightPts);
middlePts = [1.01*ones(nPts,1) zeros(nPts,1) rightPts(:,3)];
%%
if ~categoryOnly
    for i=1:nPts
        pts = {leftPts(i,:), middlePts(i,:), rightPts(i,:)};
        TEspline{i} = hobbysplines(pts,'cycle',true,'resolution',nPoints/2,'tension',3);
        X{i} = [TEspline{i}{1}(:,1); TEspline{i}{2}(:,1)];
        Y{i} = [TEspline{i}{1}(:,2); TEspline{i}{2}(:,2)];
        Z{i} = [TEspline{i}{1}(:,3); TEspline{i}{2}(:,3)];
        if any(isnan(X{i}));        continue;    end
        TE{i} = [X{i} Y{i} Z{i}]';
    end
    
    [vTE,fTE] = patchTube(TE);
    [vTE,fTE] = patchslim(vTE,fTE);
    
    %% Close top and Bottom
    vertices = [TEspline{end}{1}; TEspline{end}{2}]; % (top)
    for Side = 1:2
        nVertices = length(vertices);
        vID = length(vTE)+(1:nVertices);
        vTE = [vTE; vertices];
        for i=1:1:nVertices/2
            fTE = [fTE; vID([i+1 i end-i+1 end-i])];
        end
        % (bottom)
        bottomEdge = (nPoints-2)/2;
        vertices = [TEspline{bottomEdge}{1}; TEspline{bottomEdge}{2}];
    end
    
    %% Combine Edge and Body
    f = [f;fTE+length(v)];
    v = [v;vTE];
end
%% ASSIGN FEATURES:
%-----------------%
% Curvature of Ribs
for i=1:length(RibSection)
    if ~isempty(RibSection{i})
        rib = [RibSection{i}(2,:).*scale;RibSection{i}(3,:).*scale];
        meanCurv(i) = nansum(abs(LineCurvature2D(rib')))./length(rib);
    end
end
allMeanCurv = sum(meanCurv)./sum(meanCurv>0);

% Volume of Shape
[~,volume] = convhull(v);

%feature(1) = ribCurve; feature(2) = midCurve;
%feature(1) = kneeHeight; feature(2) = curvature;
%feature(1) = kneeHeight; feature(2) = aRef;
feature(1) = volume*2; feature(2) = allMeanCurv;

% If we are just categorizing or validating this is enough
if categoryOnly; return; end
if ~doPlot && ~doExport; return; end
%------------------%
%% Plotting
if doPlot
    if ~meshOnly
        clf;
        Zview =     subplot(4,3,1);
        Yview =     subplot(4,3,2);
        Xview =     subplot(4,3,3);
        allSides =  subplot(4,3,[4:12]);
        
        subplot(Zview);
        plot([0 1], [0 0],'k--'); hold on;
        h=fPlot([cTop(1,1:end/2);  cTop(2,1:end/2)],'k'); h.LineWidth = 3;
        h=fPlot([cTop(1,1:end/2); -cTop(2,1:end/2)],'k'); h.LineWidth = 3;
        title('Z Curve (7 Params)');axis equal;grid on;
        subplot(Yview);
        h=fPlot([cMid(1,:); cMid(3,:)],'b'); hold on;   h.LineWidth = 3;
        h=fPlot([cRidge(1,:); cRidge(3,:)],'r:');       h.LineWidth = 3;
        h=fPlot(-[cBot(1,:); cBot(3,:)],'m');           h.LineWidth = 3;
        title('Y Curves (18 Params)');axis equal;grid on;
        subplot(Xview);
        h=fPlot([cRibBase(2,:); cRibBase(3,:)]);  title('X Curve (6 Params)');
        h.LineWidth = 3; h.Color = [0.7525 0.7384 0.3768]; axis square;grid on;
        subplot(allSides);
    end
        h = patch('Faces',f,'Vertices',v.*scale,...
            'EdgeColor','k','FaceColor','green','LineWidth',.01,'FaceAlpha',.25);
        view([-80, 13]);axis equal; grid on;
else
        h.Faces = f; h.Vertices = v;
end

%% Convert to STL
% Up to this point I defined patches as panels with 4 corners, when I
% convert to STL it is better that each face is a triangle. The same
% vertices are used, but the faces become triangles by shuffling
% them.


h.Vertices(:,3) = h.Vertices(:,3) - min(h.Vertices(:,3)); %Place at zero height

[finalPatch.vertices,finalPatch.faces]= ...
    patchslim(h.Vertices.*scale,[h.Faces(:,[1:3]); h.Faces(:,[3 4 1])]);

if doExport; stlwrite(fileName,finalPatch); end














