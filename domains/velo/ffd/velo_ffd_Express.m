% %% FFD - Adapted from PyGeM
% TODO: Proper header and documentation

function [FV, validity, ffdP] = velo_ffd_Express(deformVals, base)
% meshPoints - original foil points and should be input for general use
% deformParams
%-
validity = true; % Do we really need to check anything?

deformVals = (deformVals*2)-1;
nDeforms = size(deformVals,1);
if ischar(base);    precomputed = false; fname= base;
else;               precomputed = true;  ffdP = base;
end

%% General Calculations (result saved for speed up)
if ~precomputed
    rawStl = stlread(fname);
    [meshPoints,faces] = patchslim(rawStl.vertices, rawStl.faces);
    nMeshPoints = size(meshPoints,1);
    
    % How the 16 parameters map to the 36 degrees of freedom
    defValKey = [1,1,4,4,7,7,10,10,3,6,9,12;2,2,5,5,8,8,11,11,13,14,15,16;3,3,6,6,9,9,12,12,3,6,9,12];
    
    % Direction of each active control point in each dimension
    nDimX = 6; nDimY = 3; nDimZ = 4;
    
    x = zeros([nDimZ,nDimY,nDimX]);
    
    y = zeros([nDimZ,nDimY,nDimX]);
    yWeights =  [   0, -1, -1, -0.5
        0,  0,  0,  0.0
        0,  1,  1,  0.5 ]';
    y(:,:,2:5) = repmat(yWeights,[1 1 4]);
    
    z = zeros([nDimZ,nDimY,nDimX]);
    zWeights =  [   0,  0,  0,  0.5
        0,  0,  0,  1.0
        0,  0,  0,  0.5 ]';
    z(:,:,2:5) = repmat(zWeights,[1 1 4]);
    
    allDefs = cat(4,x,y,z);
    
    % Indexes of active dimensions
    ffdDof = find(allDefs(:)~=0);
    
    %% Compute Bernstein polynomials
    % These won't change if we keep deforming the same shape, so we can
    % save the results and skip all the computation in later runs.
    
    % Scale to bounding box of deformation
    xOrigin =  0.0; xHeight =  2.5;
    yOrigin = -0.3; yHeight =  0.6;
    zOrigin =  0.0; zHeight =  0.6;
    meshPoints(:,1) = (meshPoints(:,1)-xOrigin)./xHeight;
    meshPoints(:,2) = (meshPoints(:,2)-yOrigin)./yHeight;
    meshPoints(:,3) = (meshPoints(:,3)-zOrigin)./zHeight;
    
    % Preallocate
    bernstein_x = zeros(nDimX,nMeshPoints);
    bernstein_y = zeros(nDimY,nMeshPoints);
    bernstein_z = zeros(nDimZ,nMeshPoints);
    shift_mesh_points = zeros(size(meshPoints));
    
    % Compute Bernstein polynomials
    for i = 1:nDimX
        aux1 = (1-meshPoints(:,1)) .^(nDimX-i);
        aux2 = (  meshPoints(:,1)) .^(i-1);
        bernstein_x(i,:) = nchoosek(nDimX-1, i-1) .* (aux1' .* aux2');
    end
    
    for i = 1:nDimY
        aux1 = (1-meshPoints(:,2)) .^(nDimY-i);
        aux2 = (  meshPoints(:,2)) .^(i-1);
        bernstein_y(i,:) = nchoosek(nDimY-1, i-1) .* (aux1' .* aux2');
    end
    
    for i = 1:nDimZ
        aux1 = (1-meshPoints(:,3)) .^(nDimZ-i);
        aux2 = (  meshPoints(:,3)) .^(i-1);
        bernstein_z(i,:) = nchoosek(nDimZ-1, i-1) .* (aux1' .* aux2');
    end
    
    %% Save Precomputable
    ffdP.faces   = faces;
    ffdP.allDefs = allDefs;
    ffdP.defValKey = defValKey;
    ffdP.ffdDof = ffdDof;
    ffdP.mesh_points = meshPoints;
    ffdP.nDimX = nDimX;
    ffdP.bernstein_x = bernstein_x;
    ffdP.nDimY = nDimY;
    ffdP.bernstein_y = bernstein_y;
    ffdP.nDimZ = nDimZ;
    ffdP.bernstein_z = bernstein_z;
    ffdP.xOrigin =  0.0; ffdP.xHeight =  2.5;
    ffdP.yOrigin = -0.3; ffdP.yHeight =  0.6;
    ffdP.zOrigin =  0.0; ffdP.zHeight =  0.6;
    ffdP.shift_mesh_points = shift_mesh_points;
    ffdP.unpack  = 'names = fieldnames(ffdP); for i=1:length(names) eval( [names{i},''= ffdP.'', names{i}, '';''] ); end';
