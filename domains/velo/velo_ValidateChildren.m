function validity = velo_ValidateChildren(children,d)    

parfor i=1:size(children,1)
    validity(i) = expressVelo(children(i,:)','validateOnly',true);    
end