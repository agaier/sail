% GUI Update
% Updates GUI after xPos and yPos change
global nMaps

handles.current.XData = xPos;
handles.current.YData = yPos;

foil = handles.d.express(handles.map.genes(xPos,yPos,:));
handles.foil.XData = foil(1,:);
handles.foil.YData = foil(2,:);

if nMaps==2
    foil2 = handles.d2.express(handles.map2.genes(xPos,yPos,:));
    handles.foil2.XData = foil2(1,:);
    handles.foil2.YData = foil2(2,:);
    %area = polyarea(foil2(1,:), foil2(2,:));
    %areaPenalty = (1-(abs(area-handles.d2.base.area)./handles.d2.base.area)).^7
end

drawnow;