else
%     eval(ffdP.unpack); % It takes twice as long to evaluate this string
%                        % then just run this stuff below
    faces               = ffdP.faces;
    allDefs             = ffdP.allDefs;
    defValKey           = ffdP.defValKey ;
    ffdDof              = ffdP.ffdDof;
    meshPoints          = ffdP.mesh_points;
    nDimX               = ffdP.nDimX;
    bernstein_x         = ffdP.bernstein_x ;
    nDimY               = ffdP.nDimY;
    bernstein_y         = ffdP.bernstein_y;
    nDimZ               = ffdP.nDimZ;
    bernstein_z         = ffdP.bernstein_z;
    xOrigin             = ffdP.xOrigin; 
    xHeight             = ffdP.xHeight;
    yOrigin             = ffdP.yOrigin; 
    yHeight             = ffdP.yHeight;
    zOrigin             = ffdP.zOrigin; 
    zHeight             = ffdP.zHeight;
    shift_mesh_points   = ffdP.shift_mesh_points;
end

%% Deformation Parameter Specific Calculations
def(:,1:nDeforms) = deformVals(1:nDeforms,defValKey(:))'; 

allDeforms = permute(repmat(allDefs,[1 1 1 1 nDeforms]),[5 1 2 3 4]);
allDeforms(1:nDeforms,ffdDof) = allDeforms(1:nDeforms,ffdDof).*def(:,1:nDeforms)';

% Calculate shifts
aux_x = zeros(nDeforms,1); aux_y = aux_x;  aux_z = aux_x;
for j = 1:nDimY
    for k = 1:nDimZ
        bernstein_yz = bernstein_y(j,:) .* bernstein_z(k,:);
        for i = 1:nDimX
            aux = bernstein_x(i,:) .* bernstein_yz;
            %aux_x = aux_x + aux .* allDeforms(:, k, j, i, 1); % We aren't deforming in X
            aux_y = aux_y + aux .* allDeforms(:, k, j, i, 2);
            aux_z = aux_z + aux .* allDeforms(:, k, j, i, 3);
        end
    end
end

all_smp = permute(repmat(shift_mesh_points,[1,1,nDeforms]),[3 1 2]);
%all_smp(:,:,1) = all_smp(:,:,1) + aux_x; % We aren't deforming in X
all_smp(:,:,2) = all_smp(:,:,2) + aux_y;
all_smp(:,:,3) = all_smp(:,:,3) + aux_z;

% Apply shifts and unscale
all_mp = permute(repmat(meshPoints,[1,1,nDeforms]),[3 1 2]);
newMeshPoints = all_mp + all_smp;

newMeshPoints(:,:,1) = newMeshPoints(:,:,1).*xHeight+xOrigin;
newMeshPoints(:,:,2) = newMeshPoints(:,:,2).*yHeight+yOrigin;
newMeshPoints(:,:,3) = newMeshPoints(:,:,3).*zHeight+zOrigin;

%% Save as faces and vertices
for iDeforms = 1:nDeforms
    FV(iDeforms).faces = faces;
    FV(iDeforms).vertices = squeeze(newMeshPoints(iDeforms,:,:));
end


