function validity = velo_ValidateChildren(children,d)    

parfor i=1:p.nChildren
    validity(i) = expressVelo(children(i,:)','validateOnly',true);    
end