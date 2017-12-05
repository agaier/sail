% %% FFD - Adapted from PyGeM

%function newMeshPoints =  ffd(deformParams)
% meshPoints - original foil points and should be input for general use
% deformParams 
%- 

%%
mesh_points = importdata('original.csv');
deformation = importdata('deformVals.csv');

nMeshPoints = size(mesh_points,1);
nDimX = 7; nDimY = 2; nDimZ = 1;

deformation = reshape(deformation,[nDimY,nDimX,nDimZ])';

%% Skip rotations? 
%---
%%

%% Compute Bernstein polynomials
% These actually won't change if we keep deforming the same shape, so we
% can actually save the results and skip all the computation. But this is
% included for completeness sake (and so the shape produced can be changed)

% Scale to bounding box of deformation
yOrigin = -0.1; yHeight =  0.2;
mesh_points(:,2) = (mesh_points(:,2)-yOrigin)./yHeight;

% Preallocate

bernstein_x = zeros(nDimX,nMeshPoints);
bernstein_y = zeros(nDimY,nMeshPoints);
bernstein_z = zeros(nDimZ,nMeshPoints);
shift_mesh_points = zeros(size(mesh_points));

% Compute [check help bernstein for maybe a one liner?]
for i = 1:nDimX
   aux1 = (1-mesh_points(:,1)) .^(nDimX-i);
   aux2 = (  mesh_points(:,1)) .^(i-1);
   bernstein_x(i,:) = nchoosek(nDimX-1, i-1) .* (aux1' .* aux2');
end

for i = 1:nDimY
   aux1 = (1-mesh_points(:,2)) .^(nDimY-i);
   aux2 = (  mesh_points(:,2)) .^(i-1);
   bernstein_y(i,:) = nchoosek(nDimY-1, i-1) .* (aux1' .* aux2');
end

for i = 1:nDimZ
   aux1 = (1-mesh_points(:,3)) .^(nDimZ-i);
   aux2 = (  mesh_points(:,3)) .^(i-1);
   bernstein_z(i,:) = nchoosek(nDimZ-1, i-1) .* (aux1' .* aux2');
end

% Calculate shifts
aux_x = 0; aux_y = 0; aux_z = 0;
for j = 1:nDimY
   for k = 1:nDimZ
       bernstein_yz = bernstein_y(j,:) .* bernstein_z(k,:);
       for i = 1:nDimX
          aux = bernstein_x(i,:) .* bernstein_yz;
          aux_x = aux_x + aux .* 0; % We aren't deforming in X
          aux_y = aux_y + aux .* deformation(i, j, k);
          aux_z = aux_z + aux .* 0; % We aren't deforming in Z
       end
   end
end
shift_mesh_points(:,1) = shift_mesh_points(:,1) + aux_x(:);
shift_mesh_points(:,2) = shift_mesh_points(:,2) + aux_y(:);
shift_mesh_points(:,3) = shift_mesh_points(:,3) + aux_z(:);

% Apply shifts and unscale
newMeshPoints = mesh_points + shift_mesh_points;
newMeshPoints(:,2) = newMeshPoints(:,2)*yHeight+yOrigin;


%% Visual inspection
clf;

original = importdata('original.csv'); original = orderFoil(original);
h = fPlot(original,'k-'); h.LineWidth = 2;   hold on;

pygem_deformed = importdata('deformed.csv'); pygem_deformed = orderFoil(pygem_deformed);
h = fPlot(pygem_deformed,'b--'); h.LineWidth = 2;

my_deformed = orderFoil(newMeshPoints);
h = fPlot(my_deformed,'g:'); h.LineWidth = 2;

axis equal; grid;
legend({'Original','PyGeM Deformation','My Deformation'})

