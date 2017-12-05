%% Visual Explainer for Param Encoding
d = velo_Domain('encoding','param');


%% Base mid range
clf
gene = 0.5+zeros(1,16);
% Plot mesh
cols = parula(8);
A = velo_param_Express(gene, d.repParams,'plotting',false);
figure(4);
patch('Faces',A.faces,'Vertices',A.vertices,'FaceAlpha',0.7,'FaceColor',cols(3,:),'LineStyle','none'); 
axis equal; axis tight;  grid off; hold on;
view([-65 20]);

lightangle(-65, 20)
lighting gouraud; light; material shiny


A = velo_param_Express(gene, d.repParams,'plotting',true);
grid off; yticks([]);xticks([]);zticks([])
for i=1:4; figure(i); grid off; yticks([]);xticks([]);zticks([]); save2pdf(['paramBase_' int2str(i)]);end

%% Random
clf
gene = [0.622475086001228,0.587044704531417,0.207742292733028,0.301246330279491,0.470923348517591,0.230488160211559,0.844308792695389,0.194764289567049,0.225921780972399,0.170708047147859,0.227664297816554,0.435698684103899,0.311102286650413,0.923379642103244,0.430207391329584,0.184816320124136];
%gene = rand(1,16);
A = velo_param_Express(gene, d.repParams,'plotting',false);
figure(4);
patch('Faces',A.faces,'Vertices',A.vertices,'FaceAlpha',0.7,'FaceColor',cols(3,:),'LineStyle','none'); 
axis equal; axis tight;  grid off; hold on;
view([-65 20]);

lightangle(-65, 20)
lighting gouraud; light; material shiny
velo_param_Express(gene, d.repParams,'plotting',true);
for i=1:4; figure(i); grid off; yticks([]);xticks([]);zticks([]); save2pdf(['paramRand_' int2str(i)]);end
