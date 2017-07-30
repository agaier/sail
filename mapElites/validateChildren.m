function validity = validateChildren(children,p)    

[~, ul, ll, parsecParams] = p.express(children);
for i=1:p.nChildren
    % TODO: Vectorize getValidity
    validity(i) = getValidity(ul(:,:,i),ll(:,:,i),parsecParams(i,:)); %#ok<AGROW>
end