function [valid, validTop, validBot] = getValidity(ul,ll, p)
% getValidity - Validates airfoil
% Returns true if no airfoil lines cross and highest top and bottom points
% are in the correct positions.
    valid = true(1,3);
    
    % Lines intersect?
    ul = fliplr(ul);
    valid(1) = all(ul(2,2:end-1) > ll(2,2:end-1));
    
    % Top Cambers where they are supposed to be?
    [topCamber, topCamberIndx] = max(ul(2,:));
    upperCambers = [p(2), p(3);ul(1,topCamberIndx), topCamber];
    valid(2) = all( abs(diff(upperCambers)) < 1e-1);
    
    % Bottom Cambers where they are supposed to be?
    [botCamber, botCamberIndx] = min(ll(2,:));
    lowerCambers = [p(6), p(7);ll(1,botCamberIndx), botCamber];
    valid(3) = all( abs(diff(lowerCambers)) < 1e-1);
    
    if nargout < 3
        valid = all(valid);
    end
    
end