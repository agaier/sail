function validity = af_ValidateChildren(children,d)    

[~, ul, ll, parsecParams] = d.express(children);
for i=1:size(children,1)
    % TODO: Vectorize getValidity
    validity(i) = getValidity(ul(:,:,i),ll(:,:,i),parsecParams(i,:)); %#ok<AGROW>
end