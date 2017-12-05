%% Visualized explainer for FFD
clear; clf; 
% Base Shape
newDeform = true;
cols = parula(8);
d = velo_Domain('encoding','ffd');
genome = 0.5+zeros(1,16);

if newDeform
 genome(15) = 1.5; % second to last Z only
 genome(1) = 0.1; % first lower y only
 genome(6) = 1; % second zy
end

A = d.express(genome);

h_base = patch('Faces',A.faces,'Vertices',A.vertices,'FaceAlpha',0.7,'FaceColor',cols(3,:),'LineStyle','none'); 


%axis equal; view([-50.8 14.8]); grid on;
axis equal; axis tight;  grid off; hold on;
view([-65 20]);

lightangle(-65, 20)
lighting gouraud; light; material shiny

%plot3D = @(x) plot3(x(1,:), x(2,:), x(3,:),'k.');
%h = plot3D(A.vertices')

% Divide Vertices into Ribs
A.vertices = round(A.vertices,3);
[C, IA, IC] = unique(A.vertices(:,1));

colors = jet(length(IA));
h = scatter3(A.vertices(:,1), A.vertices(:,2), A.vertices(:,3), 1);
h.CData = colors(IC,:);
h.Marker = 'o';


% Plot Each Set of Vertices as different Size (join them with illustrator)

%% Draw bounding box
%defValKey = [1,1,4,4,7,7,10,10,3,6,9,12;2,2,5,5,8,8,11,11,13,14,15,16;3,3,6,6,9,9,12,12,3,6,9,12];


nDimX = 6; nDimY = 3; nDimZ = 4;
xOrigin =  0.0;  xHeight =  2.5;
yOrigin =  -0.3; yHeight =  0.3;
zOrigin =  0.0;  zHeight =  0.6;

xCoords = linspace(xOrigin,xHeight,nDimX);
yCoords = linspace(yOrigin,yHeight,nDimY);
zCoords = linspace(zOrigin,zHeight,nDimZ);

X =[]; Y=[]; Z=[];
for xi=1:nDimX
    for yi=1:nDimY
        for zi=1:nDimZ
            X = [X xCoords(xi)]; Y = [Y yCoords(yi)];  Z = [Z zCoords(zi)];
        end
    end
end

if newDeform
    Z(44) = 0.7; % Pt 1
    Y(14) = -0.25;  Y(22) = 0.25; % Pt 2
    Y(28) = -0.35;  Z(28) = 0.65; % Pt 3
    Y(36) = 0.35;   Z(36) = 0.65;
end
pts = [X; Y; Z];

hold on
pp = @(p,varargin) plot3(p(1,:),p(2,:),p(3,:),varargin{:}) ;
b1 = [1 5 9 1:4 4:4:12 9:12];
for i=1:nDimX
    h = pp(pts(:,(12*(i-1))+b1),'k--o','MarkerSize',16)
end

for i=1:nDimY*nDimZ
    pp(pts(:,[i:12:72]),'k--o','MarkerSize',16)
end

for i=1:6
    ptStart = 0+(i-1)*12; ptEnd   = i*12; 
    for j=1:4
        pp(pts(:,[ptStart+j:4:ptEnd]),'k--o','MarkerSize',16)
    end
end

%axis([-0.1 2.6 -0.4 0.4 -0.1 0.7])
xlabel('X'); ylabel('Y');zlabel('Z'); set(gca,'FontSize',16)

%% Highlight control pts



%% Effect of control point changes







