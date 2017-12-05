%% Visualized explainer for FFD
clear; clf; 
% Base Shape
newDeform = true;
cols = parula(8);
d = velo_Domain('encoding','ffd'); % Creates lines in 3 figures
genome = 0.5+zeros(1,16);
A = d.express(genome);

%for lighten = 1:2
for i=4:4
    figure(i)
    h_base = patch('Faces',A.faces,'Vertices',A.vertices,'FaceAlpha',0.0,'FaceColor',cols(3,:),'LineStyle','none'); 
    axis equal; axis tight;  grid off; hold on; view([-65 20]);
    lightangle(-65, 20)
    lighting gouraud; light; material shiny
    xticks('');yticks('');zticks('');
 end
% end
% figure(1); view(90,0); save2pdf('view1.pdf')
% figure(2); view(0,0);  save2pdf('view2.pdf')
% figure(3); view(0,90); save2pdf('view3.pdf')

%%
%plot3D = @(x) plot3(x(1,:), x(2,:), x(3,:),'k.');
%h = plot3D(A.vertices')

% Divide Vertices into Ribs
A.vertices = round(A.vertices,3);
[C, IA, IC] = unique(A.vertices(:,1));

colors = jet(length(IA));
h = scatter3(A.vertices(:,1), A.vertices(:,2), A.vertices(:,3), 1);
h.CData = colors(IC,:);
h.Marker = 'o';









