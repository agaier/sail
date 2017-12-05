function foilCoords = orderFoil(original)
%% Order Foil
% Turns random foil coordinates into XFoil ready format
A = sortrows(original);
foilCoords = [A(end:-2:1,[1 2]);A(1:2:end,[1 2])]';
end