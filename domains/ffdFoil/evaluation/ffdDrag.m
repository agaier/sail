%% ffdDrag
% Get drag value of FFD deformation of RAE2822 foil
function [cD, cL, deformedFoil] = ffdDrag(deformation)
% deformation - [1X10] between 0 and 1 (0.5 == no deformation)

deformedFoil = ffdRaeY(deformation);
[cD, cL] = xfoilEvaluate(deformedFoil);

end